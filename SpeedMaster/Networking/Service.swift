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
import CoreLocation

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
                    print("User is nil")
                    completion(nil, .unowned(description: "Couldn't connect to Firebase"))
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
                
                User.currentUser = currentUser
                
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
                } else {
                    completion(nil, .unowned(description: "Couldn't connect to Firebase"))
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
                } else {
                    completion(nil, .unowned(description: "Couldn't connect to Firebase"))
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
                } else {
                    completion(nil, .unowned(description: "Couldn't connect to Firebase"))
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
                } else {
                    completion(nil, .unowned(description: "Couldn't connect to Firebase"))
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
    
    // MARK: - Adding history to Firebase
    func addNewHistory(history: History, completion: @escaping (Bool, NetworkError?) -> Void) {
        if isConnectedToInternet {
            guard let key = reference.childByAutoId().key else { return }
            let post = [
                "id": key,
                "userID": history.userID,
                "maxSpeed": history.maxSpeed,
                "minSpeed": history.minSpeed,
                "avrSpeed": history.avrSpeed,
                "windSpeed": history.windSpeed,
                "duration": history.duration,
                "distance": history.distance,
                "allSpeeds": history.allSpeeds,
                "date": history.date,
                "collapsed": history.collapsed,
                "speedMetric": history.speedMetric,
                "distanceMetric": history.distanceMetric
            ] as [String: Any]
            let childUpdates = [key: post]
            updateValues(userID: history.userID, childUpdates, completion: completion)
        } else {
            completion(false, .noInternet)
        }
    }
    
    private func updateValues(userID: String, _ values: [String : [String : Any]], completion: @escaping (Bool, NetworkError?) -> Void) {
        reference.child(userID).updateChildValues(values) { (error, reference) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, .unowned(description: error.localizedDescription))
                }
            }
            DispatchQueue.main.async {
                completion(true, nil)
            }
        }
    }
    
    // MARK: - Removing History from Firebase
    func removeHistory(withID: String, userID: String, completion: @escaping (NetworkError?) -> Void) {
        if isConnectedToInternet {
            reference.child(userID).child(withID).removeValue { (error, reference) in
                if let error = error {
                    completion(.unowned(description: error.localizedDescription))
                    return
                }
                completion(nil)
            }
        } else {
            completion(.noInternet)
        }
    }
    
    // MARK: - Getting weather data
    func getWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping(Weather?, NetworkError?) -> Void) {
        let semaphore = DispatchSemaphore (value: 0)
        let session = URLSession.shared
        
        guard let url = URL(string: "\(kWeatherURL)?lat=\(latitude)&lon=\(longitude)&appid=\(kWeatherAPIKey)") else { return }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = session.weatherTask(with: request) { (weather, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, .unowned(description: error.localizedDescription))
                }
            }
            
            if let response = response {
                print(response)
            }
            
            guard let weather = weather else {
                completion(nil, nil)
                return
            }
            DispatchQueue.main.async {
                completion(weather, nil)
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
