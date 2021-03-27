//
//  Unit.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/27/21.
//

import Foundation

enum Unit: String, CaseIterable {
    case kilometersPerHour = "Km/h"
    case milesPerHour = "Mph"
    case metersPerSecond = "m/s"
    case knots = "Knots"
    case split500 = "min./500m"

    private static var `default`: Self {
        .kilometersPerHour
    }

    static var selected: Self {
        // Return default unit in case the selected unit id can not be fetched
        // from UserDefaults or still contains an Int (e.g. fauly migration).
        guard let unitIdentifier = UserDefaults.standard.string(forKey: kSelectedUnit) else {
            return .default
        }

        // Return default unit in case the selected unit can not be used to
        // create an `Unit`, e.g. when an `Unit` was removed.
        guard let unit = Unit(rawValue: unitIdentifier) else {
            return .default
        }

        return unit
    }

    var miles: Self {
        let unit = Unit.milesPerHour
        UserDefaults.standard.set(unit.rawValue, forKey: kSelectedUnit)
        
        return unit
    }
    
    var kilometers: Self {
        let unit = Unit.kilometersPerHour
        UserDefaults.standard.set(unit.rawValue, forKey: kSelectedUnit)
        
        return unit
    }
    
    var knots: Self {
        let unit = Unit.knots
        UserDefaults.standard.set(unit.rawValue, forKey: kSelectedUnit)
        
        return unit
    }
    
    var next: Self {
        let units = Unit.allCases

        let index = units.firstIndex(of: self)! + 1
        let unit = (index < units.count) ? units[index] : units.first!
        UserDefaults.standard.set(unit.rawValue, forKey: kSelectedUnit)

        return unit
    }

    func calculateSpeed(for speedProvidedByDevice: Double) -> Double {
        // There is a minimum of 0.5 m/s needed before the app will return a
        // calculated speed.
        guard speedProvidedByDevice > 0.5 else {
            return 0
        }

        switch self {
        case .kilometersPerHour:
            return speedProvidedByDevice * 3.6
        case .milesPerHour:
            return speedProvidedByDevice * 2.23694
        case .metersPerSecond:
            return speedProvidedByDevice * 1.0
        case .knots:
            return speedProvidedByDevice * 1.944
        case .split500:
            return (500 / (speedProvidedByDevice * 60)) * 60
        }
    }
    
    func calculate(from meters: Double) -> Double {
        guard meters > 0.5 else {
            return 0
        }
        
        switch self {
        case .kilometersPerHour:
            return meters / 1000
        case .milesPerHour:
            return meters / 1609.34
        case .metersPerSecond:
            return meters
        case .knots:
            return meters
        case .split500:
            return (500 / (meters * 60)) * 60
        }
    }
    
    func calculateAverageSpeed(for speed: Double) -> String {
        let speed = calculateSpeed(for: speed)
        
        return "\(Int(speed)) \(rawValue)"
    }
    
    func calculateDistance(for speed: Double) -> String {
        let speed = calculate(from: speed).rounded(toPlaces: 2)
        
        switch self {
        case .kilometersPerHour:
            return "\(speed) km"
        case .milesPerHour:
            return "\(speed) mi"
        case .knots:
            return "\(speed) m"
        default:
            return "\(speed)"
        }
    }

    func calculcateFillment(for speedProvidedByDevice: Double) -> Double {
        let maximumFillment = self == .split500 ? 7.00000 : 66.66667
        let fillment = ((speedProvidedByDevice * 100) / maximumFillment) * 0.01

        guard fillment > 0.0 else {
            return  0.0
        }

        guard fillment < 1.0 else {
            return 1.0
        }

        return fillment
    }

    func localizedString(for speed: Double) -> String {
        if (self == .split500) {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = [.pad]

            var string = formatter.string(from: speed) ?? "00:00"

            // Hack to remove the first of two leading zeros for the minute
            if string.count == 5 && string.first == "0" {
                string.remove(at: string.startIndex)
            }

            return string
        }

        return String(format: "%.0f", speed)
    }
}

