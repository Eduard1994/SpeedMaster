//
//  Service.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Alamofire

enum PremiumSubscriptionType: String {
    case annual = "annualProduct"
    case monthly = "monthlyProduct"
    case weekly = "weeklyProduct"
}

enum FirebaasePath: String {
    case histories = "histories"
    case users = "users"
    case premiumTitles = "premiumTitles"
    case premiumSubscriptions = "premiumSubscriptions"
}

enum NetworkError: Error {
    case unowned(description: String)
    case noInternet
    
    var localizedDescription: String {
        switch self {
        case .unowned(description: let description): return description
        case .noInternet: return "Check internet connectivity and try again!"
        }
    }
}

class Service {
    // MARK: - Properties
    let reference = Database.database().reference(withPath: FirebaasePath.histories.rawValue)
    let premiumTitlesReference = Database.database().reference(withPath: FirebaasePath.premiumTitles.rawValue)
    let premiumSubscriptionsReference = Database.database().reference(withPath: FirebaasePath.premiumSubscriptions.rawValue)
    let usersReference = Database.database().reference(withPath: FirebaasePath.users.rawValue)
    
    let path = URL(fileURLWithPath: NSTemporaryDirectory())
    
    let queue = DispatchQueue.global(qos: .userInitiated)
    let group = DispatchGroup()
    
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    // MARK: - Check Firebase User
    func checkUser(completion: @escaping (User?, NetworkError?) -> Void) {
        if isConnectedToInternet {
            let disk = DiskStorage(path: path)
            let storage = CodableStorage(storage: disk)
            
            Auth.auth().signInAnonymously { (authResult, error) in
                if let error = error {
                    completion(nil, .unowned(description: error.localizedDescription))
                    return
                }
                
                guard let user = authResult?.user else {
                    return
                }
                
                let currentUser = User(authData: user)
                
                do {
                    try storage.save(currentUser, for: kUserDataKey)
                } catch {
                    print(error.localizedDescription)
                }
                
                let uniqueDeviceID = UIDevice.current.identifierForVendor!.uuidString
                
                let currentUserReference = self.usersReference.child(user.uid)
                currentUserReference.setValue(uniqueDeviceID)
                
                print("User is = \(uniqueDeviceID), \(currentUser.uid)")
                
                completion(currentUser, nil)
            }
        } else {
            completion(nil, .noInternet)
        }
    }
    
    // MARK: - Getting Subscriptions
    func getSubscriptions(completion: @escaping (Set<ProductID>?, NetworkError?) -> Void) {
        if isConnectedToInternet {
            premiumSubscriptionsReference.observe(.value) { (snapshot) in
                if let subscriptions = Subscriptions(snapshot: snapshot) {
                    let annualProductID = subscriptions.annualProductID
                    let monthlyProductID = subscriptions.monthlyProductID
                    let weeklyProductID = subscriptions.weeklyProductID
                    
                    let productIDs: Set<ProductID> = [annualProductID, monthlyProductID, weeklyProductID]
                    
                    completion(productIDs, nil)
                }
            }
        } else {
            completion(nil, .noInternet)
        }
    }
    
    // MARK: - Getting Onboarding Titles
    func getOnboardingTitles(for premium: PremiumTab.RawValue, completion: @escaping(OnboardingTitle?, NetworkError?) -> Void) {
        if isConnectedToInternet {
            premiumTitlesReference.child(premium).observe(.value) { (snapshot) in
                if let title = OnboardingTitle(snapshot: snapshot) {
                    completion(title, nil)
                }
            }
        } else {
            completion(nil, .noInternet)
        }
    }
    
    // MARK: - Getting Subscribe Titles
    func getSubscribeTitles(for premium: PremiumTab.RawValue, completion: @escaping(SubscribeTitle?, NetworkError?) -> Void) {
        if isConnectedToInternet {
            premiumTitlesReference.child(premium).observe(.value) { (snapshot) in
                if let title = SubscribeTitle(snapshot: snapshot) {
                    completion(title, nil)
                }
            }
        } else {
            completion(nil, .noInternet)
        }
    }
    
    // MARK: - Getting Settings Titles
    func getSettingsTitles(for premium: PremiumTab.RawValue, completion: @escaping(SettingsTitle?, NetworkError?) -> Void) {
        if isConnectedToInternet {
            premiumTitlesReference.child(premium).observe(.value) { (snapshot) in
                if let title = SettingsTitle(snapshot: snapshot) {
                    completion(title, nil)
                }
            }
        } else {
            completion(nil, .noInternet)
        }
    }
    
    // MARK: - Getting histories from Firebase
    func getHistories(userID: String, completion: @escaping ([History]?, NetworkError?) ->()) {
        if isConnectedToInternet {
            reference.child(userID).observe(.value) { (snapshot) in
                var newHistories: [History] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot {
                        if let code = History(snapshot: snapshot) {
                            newHistories.insert(code, at: 0)
                        }
                    }
                }
                completion(newHistories, nil)
            }
        } else {
            completion(nil, .noInternet)
        }
    }
}
