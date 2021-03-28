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
    let historyAllSpeeds: [Double]
    let historyDate: String
    
    init(_ history: History) {
        historyMaxSpeed = "\(history.maxSpeed) \(history.speedMetric)"
        historyMinSpeed = "\(history.minSpeed) \(history.speedMetric)"
        historyAvrSpeed = "\(history.avrSpeed) \(history.speedMetric)"
        historyWindSpeed = "\(history.windSpeed) m/s"
        historyDuration = history.duration
        historyDistance = "\(history.distance) \(history.distanceMetric)"
        historyAllSpeeds = history.allSpeeds
        historyDate = history.date
    }
}
