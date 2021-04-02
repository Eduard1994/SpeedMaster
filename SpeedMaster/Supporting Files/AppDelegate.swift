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
        
        UITabBar.setTransparentTabBar()
        FirebaseApp.configure()
        
//        checkUser()
        setupIAP()
        
        Switcher.shared.updateRootVC()
        return true
    }
    
    // MARK: - Functions
    private func checkUser() {
        Service().checkUser { (user, error) in
            if let user = user, error == nil {
                print(user)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    // MARK: - Setup IAP
    func setupIAP() {
        iapHelper = IAPHelper.shared
        
        iapHelper.setupIAP()
        
    }
}

