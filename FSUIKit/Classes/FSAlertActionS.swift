//
//  FSAlertActionS.swift
//  FSUIKit
//
//  Created by pwrd on 2026/1/29.
//

import Foundation

class FSAlertActionDataS {
    
    var             index               :   Int                                             =   0
    var             title               :   String                                          =   ""
    var             style               :   UIAlertAction.Style                             =   .default
    
    var             click               :   ((UIAlertController, UIAlertAction) -> Void)?   =   nil
}

class FSAlertActionS: UIAlertAction {
    
    var             theTag              :   Int                                             =   0
    var             data                :   FSAlertActionDataS                              =   FSAlertActionDataS()
}
