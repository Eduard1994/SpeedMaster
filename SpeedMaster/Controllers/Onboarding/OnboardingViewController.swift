//
//  OnboardingViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/23/21.
//

import UIKit
import StoreKit

protocol UpgradeFromOnboardingDelegate: class {
    func dismissFromUpgrade()
    func purchased(purchases: [ProductID])
}

class OnboardingViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var snakePageControl: SnakePageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - Properties
    var slides: [Slide] = []
    let service = Service()
    var productIDs: Set<ProductID> = []
//    var monthlyPrice: String = ""
    var subscriptions: Subscriptions = Subscriptions()
    
    weak var delegate: UpgradeFromOnboardingDelegate?
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: dismissNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: subTypeNotificationIndex, object: nil)
    }
    
    // MARK: - Functions
    private func configureView() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifiedToDismiss), name: dismissNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifiedForProductIndex(notification:)), name: subTypeNotificationIndex, object: nil)
        
        slides = Slide.slides
        
        scrollView.delegate = self
        
        setupSlideScrollView(slides: slides)
        
        getOnboardingTitles()
        
        nextButton.isEnabled = true
        nextButton.isHidden = false
        nextButton.cornerRadius(to: 10)
        
        snakePageControl.pageCount = slides.count
        snakePageControl.progress = 0
        snakePageControl.previousTint = .mainDarkGray
        
        view.bringSubviewToFront(snakePageControl)
    }
    
    /// Get Onboarding Titles
    func getOnboardingTitles() {
        service.getOnboardingTitles(for: PremiumTab.Onboarding.rawValue) { (onboarding, error) in
            if let error = error {
                for slide in self.slides {
                    DispatchQueue.main.async {
                        ErrorHandling.showError(message: error.localizedDescription, controller: self)
                        self.configureSlideLabels(slide: slide, onboarding: OnboardingTitle(), subscriptions: self.subscriptions)
                    }
                }
                return
            }
            if let onboarding = onboarding {
                for slide in self.slides {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.configureSlideLabels(slide: slide, onboarding: onboarding, subscriptions: self.subscriptions)
                    }
                }
            }
        }
    }
    
    private func configureSlideLabels(slide: Slide, onboarding: OnboardingTitle, subscriptions: Subscriptions) {
        if allPrices.count > 0 {
            for (title, price) in allPrices {
                if title.contains("Monthly") {
                    slide.startFreeLabel.text = "\(onboarding.secondTitle) \(price) a month"
                } else if title.contains("Yearly") {
                    slide.startYearlySecondButton.setTitle("\(price) \(onboarding.startYearlySecondTitle)", for: UIControl.State())
                }
            }
        } else {
            slide.startFreeLabel.text = "\(onboarding.secondTitle) -- a month"
            slide.startYearlySecondButton.setTitle("-- \(onboarding.startYearlySecondTitle)", for: UIControl.State())
        }
        
        slide.notNowButton.isHidden = !onboarding.closeButton
        slide.notNowButton.isEnabled = onboarding.closeButton
        slide.upgradeLabel.text = onboarding.firstTitle
//        slide.startFreeLabel.text = "\(onboarding.secondTitle) $\(subscriptions.monthlyProductPrice) a month"
        slide.proceedWithBasic.setTitle(onboarding.basicTitle, for: UIControl.State())
        slide.tryFreeButton.setTitle(onboarding.tryFreeTitle, for: UIControl.State())
        slide.startYearlyButton.setTitle(onboarding.startYearlyFirstTitle, for: UIControl.State())
//        slide.startMonthlySecondButton.setTitle("$\(subscriptions.monthlyProductPrice) \(onboarding.startMonthlySecondTitle)", for: UIControl.State())
        
        slide.privacyLabel.text = onboarding.privacyEulaTitle
        slides[0].gpsLabel.text = onboarding.gpsTitle
        slides[0].trackLabel.text = onboarding.gpsSecondTitle
        slides[1].gpsLabel.text = onboarding.tripTitle
        slides[1].trackLabel.text = onboarding.tripSecondTitle
    }
    
    /// Setting up Slide Scroll View
    func setupSlideScrollView(slides: [Slide]) {
        let viewWidth = view.frame.width
        let viewHeight = view.frame.height
        let slidesCount = slides.count
        
        scrollView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        scrollView.contentSize = CGSize(width: viewWidth * CGFloat(slidesCount), height: viewHeight)
        scrollView.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: viewWidth * CGFloat(i), y: 0, width: viewWidth, height: viewHeight)
            scrollView.addSubview(slides[i])
        }
    }
    
    func setupScrollViewDidScroll(scrollView: UIScrollView, pageIndex: CGFloat) {
        snakePageControl.progress = pageIndex
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            snakePageControl.previousTint = .mainDarkGray
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            snakePageControl.previousTint = .mainYellow
        }
        
        if percentOffset.x > 0.7 {
            snakePageControl.isHidden = true
            nextButton.isHidden = true
            nextButton.isEnabled = false
        } else {
            nextButton.isHidden = false
            nextButton.isEnabled = true
            snakePageControl.isHidden = false
        }
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
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.purchased(purchases: [purchase.productId])
                })
            case .error(let error):
                self.hideAnimatedActivityIndicatorView()
                ErrorHandling.showError(title: "Purchase failed", message: error.localizedDescription, controller: self)
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
    
    // MARK: - OBJC Functions
    @objc func notifiedToDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func notifiedForProductIndex(notification: Notification) {
        if let index = notification.userInfo?["index"] as? Int {
            if snakePageControl.currentPage == 2 {
                if service.isConnectedToInternet {
                    for productID in productIDs {
                        if productID.contains("month") && index == 0 {
                            purchaseItem(productID: productID)
                        } else if productID.contains("year") && index == 2 {
                            purchaseItem(productID: productID)
                        }
                    }
                } else {
                    ErrorHandling.showError(message: "Check Internet Connection and try again.", controller: self)
                }
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func nextTapped(_ sender: Any) {
        var frame = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat((snakePageControl.currentPage + 1))
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
    }
}

// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {
    /*
     * default function called when view is scrolled. In order to enable callback
     * when scrollview is scrolled, the below code needs to be called:
     * slideScrollView.delegate = self or
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setupScrollViewDidScroll(scrollView: scrollView, pageIndex: scrollView.contentOffset.x/view.frame.width)
    }
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        print("here")
    }
}
