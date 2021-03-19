//
//  UITabBar+Extension.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import UIKit

// MARK: - UITabBar Extension
extension UITabBar {
    static func setTransparentTabBar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}
