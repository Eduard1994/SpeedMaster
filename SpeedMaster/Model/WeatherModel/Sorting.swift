//
//  Sorting.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/29/21.
//

import Foundation

enum Sorting: String, CaseIterable {
    case maxValue = "Maximum value"
    case minValue = "Minimum value"
    case newest = "Upcoming"
    case earlier = "Earlier"
    
    private static var `default`: Self {
        .maxValue
    }
    
    static var selected: Self {
        guard let sortingIdentifier = UserDefaults.standard.string(forKey: kSelectedSort) else {
            return .default
        }

        // Return default unit in case the selected unit can not be used to
        // create an `Unit`, e.g. when an `Unit` was removed.
        guard let sort = Sorting(rawValue: sortingIdentifier) else {
            return .default
        }

        return sort
    }
    
    var max: Self {
        let sort = Sorting.maxValue
        UserDefaults.standard.set(sort.rawValue, forKey: kSelectedSort)
        
        return sort
    }
    
    var min: Self {
        let sort = Sorting.minValue
        UserDefaults.standard.set(sort.rawValue, forKey: kSelectedSort)
        
        return sort
    }
    
    var new: Self {
        let sort = Sorting.newest
        UserDefaults.standard.set(sort.rawValue, forKey: kSelectedSort)
        
        return sort
    }
    
    var early: Self {
        let sort = Sorting.earlier
        UserDefaults.standard.set(sort.rawValue, forKey: kSelectedSort)
        
        return sort
    }
}
