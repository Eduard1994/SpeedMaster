//
//  UIColor+Extension.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/17/21.
//

import UIKit

// MARK: - UIColor
extension UIColor {
    static func getColor(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    static func fade(fromRed: CGFloat, fromGreen: CGFloat, fromBlue: CGFloat, fromAlpha: CGFloat, toRed: CGFloat, toGreen: CGFloat, toBlue: CGFloat, toAlpha: CGFloat, withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static var mainGray: UIColor {
//        return #colorLiteral(red: 0.84, green: 0.84, blue: 0.84, alpha: 1)
        return .getColor(r: 214, g: 214, b: 214)
    }
    
    static var mainActionGray: UIColor {
//        return #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
        return .getColor(r: 248, g: 248, b: 248)
    }
    
    static var mainGrayAverage: UIColor {
//        return #colorLiteral(red: 0.5254901961, green: 0.5254901961, blue: 0.5254901961, alpha: 1)
        return .getColor(r: 134, g: 134, b: 134)
    }
    
    static var mainBlue: UIColor {
//        return #colorLiteral(red: 0, green: 0.28, blue: 1, alpha: 1)
        return .getColor(r: 0, g: 71.4, b: 255)
    }
    
    static var mainRed: UIColor {
//        return #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        return .getColor(r: 255, g: 58.65, b: 48.45)
    }
    
    static var mainBlack: UIColor {
//        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return .getColor(r: 0, g: 0, b: 0)
    }
    
    static var mainWhite: UIColor {
//        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return .getColor(r: 255, g: 255, b: 255)
    }
}

