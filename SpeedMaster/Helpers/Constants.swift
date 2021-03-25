//
//  Constants.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/22/21.
//

import Foundation

// MARK: - Links and email for settings
let kAppURL = "https://qr-bar-app.com"
let kPolicyURL = "https://qr-bar-app.com/policy.html"
let kTermsURL = "https://qr-bar-app.com/terms.html"
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
