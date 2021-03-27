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
