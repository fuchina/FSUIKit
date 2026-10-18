//
//  FSToast.swift
//  FSUIKit
//
//  Created by Dongdong Fu on 2026/1/31.
//

import Foundation
import FSKit

open class FSToast: NSObject {
    
    public static func toast(_ text: String, duration: Double = 2) {
        FSToastCenter.shared.show(text, duration: duration)
    }
}
