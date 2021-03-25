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
import SwiftyStoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        checkUser()
        
        UITabBar.setTransparentTabBar()
        
        Switcher.updateRootVC()
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
}

