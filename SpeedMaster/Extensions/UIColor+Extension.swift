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
    
    /// Main Dark Gray
    /// - Returns Color Literal
    /// - #colorLiteral(red: 0.3764705882, green: 0.3764705882, blue: 0.3764705882, alpha: 1)
    static var mainDarkGray: UIColor {
        return .getColor(r: 96, g: 96, b: 96)
    }
    
    /// Main Dark
    /// - Returns Color Literal
    /// - #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 1)
    static var mainDark: UIColor {
        return .getColor(r: 31, g: 31, b: 31)
    }
    
    /// Main Blue
    /// - Returns Color Literal
    /// - #colorLiteral(red: 0, green: 0.3411764706, blue: 1, alpha: 1)
    static var mainBlue: UIColor {
        return .getColor(r: 0, g: 87, b: 255)
    }
    
    /// Main Yellow
    /// - Returns Color Literal
    /// - #colorLiteral(red: 0.8784313725, green: 1, blue: 0, alpha: 1)
    static var mainYellow: UIColor {
        return .getColor(r: 224, g: 255, b: 0)
    }
    
    /// Main Gray Read
    /// - Returns Color Literal
    /// - #colorLiteral(red: 0.737254902, green: 0.737254902, blue: 0.737254902, alpha: 1)
    static var mainGrayRead: UIColor {
        return .getColor(r: 188, g: 188, b: 188)
    }
    
    /// Main Black
    /// - Returns Color Literal
    /// - #colorLiteral(red: 0 green: 0 blue: 0 alpha: 1)
    static var mainBlack: UIColor {
        return .getColor(r: 0, g: 0, b: 0)
    }
    
    /// Main White
    /// - Returns Color Literal
    /// - #colorLiteral(red: 1 green: 1 blue: 1 alpha: 1)
    static var mainWhite: UIColor {
        return .getColor(r: 255, g: 255, b: 255)
    }
    
    // Convert a hex string to a UIColor object.
    class func colorFromHex(hexString:String) -> UIColor {
        
        func clean(hexString: String) -> String {
            
            var cleanedHexString = String()
            
            // Remove the leading "#"
            if(hexString[hexString.startIndex] == "#") {
                let index = hexString.index(hexString.startIndex, offsetBy: 1)
                cleanedHexString = String(hexString[index...])
            }
            
            // TODO: Other cleanup. Allow for a "short" hex string, i.e., "#fff"
            
            return cleanedHexString
        }
        
        let cleanedHexString = clean(hexString: hexString)
        
        // If we can get a cached version of the colour, get out early.
        if let cachedColor = UIColor.getColorFromCache(hexString: cleanedHexString) {
            return cachedColor
        }
        
        // Else create the color, store it in the cache and return.
        let scanner = Scanner(string: cleanedHexString)
        
        var value:UInt32 = 0
        
        // We have the hex value, grab the red, green, blue and alpha values.
        // Have to pass value by reference, scanner modifies this directly as the result of scanning the hex string. The return value is the success or fail.
        if(scanner.scanHexInt32(&value)){
            
            // intValue = 01010101 11110111 11101010    // binary
            // intValue = 55       F7       EA          // hexadecimal
            
            //                     r
            //   00000000 00000000 01010101 intValue >> 16
            // & 00000000 00000000 11111111 mask
            //   ==========================
            // = 00000000 00000000 01010101 red
            
            //            r        g
            //   00000000 01010101 11110111 intValue >> 8
            // & 00000000 00000000 11111111 mask
            //   ==========================
            // = 00000000 00000000 11110111 green
            
            //   r        g        b
            //   01010101 11110111 11101010 intValue
            // & 00000000 00000000 11111111 mask
            //   ==========================
            // = 00000000 00000000 11101010 blue
            
            let intValue = UInt32(value)
            let mask:UInt32 = 0xFF
            
            let red = intValue >> 16 & mask
            let green = intValue >> 8 & mask
            let blue = intValue & mask
            
            // red, green, blue and alpha are currently between 0 and 255
            // We want to normalise these values between 0 and 1 to use with UIColor.
            let colors:[UInt32] = [red, green, blue]
            let normalised = normalise(colors: colors)
            
            let newColor = UIColor(red: normalised[0], green: normalised[1], blue: normalised[2], alpha: 1)
            UIColor.storeColorInCache(hexString: cleanedHexString, color: newColor)
            
            return newColor
            
        }
        // We couldn't get a value from a valid hex string.
        else {
            print("Error: Couldn't convert the hex string to a number, returning UIColor.whiteColor() instead.")
            return UIColor.white
        }
    }
    
    // Takes an array of colours in the range of 0-255 and returns a value between 0 and 1.
    private class func normalise(colors: [UInt32]) -> [CGFloat]{
        var normalisedVersions = [CGFloat]()
        
        for color in colors{
            normalisedVersions.append(CGFloat(color % 256) / 255)
        }
        
        return normalisedVersions
    }
    
    // Caching
    // Store any colours we've gotten before. Colours don't change.
    private static var hexColorCache = [String : UIColor]()
    
    private class func getColorFromCache(hexString: String) -> UIColor? {
        guard let color = UIColor.hexColorCache[hexString] else {
            return nil
        }
        
        return color
    }
    
    private class func storeColorInCache(hexString: String, color: UIColor) {
        
        if UIColor.hexColorCache.keys.contains(hexString) {
            return // No work to do if it is already there.
        }
        
        UIColor.hexColorCache[hexString] = color
    }
    
    private class func clearColorCache() {
        UIColor.hexColorCache.removeAll()
    }
}

