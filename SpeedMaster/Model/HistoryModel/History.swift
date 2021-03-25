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
    var speed: String
    var date: String
    var collapsed: Bool
    
    init(id: String = "", userID: String = "", speed: String = "", date: String = "", collapsed: Bool = false) {
        self.ref = nil
        self.key = nil
        self.id = id
        self.userID = userID
        self.speed = speed
        self.date = date
        self.collapsed = collapsed
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let id = value["id"] as? String,
            let userID = value["userID"] as? String,
            let speed = value["speed"] as? String,
            let date = value["date"] as? String,
            let collapsed = value["collapsed"] as? Bool
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        
        self.id = id
        self.userID = userID
        self.speed = speed
        self.date = date
        self.collapsed = collapsed
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "userID": userID,
            "speed": speed,
            "date": date,
            "collapsed": collapsed
        ]
    }
}

