//
//  GraphPoint.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/25/21.
//

import UIKit

internal class GraphPoint {
    
    var location = CGPoint(x: 0, y: 0)
    var currentlyAnimatingToPosition = false
    
    var x: CGFloat {
        get {
            return location.x
        }
        set {
            location.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return location.y
        }
        set {
            location.y = newValue
        }
    }
    
    init(position: CGPoint = CGPoint.zero) {
        x = position.x
        y = position.y
    }
}

