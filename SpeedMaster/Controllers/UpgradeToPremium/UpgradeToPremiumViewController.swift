//
//  UpgradeToPremiumViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import UIKit

protocol UpgradeFromHistoryDelegate: class {
    func dismissFromUpgrade()
    func purchased(purchases: [ProductID])
}

class UpgradeToPremiumViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBOutlet weak var startFreeLabel: UILabel!
    @IBOutlet weak var thenLabel: UILabel!
    
    @IBOutlet weak var proceedWithBasicButton: UIButton!
    @IBOutlet weak var tryFreeButton: UIButton!
    @IBOutlet weak var startMonthlyView: UIView!
//    @IBOutlet weak var startMonthlyButton: UIButton!
//    @IBOutlet weak var priceAMonthButton: UIButton!
    @IBOutlet weak var startYearlyButton: UIButton!
    @IBOutlet weak var priceAYearButton: UIButton!
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var eulaButton: UIButton!
    @IBOutlet weak var notNowButton: UIButton!
//    @IBOutlet weak var fromBlackToStart: NSLayoutConstraint! // default 61
    @IBOutlet weak var fromBlackToThen: NSLayoutConstraint! //default 61
    //    @IBOutlet weak var fromTryFreeToProceed: NSLayoutConstraint! //default 24
    @IBOutlet weak var fromStartYearlyToProceed: NSLayoutConstraint! // default 24
    
    // MARK: - Properties
    let service = Service()
    var productIDs: Set<ProductID> = []
//    var monthlyPrice: String = ""
//    var allPrices: [String: String] = [:]
    var subscriptions: Subscriptions = Subscriptions()
    
    weak var delegate: UpgradeFromHistoryDelegate?
    
    // MARK: - Override properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    
    // MARK: - View LyfeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - Functions
    private func configureView() {
        tryFreeButton.cornerRadius(to: 10)
        startMonthlyView.cornerRadius(to: 20)
        startMonthlyView.addBorder(width: 2.0, color: .mainYellow)
        proceedWithBasicButton.addLine(position: .LINE_POSITION_BOTTOM, color: .mainGray, width: 0.5)
        privacyButton.addLine(position: .LINE_POSITION_BOTTOM, color: .mainGray, width: 0.5)
        eulaButton.addLine(position: .LINE_POSITION_BOTTOM, color: .mainGray, width: 0.5)
        
        switch type {
        case .iPhone5_5S_5C_SE:
            fromBlackToThen.constant = 40
            fromStartYearlyToProceed.constant = 24
        case .iPhone6_6S_7_8_SE2:
            fromBlackToThen.constant = 61
            fromStartYearlyToProceed.constant = 24
        case .iPhone6Plus_6SPlus_7Plus_8Plus:
            fromBlackToThen.constant = 100
            fromStartYearlyToProceed.constant = 30
        case .iPhone12Mini:
            fromBlackToThen.constant = 130
            fromStartYearlyToProceed.constant = 40
        case .iPhoneX_XS_11Pro:
            fromBlackToThen.constant = 120
            fromStartYearlyToProceed.constant = 40
        case .iPhone12_12Pro:
            fromBlackToThen.constant = 130
            fromStartYearlyToProceed.constant = 50
        case .iPhoneXR_XSMax_11_11ProMax:
            fromBlackToThen.constant = 130
            fromStartYearlyToProceed.constant = 70
        case .iPhone12ProMax:
            fromBlackToThen.constant = 135
            fromStartYearlyToProceed.constant = 75
        default:
            fromBlackToThen.constant = 61
            fromStartYearlyToProceed.constant = 24
        }
        
        getOnboardingTitles()
    }
    
    /// Get Onboarding Titles
    private func getOnboardingTitles() {
        service.getOnboardingTitles(for: PremiumTab.Onboarding.rawValue) { (onboarding, error) in
            if let error = error {
                DispatchQueue.main.async {
                    ErrorHandling.showError(message: error.localizedDescription, controller: self)
                    self.configureSubscribeTitles(for: OnboardingTitle(), subscriptions: self.subscriptions)
                }
                return
            }
            if let onboarding = onboarding {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.configureSubscribeTitles(for: onboarding, subscriptions: self.subscriptions)
                }
            }
        }
    }
    
    private func configureSubscribeTitles(for onboarding: OnboardingTitle, subscriptions: Subscriptions) {
        if allPrices.count > 0 {
            for (title, price) in allPrices {
                if title.contains("Monthly") {
                    self.thenLabel.text = "\(onboarding.thirdTitle) \(price) a month"
                } else if title.contains("Yearly") {
                    self.priceAYearButton.setTitle("\(price) \(onboarding.startYearlySecondTitle)", for: UIControl.State())
                }
            }
        } else {
            self.thenLabel.text = "\(onboarding.thirdTitle) $11.49 a month"
            self.priceAYearButton.setTitle("$33.99 \(onboarding.startYearlySecondTitle)", for: UIControl.State())
        }
        
        self.notNowButton.isHidden = !onboarding.closeButton
        self.notNowButton.isEnabled = onboarding.closeButton
        self.upgradeLabel.text = onboarding.firstTitle
        self.startFreeLabel.text = onboarding.secondTitle
        self.proceedWithBasicButton.setTitle(onboarding.basicTitle, for: UIControl.State())
        self.tryFreeButton.setTitle(onboarding.tryFreeTitle, for: UIControl.State())
        self.startYearlyButton.setTitle(onboarding.startYearlyFirstTitle, for: UIControl.State())
        
        self.trialLabel.text = onboarding.privacyEulaTitle
        
        self.thenLabel.isHidden = onboarding.thirdTitleIsHidden
        self.priceAYearButton.isHidden = onboarding.startYearlySecondTitleIsHidden
    }
    
    /// Purchasing product
    private func purchaseItem(productID: String) {
        displayAnimatedActivityIndicatorView()
        IAPHelper.shared.purchase(productID, atomically: true) { (result) in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                IAPHelper.shared.finishPurchasing(purchase: purchase)
                self.hideAnimatedActivityIndicatorView()
                purchasedAny = true
                self.alert(title: "Purchase Success", message: "\(purchase.product.localizedTitle), \(purchase.product.localizedPrice ?? "")", preferredStyle: .alert, cancelTitle: nil, cancelHandler: nil, actionTitle: "OK", actionHandler: {
                    /// Firebase Analytics
                    SpeedAnalytics.shared.purchaseAnalytics(userID: User.currentUser?.uid ?? "", paymentType: purchase.product.localizedTitle, totalPrice: purchase.product.localizedPrice ?? "", success: "1", currency: purchase.product.priceLocale.currencySymbol ?? "USD")
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.purchased(purchases: [purchase.productId])
                })
            case .error(let error):
                self.hideAnimatedActivityIndicatorView()
                ErrorHandling.showError(title: "Purchase failed", message: error.localizedDescription, controller: self)
                /// Firebase Analytics
                SpeedAnalytics.shared.purchaseAnalytics(userID: User.currentUser?.uid ?? "", paymentType: error.localizedDescription, totalPrice: "", success: "0", currency: "USD")
                print("Purchase Failed: \(error)")
                switch error.code {
                case .unknown:
                    print("Purchase failed, \(error.localizedDescription)")
                case .clientInvalid: // client is not allowed to issue the request, etc.
                    print("Purchase failed, Not allowed to make the payment")
                case .paymentCancelled: // user cancelled the request, etc.
                    break
                case .paymentInvalid: // purchase identifier was invalid, etc.
                    print("Purchase failed, The purchase identifier was invalid")
                case .paymentNotAllowed: // this device is not allowed to make the payment
                    print("Purchase failed, The device is not allowed to make the payment")
                case .storeProductNotAvailable: // Product is not available in the current storefront
                    print("Purchase failed, The product is not available in the current storefront")
                case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                    print("Purchase failed, Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                    print("Purchase failed, Could not connect to the network")
                case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                    print("Purchase failed, Cloud service was revoked")
                default:
                    print("Purchase failed, \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func proceedWithBasicTapped(_ sender: Any) {
        print("Proceed tapped")
        dismiss(animated: true, completion: nil)
        self.delegate?.dismissFromUpgrade()
    }
    
    @IBAction func tryFreeTapped(_ sender: Any) {
        print("Try free tapped")
        SpeedAnalytics.shared.tappedToSubscribeButton(userID: User.currentUser?.uid ?? "", button: "Try Free Button")
        if service.isConnectedToInternet {
            for productID in productIDs {
                if productID.contains("month") {
                    purchaseItem(productID: productID)
                }
            }
        } else {
            ErrorHandling.showError(message: "Check Internet Connection and try again.", controller: self)
        }
        
    }
    
    @IBAction func startYearlyTapped(_ sender: Any) {
        print("Start Yearly Tapped")
        SpeedAnalytics.shared.tappedToSubscribeButton(userID: User.currentUser?.uid ?? "", button: "Start Yearly Button")
        if service.isConnectedToInternet {
            for productID in productIDs {
                if productID.contains("year") {
                    purchaseItem(productID: productID)
                }
            }
        } else {
            ErrorHandling.showError(message: "Check Internet Connection and try again.", controller: self)
        }
    }
    
//    @IBAction func startMonthlyTapped(_ sender: Any) {
//        print("Start Monthly Tapped")
//
//    }
    
    @IBAction func notNowTapped(_ sender: Any) {
        print("Not now tapped")
        dismiss(animated: true, completion: nil)
        self.delegate?.dismissFromUpgrade()
    }
    
    @IBAction func privacyTapped(_ sender: Any) {
        openURL(path: kPolicyURL)
    }
    
    @IBAction func eulaTapped(_ sender: Any) {
        openURL(path: kTermsURL)
    }
}
