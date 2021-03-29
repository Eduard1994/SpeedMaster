//
//  Switcher.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/17/21.
//

import UIKit

class Switcher {
    static func updateRootVC(showLaunch: Bool = true) {
        let status = UserDefaults.standard.bool(forKey: kStatus)
        var rootVC: UIViewController?
        
        let launchView: UIView = {
            let views = Bundle.main.loadNibNamed("LaunchView", owner: nil, options: nil)
            let launch = views![0] as! UIView
            launch.translatesAutoresizingMaskIntoConstraints = false
            return launch
        }()
        
        func showLaunchView() {
            rootVC?.view.addSubview(launchView)
            rootVC?.view.pinAllEdges(to: launchView)
        }
        
        func removeLaunchView(animated: Bool) {
            UIView.animate(withDuration: animated ? 0.5 : 0, animations: {
                launchView.alpha = 0
            }, completion: { (completion) in
                launchView.removeFromSuperview()
            })
        }
        
        if status == true {
            rootVC = MainTabBarViewController.instantiate(from: .Main, with: MainTabBarViewController.typeName)
        } else {
            rootVC = PrivacyViewController.instantiate(from: .Onboarding, with: PrivacyViewController.typeName)
        }
        
        if showLaunch {
            showLaunchView()
            DispatchQueue.main.after(1.5) {
                removeLaunchView(animated: true)
            }
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        appDelegate.window?.backgroundColor = .mainWhite
        appDelegate.window?.makeKeyAndVisible()
    }
}




