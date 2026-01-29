//
//  FSUIKitSwift.swift
//  FSUIKit
//
//  Created by pwrd on 2026/1/27.
//

import Foundation

open class FSUIKitSwift {
        
    static func alertControllerWithStyle(_ style1: UIAlertController.Style, title:String, message: String, actionTitles: [String], styles: [Int], handler: ( (FSAlertActionS) -> Void)?, cancelTitle: String, cancel: ((FSAlertActionS) -> Void)?) -> UIAlertController {
        
        var style = style1
        if UIDevice.current.userInterfaceIdiom == .pad {
            style = UIAlertController.Style.alert
        }
        
        let count = min(actionTitles.count, styles.count)
        let controller = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for i in 0..<count {
            let action = FSAlertActionS(title: actionTitles[i], style: UIAlertAction.Style(rawValue: styles[i]) ?? .default, handler: { act in
                if handler != nil {
                    handler!(act as! FSAlertActionS)
                }
            })
            action.theTag = i
            controller.addAction(action)
        }
        
        let archiveAction = FSAlertActionS(title: cancelTitle, style: .cancel) { act in
            if cancel != nil {
                cancel!(act as! FSAlertActionS)
            }
        }
        
        controller.addAction(archiveAction)
        
        return controller
    }
    
    public static func alert(style: UIAlertController.Style, controller: UIViewController, title: String, message: String, actionTitles: [String], styles: [Int], handler: ((UIAlertAction) -> Void)?, cancelTitle: String, cancel: ((UIAlertAction) -> Void)?, completion: (() -> Void)?) -> UIAlertController {
        
        #if DEBUG
        
        let clear = Array<String>()
        for tl in actionTitles {
            if clear.contains(tl) {
               return UIAlertController()
            }
        }
        
        #endif
        
        let alertController = self.alertControllerWithStyle(style, title: title, message: message, actionTitles: actionTitles, styles: styles, handler: handler, cancelTitle: cancelTitle, cancel: cancel);
        controller.present(alertController, animated: true, completion: completion)
        return alertController
    }

    static func alert(style: UIAlertController.Style, controller: UIViewController, title: String, message: String, actionTitles: [String], styles: [Int], handler: ((FSAlertActionS) -> Void)?) -> UIAlertController {
        
        let ac = self.alertControllerWithStyle(style, title: title, message: message, actionTitles: actionTitles, styles: styles, handler: handler, cancelTitle: "取消", cancel: nil)
        controller.present(ac, animated: true, completion: nil)
        return ac
    }
    
    static func alertInput(number: Int, controller: UIViewController, title: String, message: String, buttons: Int, buttonConfig: (FSAlertActionDataS) -> Void, textFieldConfig: ((UITextField) -> Void)?, completion: ((UIAlertController) -> Void)?) -> UIAlertController {
        
        if number < 1 {
            return UIAlertController()
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for i in 0..<number {
            alert.addTextField { tf in
                if textFieldConfig != nil {
                    tf.tag = i
                    textFieldConfig!(tf)
                }
            }
        }
        
        for i in 0..<buttons {
            let data = FSAlertActionDataS()
            data.index = i
            data.style = .default

            buttonConfig(data)
            
            let action = FSAlertActionS(title: data.title, style: data.style) { [weak alert] m in
                guard let alert else { return }

                let act: FSAlertActionS = m as! FSAlertActionS
                if act.data.click != nil {
                    act.data.click!(alert, act)
                }
            }
            
            action.data = data
            alert.addAction(action)
        }
        
        controller.present(alert, animated: true) {
            if completion != nil {
                completion!(alert)
            }
        }
        
        return alert
    }
    
    public static func showAlertWithMessage(message: String, controller: UIViewController) {
        self.showAlertWithTitle(title: "温馨提示", message: message, ok: "确定", controller: controller, handler: nil)
    }
    
    public static func showAlertWithMessage(message: String, controller: UIViewController, handler: ((UIAlertAction) -> Void)?) {
        self.showAlertWithTitle(title: "温馨提示", message: message, ok: "确定", controller: controller, handler: handler)
    }
    
    public static func showAlertWithTitle(title: String, message: String, ok: String, controller: UIViewController, handler: ((UIAlertAction) -> Void)?) {
        let c = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: ok, style: .default, handler: handler)
        c.addAction(action)
        controller.present(c, animated: true, completion: nil)
    }
}
