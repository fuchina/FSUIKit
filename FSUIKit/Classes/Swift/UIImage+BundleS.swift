// UIImage+BundleS.swift
// Translated from UIImage+Bundle.h/m

import UIKit

public extension UIImage {
    
    static func imageS(withBundle bundle: String, imageName: String) -> UIImage? {
        let mainBundle = Bundle.main
        guard let bundlePath = mainBundle.path(forResource: bundle, ofType: "bundle"),
              let currentBundle = Bundle(path: bundlePath),
              let imagePath = currentBundle.path(forResource: imageName, ofType: "png") else {
            return nil
        }
        return UIImage(contentsOfFile: imagePath)
    }
}
