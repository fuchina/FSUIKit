//
//  FSToast.swift
//  FSUIKit
//
//  Created by Dongdong Fu on 2026/1/31.
//

import Foundation
import FSKit

open class FSToast: NSObject {

    public static func toast(_ text: String) {
        self.toast(text, duration: 2)
    }

    public static func toast(_ text: String, duration: Double) {
        FSToastCenter.shared.show(text, duration: duration)
    }
}
