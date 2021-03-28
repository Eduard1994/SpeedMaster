//
//  PremiumTitle.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import Foundation
import FirebaseDatabase

enum PremiumTab: String {
    case Onboarding = "Onboarding"
    case Settings = "Settings"
    case Subscribe = "Subscribe"
}

// MARK: - Onboarding Titles
struct OnboardingTitle {
    let ref: DatabaseReference?
    let key: String?
    var closeButton: Bool
    var firstTitle: String
    var secondTitle: String
    var basicTitle: String
    var gpsTitle: String
    var gpsSecondTitle: String
    var tripTitle: String
    var tripSecondTitle: String
    var tryFreeTitle: String
    var startMonthlyFirstTitle: String
    var startMonthlySecondTitle: String
    var privacyEulaTitle: String
    
    init(closeButton: Bool = false, firstTitle: String = "Upgrade to premium", secondTitle: String = "Enjoy full version of app without ads", gpsTitle: String = "GPS Speedometer", gpsSecondTitle: String = "Track your daily travelling activities with accurate speed data", tripTitle: String = "Trip History", tripSecondTitle: String = "Trip history is the automatic feature that will help you to save information within app", basicTitle: String = "Proceed with Basic", tryFreeTitle: String = "Try Free and subscribe", startMonthlyFirstTitle: String = "Start Monthly Plan", startMonthlySecondTitle: String = "$99.99 a month", privacyEulaTitle: String = "This trial automatically renews into a paidsubscribtion and will continue to automatically renew until you cancel. Please see our") {
        self.ref = nil
        self.key = nil
        self.closeButton = closeButton
        self.firstTitle = firstTitle
        self.secondTitle = secondTitle
        self.gpsTitle = gpsTitle
        self.gpsSecondTitle = gpsSecondTitle
        self.tripTitle = tripTitle
        self.tripSecondTitle = tripSecondTitle
        self.basicTitle = basicTitle
        self.tryFreeTitle = tryFreeTitle
        self.startMonthlyFirstTitle = startMonthlyFirstTitle
        self.startMonthlySecondTitle = startMonthlySecondTitle
        self.privacyEulaTitle = privacyEulaTitle
    }
    
    // MARK: - Init from Snapshot
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let closeButton = value["closeButton"] as? Bool,
            let firstTitle = value["firstTitle"] as? String,
            let secondTitle = value["secondTitle"] as? String,
            let gpsTitle = value["gpsTitle"] as? String,
            let gpsSecondTitle = value["gpsSecondTitle"] as? String,
            let tripTitle = value["tripTitle"] as? String,
            let tripSecondTitle = value["tripSecondTitle"] as? String,
            let basicTitle = value["basicTitle"] as? String,
            let tryFreeTitle = value["tryFreeTitle"] as? String,
            let startMonthlyFirstTitle = value["startMonthlyFirstTitle"] as? String,
            let startMonthlySecondTitle = value["startMonthlySecondTitle"] as? String,
            let privacyEulaTitle = value["privacyEulaTitle"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.closeButton = closeButton
        self.firstTitle = firstTitle
        self.secondTitle = secondTitle
        self.gpsTitle = gpsTitle
        self.gpsSecondTitle = gpsSecondTitle
        self.tripTitle = tripTitle
        self.tripSecondTitle = tripSecondTitle
        self.basicTitle = basicTitle
        self.tryFreeTitle = tryFreeTitle
        self.startMonthlyFirstTitle = startMonthlyFirstTitle
        self.startMonthlySecondTitle = startMonthlySecondTitle
        self.privacyEulaTitle = privacyEulaTitle
    }
    
    func toAnyObject() -> Any {
        return [
            "closeButton": closeButton,
            "firstTitle": firstTitle,
            "secondTitle": secondTitle,
            "gpsTitle": gpsTitle,
            "gpsSecondTitle": gpsSecondTitle,
            "tripTitle": tripTitle,
            "tripSecondTitle": tripSecondTitle,
            "basicTitle": basicTitle,
            "tryFreeTitle": tryFreeTitle,
            "startMonthlyFirstTitle": startMonthlyFirstTitle,
            "startMonthlySecondTitle": startMonthlySecondTitle,
            "privacyEulaTitle": privacyEulaTitle
        ]
    }
}

// MARK: - Subscribe Titles
struct SubscribeTitle {
    let ref: DatabaseReference?
    let key: String?
    var closeButton: Bool
    var firstTitle: String
    var annualFirstTitle: String
    var annualSecondTitle: String
    var monthlyFirstTitle: String
    var monthlySecondTitle: String
    var weeklyFirstTitle: String
    var weeklySecondTitle: String
    
    init(closeButton: Bool = false, firstTitle: String = "Upgrade to premium", annualFirstTitle: String = "Annual", annualSecondTitle: String = "3 day trial - then 9.99/month", monthlyFirstTitle: String = "Monthly", monthlySecondTitle: String = "3 day trial - then 9.99/month", weeklyFirstTitle: String = "Weekly", weeklySecondTitle: String = "3 day trial - then 6.99/month") {
        self.ref = nil
        self.key = nil
        self.closeButton = closeButton
        self.firstTitle = firstTitle
        self.annualFirstTitle = annualFirstTitle
        self.annualSecondTitle = annualSecondTitle
        self.monthlyFirstTitle = monthlyFirstTitle
        self.monthlySecondTitle = monthlySecondTitle
        self.weeklyFirstTitle = weeklyFirstTitle
        self.weeklySecondTitle = weeklySecondTitle
    }
    
    // MARK: - Init from Snapshot
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let closeButton = value["closeButton"] as? Bool,
            let firstTitle = value["firstTitle"] as? String,
            let annualFirstTitle = value["annualFirstTitle"] as? String,
            let annualSecondTitle = value["annualSecondTitle"] as? String,
            let monthlyFirstTitle = value["monthlyFirstTitle"] as? String,
            let monthlySecondTitle = value["monthlySecondTitle"] as? String,
            let weeklyFirstTitle = value["weeklyFirstTitle"] as? String,
            let weeklySecondTitle = value["weeklySecondTitle"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.closeButton = closeButton
        self.firstTitle = firstTitle
        self.annualFirstTitle = annualFirstTitle
        self.annualSecondTitle = annualSecondTitle
        self.monthlyFirstTitle = monthlyFirstTitle
        self.monthlySecondTitle = monthlySecondTitle
        self.weeklyFirstTitle = weeklyFirstTitle
        self.weeklySecondTitle = weeklySecondTitle
    }
    
    func toAnyObject() -> Any {
        return [
            "closeButton": closeButton,
            "firstTitle": firstTitle,
            "annualFirstTitle": annualFirstTitle,
            "annualSecondTitle": annualSecondTitle,
            "monthlyFirstTitle": monthlyFirstTitle,
            "monthlySecondTitle": monthlySecondTitle,
            "weeklyFirstTitle": weeklyFirstTitle,
            "weeklySecondTitle": weeklySecondTitle
        ]
    }
}

// MARK: - Settings Titles
struct SettingsTitle {
    let ref: DatabaseReference?
    let key: String?
    var firstTitle: String
    var secondTitle: String
    
    init(firstTitle: String = "Upgrade to premium", secondTitle: String = "Enjoy full version of app without ads") {
        self.ref = nil
        self.key = nil
        
        self.firstTitle = firstTitle
        self.secondTitle = secondTitle
    }
    
    // MARK: - Init from Snapshot
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let firstTitle = value["firstTitle"] as? String,
            let secondTitle = value["secondTitle"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.firstTitle = firstTitle
        self.secondTitle = secondTitle
    }
    
    func toAnyObject() -> Any {
        return [
            "firstTitle": firstTitle,
            "secondTitle": secondTitle
        ]
    }
}

