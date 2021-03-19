//
//  UIColor+Extension.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/17/21.
//

import UIKit

// MARK: - UIColor Extension
extension UIColor {
    /// Getting Color
    /// - Returns UIColor with RGB values
    static func getColor(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    // MARK: - Fade
    /// Fade
    /// - Returns the fade colour
    static func fade(fromRed: CGFloat, fromGreen: CGFloat, fromBlue: CGFloat, fromAlpha: CGFloat, toRed: CGFloat, toGreen: CGFloat, toBlue: CGFloat, toAlpha: CGFloat, withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // MARK: - Main Colors
    /// Main Gray Color
    /// - Returns Color Literal
    /// - #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
    static var mainGray: UIColor {
        return .getColor(r: 220, g: 220, b: 220) 
    }
    
    /// Main Action Gray
    /// - Returns Color Literal
    /// - #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    static var mainActionGray: UIColor {
        return .getColor(r: 248, g: 248, b: 248)
    }
    
    /// Main Action Gray
    /// - Returns Color Literal
    /// - #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    static var mainGrayAverage: UIColor {
        return .getColor(r: 134, g: 134, b: 134)
    }
    
    /// Main Action Gray
    /// - Returns Color Literal
    /// - #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    static var mainBlue: UIColor {
        return .getColor(r: 0, g: 71.4, b: 255)
    }
    
    /// Main Yellow
    /// - Returns Color Literal
    /// - #colorLiteral(red: 0.8784313725, green: 1, blue: 0, alpha: 1)
    static var mainYellow: UIColor {
        return .getColor(r: 224, g: 255, b: 0)
    }
    
    /// Main Action Gray
    /// - Returns Color Literal
    /// - #colorLiteral(red: 0 green: 0 blue: 0 alpha: 1)
    static var mainBlack: UIColor {
        return .getColor(r: 0, g: 0, b: 0)
    }
    
    /// Main Action Gray
    /// - Returns Color Literal
    /// - #colorLiteral(red: 1 green: 1 blue: 1 alpha: 1)
    static var mainWhite: UIColor {
        return .getColor(r: 255, g: 255, b: 255)
    }
}

