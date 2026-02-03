//
//  FSAlertActionS.swift
//  FSUIKit
//
//  Created by pwrd on 2026/1/29.
//

import Foundation

public class FSAlertActionData {
    
    var             index               :   Int                                             =   0
    var             title               :   String                                          =   ""
    var             style               :   UIAlertAction.Style                             =   .default
    
    var             click               :   ((UIAlertController, UIAlertAction) -> Void)?   =   nil
}

public class FSAlertAction: UIAlertAction {
    
    var             theTag              :   Int                                             =   0
    var             data                :   FSAlertActionData                               =   FSAlertActionData()
}
