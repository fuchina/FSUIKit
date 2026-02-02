// FSAlertActionS.swift
// Translated from FSAlertAction.h/m

import UIKit

@objcMembers
public class FSAlertActionData: NSObject {
    public var index: Int = 0
    public var title: String?
    public var style: UIAlertAction.Style = .default
    public var click: ((UIAlertController, UIAlertAction) -> Void)?
}

@available(iOS 8.0, *)
@objcMembers
public class FSAlertActionS: UIAlertAction {
    public var theTag: Int = 0
    public var data: FSAlertActionData?
}
