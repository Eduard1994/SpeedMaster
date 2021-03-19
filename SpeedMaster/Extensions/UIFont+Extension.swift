//
//  UIFont+Extension.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/17/21.
//

import UIKit

enum SFPRODisplayStyle: String {
    case black = "Black"
    case blackItalic = "BlackItalic"
    case bold = "Bold"
    case boldItalic = "BoldItalic"
    case heavy = "Heavy"
    case heavyItalic = "HeavyItalic"
    case light = "Light"
    case lightItalic = "LightItalic"
    case medium = "Medium"
    case mediumItalic = "MediumItalic"
    case regular = "Regular"
    case regularItalic = "RegularItalic"
    case semibold = "Semibold"
    case semiboldItalic = "SemiboldItalic"
    case thin = "Thin"
    case thinItalic = "ThinItalic"
    case ultralight = "Ultralight"
    case ultralightItalic = "UltralightItalic"
}

enum SFPROTextStyle: String {
    case bold = "Bold"
    case boldItalic = "BoldItalic"
    case heavy = "Heavy"
    case heavyItalic = "HeavyItalic"
    case light = "Light"
    case lightItalic = "LightItalic"
    case medium = "Medium"
    case mediumItalic = "MediumItalic"
    case regular = "Regular"
    case regularItalic = "RegularItalic"
    case semibold = "Semibold"
    case semiboldItalic = "SemiboldItalic"
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

