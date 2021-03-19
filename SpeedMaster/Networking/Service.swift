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
    case codes = "history"
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

let kUserDataKey = "current_user"
