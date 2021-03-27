//
//  Constants.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/22/21.
//

import Foundation

// MARK: - Links and email for settings
let kAppURL = "https://speed-bar-app.com"
let kPolicyURL = "https://speed-bar-app.com/policy.html"
let kTermsURL = "https://speed-bar-app.com/terms.html"
let kEmail = "support@speed-bar-app.com"
let kCCRecipentEmail = "fixed.development@gmail.com"

// MARK: - Statuses
let kStatus = "status"
let kOnboardingStatus = "onboardingStatus"

// MARK: - User
let kUserDataKey = "current_user"

// MARK: - Notification Names
let hideSettingsUpgradeNotification: Notification.Name = Notification.Name(rawValue: "HideSettingsUpgrade")
let upgradeFromSettings: Notification.Name = Notification.Name(rawValue: "UpgradeFromSettings")
let showErrorForSettings: Notification.Name = Notification.Name("ShowErrorForSettings")
let dismissNotification: Notification.Name = Notification.Name(rawValue: "DismissNotification")
let subTypeNotificationIndex: Notification.Name = Notification.Name("NotificationIndex")
let unitChangedNotification: Notification.Name = Notification.Name("UnitChanged")

// MARK: - Weather
let kWeatherAPIKey = "7ac83b29202bdc37108dd156f49bdf2b"
let kWeatherURL = "https://api.openweathermap.org/data/2.5/onecall"

// MARK: Units
let kSelectedUnit = "unit"