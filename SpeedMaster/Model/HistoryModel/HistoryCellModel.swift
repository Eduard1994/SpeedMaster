//
//  HistoryCellModel.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import Foundation

class HistoryCellModel {
    let historySpeed: String
    let historyDate: String
    
    init(_ history: History) {
        historySpeed = history.speed
        historyDate = history.date
    }
}
