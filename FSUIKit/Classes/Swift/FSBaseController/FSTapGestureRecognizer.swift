//
//  FSTapGestureRecognizer.swift
//  FSBaseController
//
//  Translated from Objective-C
//

import UIKit

open class FSTapGestureRecognizer: UITapGestureRecognizer {
    public var clickBack: ((UIAlertController, CGPoint) -> Void)?
}
