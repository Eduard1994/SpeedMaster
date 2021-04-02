//
//  AppDelegate.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/17/21.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var iapHelper: IAPHelper!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// TabBar Transparency Configuration
        UITabBar.setTransparentTabBar()
        /// Firebase App Config
        FirebaseApp.configure()
        /// Setting Up In-App Purchase
        setupIAP()
        /// Setting Main Switcher for App
        Switcher.shared.updateRootVC()
        
        return true
    }
    
    // MARK: - Setup IAP
    func setupIAP() {
        iapHelper = IAPHelper.shared
        iapHelper.setupIAP()
    }
}

