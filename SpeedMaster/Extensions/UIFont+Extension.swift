//
//  UIFont+Extension.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/17/21.
//

import UIKit

enum SFPRODisplayStyle: String {
    case black = "Black"
    case bold = "Bold"
    case heavy = "Heavy"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semibold = "Semibold"
    case thin = "Thin"
    case ultralight = "Ultralight"
}

enum SFPROTextStyle: String {
    case bold = "Bold"
    case heavy = "Heavy"
    case light = "Light"
    case medium = "Medium"
    case regular = "Regular"
    case semibold = "Semibold"
}

// MARK: - Fonts
extension UIFont {
    class func sfProDisplay(ofSize fontSize: CGFloat, style: SFPRODisplayStyle) -> UIFont {
        guard let font = UIFont(name: "SFProDisplay-\(style)", size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize, weight: Weight(rawValue: 20))
        }
        return font
    }
    
    class func sfProText(ofSize fontSize: CGFloat, style: SFPROTextStyle) -> UIFont {
        guard let font = UIFont(name: "SFProText-\(style)", size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize, weight: Weight(rawValue: 20))
        }
        return font
    }
}

