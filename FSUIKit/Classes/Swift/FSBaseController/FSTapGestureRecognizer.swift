//
//  FSTapGestureRecognizer.swift
//  FSBaseController
//
//  Translated from Objective-C
//

import UIKit

@objc open class FSTapGestureRecognizer: UITapGestureRecognizer {
    @objc public var clickBack: ((UIAlertController, CGPoint) -> Void)?
}
