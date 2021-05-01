//
//  UpgradeFromSettingsViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import UIKit
import FirebaseAnalytics

protocol UpgradeFromSettingsDelegate: class {
    func dismissFromUpgrade()
    func purchased(purchases: [ProductID])
}

class UpgradeFromSettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var upgradeView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var fullLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    
    @IBOutlet weak var annualLabel1: UILabel!
    @IBOutlet weak var annualLabel2: UILabel!
    @IBOutlet weak var annualPriceLabel: UILabel!
    
    @IBOutlet weak var monthlyLabel1: UILabel!
    @IBOutlet weak var monthlyLabel2: UILabel!
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    
    @IBOutlet weak var weeklyLabel1: UILabel!
    @IBOutlet weak var weeklyLabel2: UILabel!
    @IBOutlet weak var weeklyPriceLabel: UILabel!
    
    @IBOutlet weak var notNowButton: UIButton!
    
    @IBOutlet weak var fullToTop: NSLayoutConstraint! //default 50
    
    // MARK: - Properties
    let service = Service()
    var productIDs: Set<ProductID> = []
    var monthlyPrice: String = "$11.49"
    var annualPrice: String = "$33.99"
    var weeklyPrice: String = "$3.49"
    var subscriptions = Subscriptions()
    
    var tapped: (annual: Bool, monthly: Bool, weekly: Bool) = (true, false, false)
    weak var delegate: UpgradeFromSettingsDelegate?
    
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
        tapped.annual = true
        tapped.weekly = false
        tapped.monthly = false
        
        subscribeButton.cornerRadius(to: 10)
        upgradeView.cornerRadius(to: 25)
        stackView.subviews.forEach { (view) in
            view.cornerRadius(to: 15)
        }
        
        switch type {
        case .iPhone5_5S_5C_SE:
            fullToTop.constant = 50
        case .iPhone6_6S_7_8_SE2:
            fullToTop.constant = 50
        case .iPhone6Plus_6SPlus_7Plus_8Plus:
            fullToTop.constant = 60
        case .iPhone12Mini:
            fullToTop.constant = 60
        case .iPhoneX_XS_11Pro:
            fullToTop.constant = 70
        case .iPhone12_12Pro:
            fullToTop.constant = 70
        case .iPhoneXR_XSMax_11_11ProMax:
            fullToTop.constant = 80
        case .iPhone12ProMax:
            fullToTop.constant = 80
        default:
            fullToTop.constant = 50
        }
        
        getSubscribeTitles()
    }
    
    /// Get Subscribe Titles
    private func getSubscribeTitles() {
        service.getSubscribeTitles(for: PremiumTab.Subscribe.rawValue) { (subscribe, error) in
            if let error = error {
                DispatchQueue.main.async {
                    ErrorHandling.showError(message: error.localizedDescription, controller: self)
                    self.configureSubscribeTitles(subscribe: SubscribeTitle(), subscriptions: self.subscriptions)
                }
                return
            }
            if let subscribe = subscribe {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.configureSubscribeTitles(subscribe: subscribe, subscriptions: self.subscriptions)
                }
            }
        }
    }
    
    private func configureSubscribeTitles(subscribe: SubscribeTitle, subscriptions: Subscriptions) {
        self.notNowButton.isHidden = !subscribe.closeButton
        self.notNowButton.isEnabled = subscribe.closeButton
        self.fullLabel.text = subscribe.firstTitle
        self.annualLabel1.text = subscribe.annualFirstTitle
//        self.annualLabel2.text = "\(subscribe.annualSecondTitle) $\(subscriptions.annualProductPrice)/year"
        self.annualLabel2.text = "\(subscribe.annualSecondTitle)"
        self.annualPriceLabel.text = "\(annualPrice)/year"
        self.monthlyLabel1.text = subscribe.monthlyFirstTitle
//        self.monthlyLabel2.text = "\(subscribe.monthlySecondTitle) $\(subscriptions.monthlyProductPrice)/month"
        self.monthlyLabel2.text = "\(subscribe.monthlySecondTitle)"
        self.monthlyPriceLabel.text = "\(monthlyPrice)/month"
        self.weeklyLabel1.text = subscribe.weeklyFirstTitle
//        self.weeklyLabel2.text = "\(subscribe.weeklySecondTitle) $\(subscriptions.weeklyProductPrice)/week"
        self.weeklyLabel2.text = "\(subscribe.weeklySecondTitle)"
        self.weeklyPriceLabel.text = "\(weeklyPrice)/week"
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
    
    /// Trying to restore purchases
    private func restorePurchases() {
        displayAnimatedActivityIndicatorView()
        IAPHelper.shared.restorePurchases { (results) in
            IAPHelper.shared.finishingRestoring(restoreResults: results)
            if results.restoreFailedPurchases.count > 0 {
                self.hideAnimatedActivityIndicatorView()
                ErrorHandling.showError(title: "Restore Failed", message: "Please check Internet Connectivity and try again or Contact Support", controller: self)
                print("Restore Failed: \(results.restoreFailedPurchases), Please contact support")
            } else if results.restoredPurchases.count > 0 {
                self.hideAnimatedActivityIndicatorView()
                purchasedAny = true
                self.alert(title: "Restored Successfully", message: nil, preferredStyle: .alert, cancelTitle: nil, cancelHandler: nil, actionTitle: "OK", actionHandler: {
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.purchased(purchases: results.restoredPurchases.compactMap{$0.productId})
                })
                print("Restore Success: \(results.restoredPurchases), All purchases have been restored")
            } else {
                print("Nothing to Restore, No previous purchases were found")
                self.hideAnimatedActivityIndicatorView()
                ErrorHandling.showError(title: "Nothing to Restore", message: "No previous purchases were found", controller: self)
            }
        }
    }
    
    // MARK: - Setting images for buttons
    private func setImagesForButton(tags: [Int]) {
        for i in 1...2 {
            stackView.subviews.forEach { (view) in
                if let button = view.viewWithTag(tags[i]) as? UIButton {
                    button.setImage(nil, for: .normal)
                    button.setBackgroundImage(imageNamed("checkBackgroundBlack"), for: .normal)
                }
            }
        }
        stackView.subviews.forEach { (view) in
            if let button = view.viewWithTag(tags[0]) as? UIButton {
                button.setImage(imageNamed("check"), for: .normal)
                button.setBackgroundImage(imageNamed("checkBackgroundBlue"), for: .normal)
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func annualTapped(_ sender: Any) {
        setImagesForButton(tags: [100, 110, 120])
        tapped.annual = true
        tapped.monthly = false
        tapped.weekly = false
        SpeedAnalytics.shared.tappedToSubscribeButton(userID: User.currentUser?.uid ?? "", button: "Annual Button")
    }
    
    @IBAction func monthlyTapped(_ sender: Any) {
        setImagesForButton(tags: [110, 100, 120])
        tapped.annual = false
        tapped.monthly = true
        tapped.weekly = false
        SpeedAnalytics.shared.tappedToSubscribeButton(userID: User.currentUser?.uid ?? "", button: "Monthly Button")
    }
    
    @IBAction func weeklyTapped(_ sender: Any) {
        setImagesForButton(tags: [120, 100, 110])
        tapped.annual = false
        tapped.monthly = false
        tapped.weekly = true
        SpeedAnalytics.shared.tappedToSubscribeButton(userID: User.currentUser?.uid ?? "", button: "Weekly Button")
    }
    
    @IBAction func subscribeTapped(_ sender: Any) {
        print("Subscribe tapped")
        print(tapped)
        if service.isConnectedToInternet {
            for productID in productIDs {
                if productID.contains("week") && tapped.weekly {
                    purchaseItem(productID: productID)
                } else if productID.contains("moth") && tapped.monthly {
                    purchaseItem(productID: productID)
                } else if productID.contains("year") && tapped.annual {
                    purchaseItem(productID: productID)
                }
            }
        } else {
            ErrorHandling.showError(message: "Check Internet Connection and try again.", controller: self)
        }
    }
    
    @IBAction func termsTapped(_ sender: Any) {
        openURL(path: kTermsURL)
    }
    
    @IBAction func privacyTapped(_ sender: Any) {
        openURL(path: kPolicyURL)
    }
    
    @IBAction func restoreTapped(_ sender: Any) {
        print("Restore tapped")
        restorePurchases()
    }
    
    @IBAction func notNowTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.delegate?.dismissFromUpgrade()
    }
}
