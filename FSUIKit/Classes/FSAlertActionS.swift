//
//  FSAlertActionS.swift
//  FSUIKit
//
//  Created by pwrd on 2026/1/29.
//

import Foundation

public class FSAlertActionData {
    
    public var             index               :   Int                                             =   0
    public var             title               :   String                                          =   ""
    public var             style               :   UIAlertAction.Style                             =   .default
    
    public var             click               :   ((UIAlertController, UIAlertAction) -> Void)?   =   nil
}

public class FSAlertAction: UIAlertAction {
    
    public var             theTag              :   Int                                             =   0
    public var             data                :   FSAlertActionData                               =   FSAlertActionData()
}
