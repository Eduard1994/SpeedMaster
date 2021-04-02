//
//  MainTabBarViewController.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    // MARK: - Properties
    /// Bouncing Animation
    /// - Return bounce animation as CAKeyframeAnimation
    private var bounceAnimation: CAKeyframeAnimation = {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.4, 0.9, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(0.3)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        return bounceAnimation
    }()
    
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
        
        let historyVC = UINavigationController.instantiate(from: .Main, with: "MainHistoryNavigationController")
        let speedometerVC = UINavigationController.instantiate(from: .Main, with: "MainSpeedometerNavigationController")
        let settingsVC = UINavigationController.instantiate(from: .Main, with: "MainSettingsNavigationController")
        
        let historyImage = imageNamed("historyIcon")
        let historySelectedImage = imageNamed("historyIconColored")
        historyVC.tabBarItem = UITabBarItem(title: nil, image: historyImage, tag: 0)
        historyVC.tabBarItem.selectedImage = historySelectedImage
        historyVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let speedometerImage = imageNamed("speedometerIcon")
        let speedometerSelectedImage = imageNamed("speedometerIconColored")
        speedometerVC.tabBarItem = UITabBarItem(title: nil, image: speedometerImage, tag: 1)
        speedometerVC.tabBarItem.selectedImage = speedometerSelectedImage
        speedometerVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let settingsImage = imageNamed("settingsIcon")
        let settingsSelectedImage = imageNamed("settingsIconColored")
        settingsVC.tabBarItem = UITabBarItem(title: nil, image: settingsImage, tag: 2)
        settingsVC.tabBarItem.selectedImage = settingsSelectedImage
        settingsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)

        let tabBarList = [historyVC, speedometerVC, settingsVC]
        
        print("tab bar height = \(tabBar.frame.size.height)")
        viewControllers = tabBarList
        
        selectedIndex = 1
    }
    
    // MARK: - Override Functions
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > idx + 1, let imageView = tabBar.subviews[idx + 1].subviews.compactMap({ $0 as? UIImageView }).first else {
            return
        }

        imageView.layer.add(bounceAnimation, forKey: nil)
    }
}
