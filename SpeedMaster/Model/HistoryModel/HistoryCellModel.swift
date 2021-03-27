//
//  HistoryCellModel.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import Foundation

class HistoryCellModel {
    let historyMaxSpeed: String
    let historyMinSpeed: String
    let historyAvrSpeed: String
    let historyWindSpeed: String
    let historyDuration: String
    let historyDistance: String
    let historyAllSpeeds: [String]
    let historyDate: String
    
    init(_ history: History) {
        historyMaxSpeed = history.maxSpeed
        historyMinSpeed = history.minSpeed
        historyAvrSpeed = history.avrSpeed
        historyWindSpeed = history.windSpeed
        historyDuration = history.duration
        historyDistance = history.distance
        historyAllSpeeds = history.allSpeeds
        historyDate = history.date
    }
}
