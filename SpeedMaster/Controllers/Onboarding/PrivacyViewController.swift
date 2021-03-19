//
//  PrivacyViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/17/21.
//

import UIKit

class PrivacyViewController: UIViewController {
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var bulletedLabel: UILabel!
    
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
        acceptButton.cornerRadius(to: 10)
        
        let strings = ["Device-specific information like OS version and hardware model.", "Payment information and optional email, when you purchase a paid plan. We do not keep logs of your online activities and never associate any domains or applications that you use with you, your device, IP address, or email.", "For a better experience, while using our Service, we may require you to provide us with certain personally identifiable information. The information that we request will be retained by us and used as described in privacy policy."]
        
        bulletedLabel.attributedText = bulletedList(strings: strings, textColor: .mainBlack, font: .sfProText(ofSize: 15, style: .medium), bulletColor: .mainYellow, bulletSize: .mainBullet)
    }
    
    // MARK: - IBActions
    @IBAction func acceptTapped(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: kStatus)
        Switcher.updateRootVC(showLaunch: false)
    }
}
