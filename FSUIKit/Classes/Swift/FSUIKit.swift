// FSUIKitS.swift
// Translated from FSUIKit.h/m

import UIKit

@objcMembers
public class FSUIKit: NSObject {
    
    public static func alert(style: UIAlertController.Style, controller: UIViewController, title: String, message: String, actionTitles: [String], styles: [UIAlertAction.Style], handler: ((UIAlertAction) -> Void)?, cancelTitle: String, cancel: ((UIAlertAction) -> Void)?, completion: (() -> Void)?) -> UIAlertController {
        
        let alertController = self.alertControllerWithStyle(style, title: title, message: message, actionTitles: actionTitles, styles: styles, handler: handler, cancelTitle: cancelTitle, cancel: cancel);
        controller.present(alertController, animated: true, completion: completion)
        return alertController
    }

    static func alert(style: UIAlertController.Style, controller: UIViewController, title: String, message: String, actionTitles: [String], styles: [UIAlertAction.Style], handler: ((FSAlertAction) -> Void)?) -> UIAlertController {
        
        let ac = self.alertControllerWithStyle(style, title: title, message: message, actionTitles: actionTitles, styles: styles, handler: handler, cancelTitle: "取消", cancel: nil)
        controller.present(ac, animated: true, completion: nil)
        return ac
    }
    
    static func alertControllerWithStyle(_ style1: UIAlertController.Style, title:String, message: String, actionTitles: [String], styles: [UIAlertAction.Style], handler: ( (FSAlertAction) -> Void)?, cancelTitle: String, cancel: ((FSAlertAction) -> Void)?) -> UIAlertController {
        
        var style = style1
        if UIDevice.current.userInterfaceIdiom == .pad {
            style = UIAlertController.Style.alert
        }
        
        let count = min(actionTitles.count, styles.count)
        let controller = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for i in 0..<count {
            let action = FSAlertAction(title: actionTitles[i], style: styles[i], handler: { act in
                if handler != nil {
                    handler!(act as! FSAlertAction)
                }
            })
            action.theTag = i
            controller.addAction(action)
        }
        
        let archiveAction = FSAlertAction(title: cancelTitle, style: .cancel) { act in
            if cancel != nil {
                cancel!(act as! FSAlertAction)
            }
        }
        
        controller.addAction(archiveAction)
        
        return controller
    }
    
    static func alertInput(number: Int, controller: UIViewController, title: String, message: String, buttons: Int, buttonConfig: (FSAlertActionData) -> Void, textFieldConfig: ((UITextField) -> Void)?, completion: ((UIAlertController) -> Void)?) -> UIAlertController {
        
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
            let data = FSAlertActionData()
            data.index = i
            data.style = .default

            buttonConfig(data)
            
            let action = FSAlertAction(title: data.title, style: data.style) { [weak alert] m in
                guard let alert else { return }

                let act: FSAlertAction = m as! FSAlertAction
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
    
    @available(iOS 8.0, *)
    public static func effectView(withFrame frame: CGRect) -> UIVisualEffectView {
        let effect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = frame
        return effectView
    }
    
    public static func shot(with view: UIView, scope: CGRect) -> UIImage? {
        guard let fullImage = shot(with: view),
              let imageRef = fullImage.cgImage?.cropping(to: scope) else { return nil }
        
        UIGraphicsBeginImageContext(scope.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let rect = CGRect(x: 0, y: 0, width: scope.width, height: scope.height)
        context.translateBy(x: 0, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.draw(imageRef, in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public static func shot(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    public static func captureScrollView(_ scrollView: UIScrollView, finished completion: @escaping (UIImage?) -> Void) {
        let image = FSImageS.image(for: scrollView)
        completion(image)
    }
    
    public static func createDashedLine(withFrame lineFrame: CGRect, lineLength length: Int, lineSpacing spacing: Int, lineColor color: UIColor) -> UIView {
        let dashedLine = UIView(frame: lineFrame)
        dashedLine.backgroundColor = .clear
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = dashedLine.bounds
        shapeLayer.position = CGPoint(x: dashedLine.frame.width / 2, y: dashedLine.frame.height)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = dashedLine.frame.height
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [NSNumber(value: length), NSNumber(value: spacing)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: dashedLine.frame.width, y: 0))
        shapeLayer.path = path
        
        dashedLine.layer.addSublayer(shapeLayer)
        return dashedLine
    }
    
    public static func qrImage(from string: String?) -> UIImage? {
        let sourceString = string ?? ""
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setDefaults()
        
        let data = sourceString.data(using: .utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        guard let ciImage = filter.outputImage else { return nil }
        return createNonInterpolatedUIImage(from: ciImage, withSize: 960)
    }
    
    private static func createNonInterpolatedUIImage(from image: CIImage, withSize size: CGFloat) -> UIImage? {
        let extent = image.extent.integral
        let scale = min(size / extent.width, size / extent.height)
        let width = Int(extent.width * scale)
        let height = Int(extent.height * scale)
        
        guard let cs = CGColorSpace(name: CGColorSpace.linearGray),
              let bitmapRef = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue) else { return nil }
        
        let context = CIContext(options: nil)
        guard let bitmapImage = context.createCGImage(image, from: extent) else { return nil }
        
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        
        guard let scaledImage = bitmapRef.makeImage() else { return nil }
        return UIImage(cgImage: scaledImage)
    }
    
    public static func circleImage(_ image: UIImage, withParam inset: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(image.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setLineWidth(2)
        context.setStrokeColor(UIColor.clear.cgColor)
        
        let rect = CGRect(x: inset, y: inset, width: image.size.width - inset * 2.0, height: image.size.height - inset * 2.0)
        context.addEllipse(in: rect)
        context.clip()
        
        image.draw(in: rect)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    public static func scrollViewPage(_ scrollView: UIScrollView) -> CGFloat {
        let pageWidth = scrollView.frame.width
        if pageWidth < 0.01 { return 0 }
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        return page
    }
}
