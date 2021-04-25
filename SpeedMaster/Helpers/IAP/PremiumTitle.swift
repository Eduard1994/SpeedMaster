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
    var thirdTitle: String
    var thirdTitleIsHidden: Bool
    var basicTitle: String
    var gpsTitle: String
    var gpsSecondTitle: String
    var tripTitle: String
    var tripSecondTitle: String
    var tryFreeTitle: String
    var startYearlyFirstTitle: String
    var startYearlySecondTitle: String
    var startYearlySecondTitleIsHidden: Bool
    var privacyEulaTitle: String
    
    init(closeButton: Bool = true, firstTitle: String = "Upgrade to premium", secondTitle: String = "Start your 3-day free trial.", thirdTitle: String = "Then", thirdTitleIsHidden: Bool = false, gpsTitle: String = "GPS Speedometer", gpsSecondTitle: String = "Track your daily travelling activities with accurate speed data", tripTitle: String = "Trip History", tripSecondTitle: String = "Trip history is the automatic feature that will help you to save information within app", basicTitle: String = "Proceed with Basic", tryFreeTitle: String = "Try Free and Subscribe", startYearlyFirstTitle: String = "Start Yearly Plan", startYearlySecondTitle: String = "a year", startYearlySecondTitleIsHidden: Bool = false, privacyEulaTitle: String = "This trial automatically renews into a paidsubscribtion and will continue to automatically renew until you cancel. Please see our") {
        self.ref = nil
        self.key = nil
        self.closeButton = closeButton
        self.firstTitle = firstTitle
        self.secondTitle = secondTitle
        self.thirdTitle = thirdTitle
        self.thirdTitleIsHidden = thirdTitleIsHidden
        self.gpsTitle = gpsTitle
        self.gpsSecondTitle = gpsSecondTitle
        self.tripTitle = tripTitle
        self.tripSecondTitle = tripSecondTitle
        self.basicTitle = basicTitle
        self.tryFreeTitle = tryFreeTitle
        self.startYearlyFirstTitle = startYearlyFirstTitle
        self.startYearlySecondTitle = startYearlySecondTitle
        self.startYearlySecondTitleIsHidden = startYearlySecondTitleIsHidden
        self.privacyEulaTitle = privacyEulaTitle
    }
    
    // MARK: - Init from Snapshot
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let closeButton = value["closeButton"] as? Bool,
            let firstTitle = value["firstTitle"] as? String,
            let secondTitle = value["secondTitle"] as? String,
            let thirdTitle = value["thirdTitle"] as? String,
            let thirdTitleIsHidden = value["thirdTitleIsHidden"] as? Bool,
            let gpsTitle = value["gpsTitle"] as? String,
            let gpsSecondTitle = value["gpsSecondTitle"] as? String,
            let tripTitle = value["tripTitle"] as? String,
            let tripSecondTitle = value["tripSecondTitle"] as? String,
            let basicTitle = value["basicTitle"] as? String,
            let tryFreeTitle = value["tryFreeTitle"] as? String,
            let startYearlyFirstTitle = value["startYearlyFirstTitle"] as? String,
            let startYearlySecondTitle = value["startYearlySecondTitle"] as? String,
            let startYearlySecondTitleIsHidden = value["startYearlySecondTitleIsHidden"] as? Bool,
            let privacyEulaTitle = value["privacyEulaTitle"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.closeButton = closeButton
        self.firstTitle = firstTitle
        self.secondTitle = secondTitle
        self.thirdTitle = thirdTitle
        self.thirdTitleIsHidden = thirdTitleIsHidden
        self.gpsTitle = gpsTitle
        self.gpsSecondTitle = gpsSecondTitle
        self.tripTitle = tripTitle
        self.tripSecondTitle = tripSecondTitle
        self.basicTitle = basicTitle
        self.tryFreeTitle = tryFreeTitle
        self.startYearlyFirstTitle = startYearlyFirstTitle
        self.startYearlySecondTitle = startYearlySecondTitle
        self.startYearlySecondTitleIsHidden = startYearlySecondTitleIsHidden
        self.privacyEulaTitle = privacyEulaTitle
    }
    
    func toAnyObject() -> Any {
        return [
            "closeButton": closeButton,
            "firstTitle": firstTitle,
            "secondTitle": secondTitle,
            "thirdTitle": thirdTitle,
            "thirdTitleIsHidden": thirdTitleIsHidden,
            "gpsTitle": gpsTitle,
            "gpsSecondTitle": gpsSecondTitle,
            "tripTitle": tripTitle,
            "tripSecondTitle": tripSecondTitle,
            "basicTitle": basicTitle,
            "tryFreeTitle": tryFreeTitle,
            "startYearlyFirstTitle": startYearlyFirstTitle,
            "startYearlySecondTitle": startYearlySecondTitle,
            "startYearlySecondTitleIsHidden": startYearlySecondTitleIsHidden,
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
    var annualPriceTitle: String
    var monthlyFirstTitle: String
    var monthlySecondTitle: String
    var monthlyPriceTitle: String
    var weeklyFirstTitle: String
    var weeklySecondTitle: String
    var weeklyPriceTitle: String
    
    init(closeButton: Bool = true, firstTitle: String = "Full access", annualFirstTitle: String = "Annual", annualSecondTitle: String = "3 day trial -", annualPriceTitle: String = "then", monthlyFirstTitle: String = "Monthly", monthlySecondTitle: String = "3 day trial -", monthlyPriceTitle: String = "then", weeklyFirstTitle: String = "Weekly", weeklySecondTitle: String = "3 day trial -", weeklyPriceTitle: String = "then") {
        self.ref = nil
        self.key = nil
        self.closeButton = closeButton
        self.firstTitle = firstTitle
        self.annualFirstTitle = annualFirstTitle
        self.annualSecondTitle = annualSecondTitle
        self.annualPriceTitle = annualPriceTitle
        self.monthlyFirstTitle = monthlyFirstTitle
        self.monthlySecondTitle = monthlySecondTitle
        self.monthlyPriceTitle = monthlyPriceTitle
        self.weeklyFirstTitle = weeklyFirstTitle
        self.weeklySecondTitle = weeklySecondTitle
        self.weeklyPriceTitle = weeklyPriceTitle
    }
    
    // MARK: - Init from Snapshot
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let closeButton = value["closeButton"] as? Bool,
            let firstTitle = value["firstTitle"] as? String,
            let annualFirstTitle = value["annualFirstTitle"] as? String,
            let annualSecondTitle = value["annualSecondTitle"] as? String,
            let annualPriceTitle = value["annualPriceTitle"] as? String,
            let monthlyFirstTitle = value["monthlyFirstTitle"] as? String,
            let monthlySecondTitle = value["monthlySecondTitle"] as? String,
            let monthlyPriceTitle = value["monthlyPriceTitle"] as? String,
            let weeklyFirstTitle = value["weeklyFirstTitle"] as? String,
            let weeklySecondTitle = value["weeklySecondTitle"] as? String,
            let weeklyPriceTitle = value["weeklyPriceTitle"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.closeButton = closeButton
        self.firstTitle = firstTitle
        self.annualFirstTitle = annualFirstTitle
        self.annualSecondTitle = annualSecondTitle
        self.annualPriceTitle = annualPriceTitle
        self.monthlyFirstTitle = monthlyFirstTitle
        self.monthlySecondTitle = monthlySecondTitle
        self.monthlyPriceTitle = monthlyPriceTitle
        self.weeklyFirstTitle = weeklyFirstTitle
        self.weeklySecondTitle = weeklySecondTitle
        self.weeklyPriceTitle = weeklyPriceTitle
    }
    
    func toAnyObject() -> Any {
        return [
            "closeButton": closeButton,
            "firstTitle": firstTitle,
            "annualFirstTitle": annualFirstTitle,
            "annualSecondTitle": annualSecondTitle,
            "annualPriceTitle": annualPriceTitle,
            "monthlyFirstTitle": monthlyFirstTitle,
            "monthlySecondTitle": monthlySecondTitle,
            "monthlyPriceTitle": monthlyPriceTitle,
            "weeklyFirstTitle": weeklyFirstTitle,
            "weeklySecondTitle": weeklySecondTitle,
            "weeklyPriceTitle": weeklyPriceTitle
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

