//
//  History.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import Foundation
import FirebaseDatabase

struct SectionedHistories {
    let ref: DatabaseReference?
    let key: String?
    var history: History
    var collapsed: Bool
    
    init(history: History, collapsed: Bool = false) {
        self.ref = nil
        self.key = nil
        self.history = history
        self.collapsed = collapsed
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let history = value["history"] as? History,
            let collapsed = value["collapsed"] as? Bool
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.history = history
        self.collapsed = collapsed
    }
}

struct History {
    let ref: DatabaseReference?
    let key: String?
    var id: String
    var userID: String
    var maxSpeed: Double
    var minSpeed: Double
    var avrSpeed: Double
    var windSpeed: Double
    var duration: String
    var distance: Double
    var allSpeeds: [Double]
    var date: String
    var collapsed: Bool
    var speedMetric: String
    var distanceMetric: String
    
    init(id: String = "", userID: String = "", maxSpeed: Double = 0, minSpeed: Double = 0, avrSpeed: Double = 0, windSpeed: Double = 0, duration: String = "", distance: Double = 0, allSpeeds: [Double] = [], date: String = "", collapsed: Bool = true, speedMetric: String = "Km/h", distanceMetric: String = "KM") {
        self.ref = nil
        self.key = nil
        self.id = id
        self.userID = userID
        self.maxSpeed = maxSpeed
        self.minSpeed = minSpeed
        self.avrSpeed = avrSpeed
        self.windSpeed = windSpeed
        self.duration = duration
        self.distance = distance
        self.allSpeeds = allSpeeds
        self.date = date
        self.collapsed = collapsed
        self.speedMetric = speedMetric
        self.distanceMetric = distanceMetric
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let id = value["id"] as? String,
            let userID = value["userID"] as? String,
            let maxSpeed = value["maxSpeed"] as? Double,
            let minSpeed = value["minSpeed"] as? Double,
            let avrSpeed = value["avrSpeed"] as? Double,
            let windSpeed = value["windSpeed"] as? Double,
            let duration = value["duration"] as? String,
            let distance = value["distance"] as? Double,
            let allSpeeds = value["allSpeeds"] as? [Double],
            let date = value["date"] as? String,
            let collapsed = value["collapsed"] as? Bool,
            let speedMetric = value["speedMetric"] as? String,
            let distanceMetric = value["distanceMetric"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.id = id
        self.userID = userID
        self.maxSpeed = maxSpeed
        self.minSpeed = minSpeed
        self.avrSpeed = avrSpeed
        self.windSpeed = windSpeed
        self.duration = duration
        self.distance = distance
        self.allSpeeds = allSpeeds
        self.date = date
        self.collapsed = collapsed
        self.speedMetric = speedMetric
        self.distanceMetric = distanceMetric
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "userID": userID,
            "maxSpeed": maxSpeed,
            "minSpeed": minSpeed,
            "avrSpeed": avrSpeed,
            "windSpeed": windSpeed,
            "duration": duration,
            "distance": distance,
            "allSpeeds": allSpeeds,
            "date": date,
            "collapsed": collapsed,
            "speedMetric": speedMetric,
            "distanceMetric": distanceMetric
        ]
    }
}

