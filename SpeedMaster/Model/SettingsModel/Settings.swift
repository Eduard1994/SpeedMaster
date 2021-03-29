//
//  Settings.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import Foundation

struct Settings {
    var title: String
    var imageName: String
    var speed: String?
    
    init(title: String, imageName: String, speed: String? = "Km/h") {
        self.title = title
        self.imageName = imageName
        self.speed = speed
    }
    
    static var unit: Unit = Unit.selected
    static var sort: Sorting = Sorting.selected
    
    static func settings() -> [Settings] {
        return [
            Settings(title: "Measure units", imageName: "settingsMeasureImage", speed: unit.rawValue),
            Settings(title: "Restore purchases", imageName: "settingsRestoreImage", speed: nil),
            Settings(title: "Privacy policy", imageName: "settingsPrivacyImage", speed: nil),
            Settings(title: "Terms of service", imageName: "settingsPrivacyImage", speed: nil), // Will be changed soon
            Settings(title: "Rate the app", imageName: "settingsRateImage", speed: nil),
            Settings(title: "Share with friends", imageName: "settingsShareImage", speed: nil),
            Settings(title: "Support", imageName: "settingsShareImage", speed: nil)  // Will be changed soon
        ]
    }
}

