//
//  UpgradeFromSettingsViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import UIKit

class UpgradeFromSettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var upgradeView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var fullLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton!
    
    @IBOutlet weak var annualLabel1: UILabel!
    @IBOutlet weak var annualLabel2: UILabel!
    @IBOutlet weak var monthlyLabel1: UILabel!
    @IBOutlet weak var monthlyLabel2: UILabel!
    @IBOutlet weak var weeklyLabel1: UILabel!
    @IBOutlet weak var weeklyLabel2: UILabel!
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
        subscribeButton.cornerRadius(to: 10)
        upgradeView.cornerRadius(to: 25)
        stackView.subviews.forEach { (view) in
            view.cornerRadius(to: 15)
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
    }
    
    @IBAction func monthlyTapped(_ sender: Any) {
        setImagesForButton(tags: [110, 100, 120])
    }
    
    @IBAction func weeklyTapped(_ sender: Any) {
        setImagesForButton(tags: [120, 100, 110])
    }
    
    @IBAction func subscribeTapped(_ sender: Any) {
        print("Subscribe tapped")
    }
    
    @IBAction func termsTapped(_ sender: Any) {
        openURL(path: kTermsURL)
    }
    
    @IBAction func privacyTapped(_ sender: Any) {
        openURL(path: kPolicyURL)
    }
    
    @IBAction func restoreTapped(_ sender: Any) {
        print("Restore tapped")
    }
    
    @IBAction func notNowTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
