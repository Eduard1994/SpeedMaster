//
//  UIDevice+Extension.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/21/21.
//

import UIKit

let type = UIDevice.current.deviceType
let screenSize = UIScreen.main.bounds
let screenHeight = screenSize.height

extension UIDevice {
    enum DeviceType {
        case iPhone5_5S_5C_SE
        case iPhone6_6S_7_8_SE2
        case iPhone6Plus_6SPlus_7Plus_8Plus
        case iPhone12Mini
        case iPhoneX_XS_11Pro
        case iPhone12_12Pro
        case iPhoneXR_XSMax_11_11ProMax
        case iPhone12ProMax
        case iPad
        case TV
        case CarPlay
        case Mac
        
        var isPhone: Bool {
            return [.iPhone5_5S_5C_SE, .iPhone6_6S_7_8_SE2, .iPhone6Plus_6SPlus_7Plus_8Plus, .iPhone12Mini, .iPhoneX_XS_11Pro, .iPhone12_12Pro, .iPhoneXR_XSMax_11_11ProMax, .iPhone12ProMax].contains(self)
        }
    }
    
    var deviceType: DeviceType? {
        switch UIDevice.current.userInterfaceIdiom {
        case .unspecified:
            return nil
        case .phone:
            let screenSize = UIScreen.main.bounds
            let height = screenSize.height

            switch height {
            case 568:
                return .iPhone5_5S_5C_SE
            case 667:
                return .iPhone6_6S_7_8_SE2
            case 736:
                return .iPhone6Plus_6SPlus_7Plus_8Plus
            case 780:
                return .iPhone12Mini
            case 812:
                return .iPhoneX_XS_11Pro
            case 844:
                return .iPhone12_12Pro
            case 896:
                return .iPhoneXR_XSMax_11_11ProMax
            case 926:
                return .iPhone12ProMax
            default:
                return nil
            }
        case .pad:
            return .iPad
        case .tv:
            return .TV
        case .carPlay:
            return .CarPlay
        case .mac:
            return .Mac
        @unknown default:
            fatalError()
        }
    }
}
