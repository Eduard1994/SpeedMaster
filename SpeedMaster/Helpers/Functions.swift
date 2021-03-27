//
//  Functions.swift
//  SpeedMaster
//
//  Created by Eduard Shahnazaryan on 3/19/21.
//

import UIKit
import AVFoundation

/**
 Returns image with a given name from the resource bundle.
 - Parameter name: Image name.
 - Returns: An image.
 */
func imageNamed(_ name: String) -> UIImage {
    let cls = SpeedometerViewController.self
    var bundle = Bundle(for: cls)
    let traitCollection = UITraitCollection(displayScale: 3)
    
    if let resourceBundle = bundle.resourcePath.flatMap({ Bundle(path: $0 + "/SpeedMaster.bundle") }) {
        bundle = resourceBundle
    }
    
    guard let image = UIImage(named: name, in: bundle, compatibleWith: traitCollection) else {
        return UIImage()
    }
    
    return image
}

func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
    let mf = MeasurementFormatter()
    mf.numberFormatter.maximumFractionDigits = 0
    mf.unitOptions = .providedUnit
    let input = Measurement(value: temp, unit: inputTempType)
    let output = input.converted(to: outputTempType)
    return mf.string(from: output)
}

func fromIntToDate(time: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(time))
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
    dateFormatter.timeZone = .current
    let localDate = dateFormatter.string(from: date)
    return localDate
}
