//
//  UpgradeFromSettingsViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import UIKit

class UpgradeFromSettingsViewController: UIViewController {

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
    }
}
