//
//  UpgradeToPremiumViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import UIKit

class UpgradeToPremiumViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var upgradeLabel: UILabel!
    @IBOutlet weak var startFreeLabel: UILabel!
    
    @IBOutlet weak var proceedWithBasicButton: UIButton!
    @IBOutlet weak var tryFreeButton: UIButton!
    @IBOutlet weak var startMonthlyView: UIView!
    @IBOutlet weak var startMonthlyButton: UIButton!
    @IBOutlet weak var priceAMonthButton: UIButton!
    @IBOutlet weak var trialLabel: UILabel!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var eulaButton: UIButton!
    @IBOutlet weak var notNowButton: UIButton!
    
    // MARK: - Properties
    let service = Service()
    var subscriptions: Subscriptions = Subscriptions()
    
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
        self.notNowButton.isHidden = !onboarding.closeButton
        self.notNowButton.isEnabled = onboarding.closeButton
        self.upgradeLabel.text = onboarding.firstTitle
        self.startFreeLabel.text = "\(onboarding.secondTitle) $\(subscriptions.monthlyProductPrice) a month"
        self.proceedWithBasicButton.setTitle(onboarding.basicTitle, for: UIControl.State())
        self.tryFreeButton.setTitle(onboarding.tryFreeTitle, for: UIControl.State())
        self.startMonthlyButton.setTitle(onboarding.startMonthlyFirstTitle, for: UIControl.State())
        self.priceAMonthButton.setTitle("$\(subscriptions.monthlyProductPrice) \(onboarding.startMonthlySecondTitle)", for: UIControl.State())
        self.trialLabel.text = onboarding.privacyEulaTitle
    }
    
    // MARK: - IBActions
    @IBAction func proceedWithBasicTapped(_ sender: Any) {
        print("Proceed tapped")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tryFreeTapped(_ sender: Any) {
        print("Try free tapped")
    }
    
    @IBAction func startMonthlyTapped(_ sender: Any) {
        print("Start Monthly Tapped")
    }
    
    @IBAction func notNowTapped(_ sender: Any) {
        print("Not now tapped")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func privacyTapped(_ sender: Any) {
        openURL(path: kPolicyURL)
    }
    
    @IBAction func eulaTapped(_ sender: Any) {
        openURL(path: kTermsURL)
    }
}
