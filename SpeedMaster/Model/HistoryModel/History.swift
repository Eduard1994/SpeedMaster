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
    var maxSpeed: String
    var minSpeed: String
    var avrSpeed: String
    var windSpeed: String
    var duration: String
    var distance: String
    var allSpeeds: [String]
    var date: String
    var collapsed: Bool
    
    init(id: String = "", userID: String = "", maxSpeed: String = "", minSpeed: String = "", avrSpeed: String = "", windSpeed: String = "", duration: String = "", distance: String = "", allSpeeds: [String] = [""], date: String = "", collapsed: Bool = true) {
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
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let id = value["id"] as? String,
            let userID = value["userID"] as? String,
            let maxSpeed = value["maxSpeed"] as? String,
            let minSpeed = value["minSpeed"] as? String,
            let avrSpeed = value["avrSpeed"] as? String,
            let windSpeed = value["windSpeed"] as? String,
            let duration = value["duration"] as? String,
            let distance = value["distance"] as? String,
            let allSpeeds = value["allSpeeds"] as? [String],
            let date = value["date"] as? String,
            let collapsed = value["collapsed"] as? Bool
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
            "collapsed": collapsed
        ]
    }
}

