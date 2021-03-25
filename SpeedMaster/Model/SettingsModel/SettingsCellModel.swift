//
//  SettingsCellModel.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import Foundation

class SettingsCellModel {
    let settingsImageName: String
    let settingsTitle: String
    let speed: String?
    
    init(_ settings: Settings) {
        settingsTitle = settings.title
        settingsImageName = settings.imageName
        speed = settings.speed
    }
}
