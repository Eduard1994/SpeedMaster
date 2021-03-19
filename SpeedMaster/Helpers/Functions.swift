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

