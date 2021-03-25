//
//  MainNavigationController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/22/21.
//

import UIKit

class MainNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = nil
    }
}
