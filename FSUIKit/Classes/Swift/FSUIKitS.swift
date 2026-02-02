// FSUIKitS.swift
// Translated from FSUIKit.h/m

import UIKit

@objcMembers
public class FSUIKitS: NSObject {
    
    @available(iOS 8.0, *)
    public static func alert(style: UIAlertController.Style, controller pController: UIViewController, title: String?, message: String?, actionTitles titles: [String], styles: [NSNumber], handler: ((FSAlertActionS) -> Void)?) -> UIAlertController {
        let alertController = alertController(withStyle: style, title: title, message: message, actionTitles: titles, styles: styles, handler: handler, cancelTitle: "取消", cancel: nil)
        pController.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    @available(iOS 8.0, *)
    public static func alert(style: UIAlertController.Style, controller pController: UIViewController, title: String?, message: String?, actionTitles titles: [String], styles: [NSNumber], handler: ((UIAlertAction) -> Void)?, cancelTitle: String?, cancel: ((UIAlertAction) -> Void)?, completion: (() -> Void)?) -> UIAlertController {
        let alertController = alertController(withStyle: style, title: title, message: message, actionTitles: titles, styles: styles, handler: handler, cancelTitle: cancelTitle, cancel: cancel)
        pController.present(alertController, animated: true, completion: completion)
        return alertController
    }
    
    private static func alertController(withStyle style: UIAlertController.Style, title: String?, message: String?, actionTitles titles: [String], styles: [NSNumber], handler: ((UIAlertAction) -> Void)?, cancelTitle: String?, cancel: ((UIAlertAction) -> Void)?) -> UIAlertController {
        var finalStyle = style
        if UIDevice.current.userInterfaceIdiom == .pad {
            finalStyle = .alert
        }
        
        let count = min(titles.count, styles.count)
        let controller = UIAlertController(title: title, message: message, preferredStyle: finalStyle)
        
        for x in 0..<count {
            let actionStyle = UIAlertAction.Style(rawValue: styles[x].intValue) ?? .default
            let action = FSAlertActionS(title: titles[x], style: actionStyle) { action in
                handler?(action)
            }
            action.theTag = x
            controller.addAction(action)
        }
        
        if let cancelTitle = cancelTitle, !cancelTitle.isEmpty {
            let archiveAction = FSAlertActionS(title: cancelTitle, style: .cancel) { action in
                cancel?(action)
            }
            controller.addAction(archiveAction)
        }
        
        return controller
    }
    
    @available(iOS 8.0, *)
    public static func alertInput(number: Int, controller: UIViewController, title: String?, message: String?, buttons: Int, buttonConfig: ((FSAlertActionData) -> Void)?, textFieldConfig: ((UITextField) -> Void)?, completion: ((UIAlertController) -> Void)?) -> UIAlertController? {
        guard number >= 1 else { return nil }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for x in 0..<number {
            alertController.addTextField { textField in
                textField.tag = x
                textFieldConfig?(textField)
            }
        }
        
        for x in 0..<buttons {
            let data = FSAlertActionData()
            data.index = x
            data.style = .default
            buttonConfig?(data)
            
            let action = FSAlertActionS(title: data.title, style: data.style) { action in
                if let fsAction = action as? FSAlertActionS, let click = fsAction.data?.click {
                    click(alertController, action)
                }
            }
            action.data = data
            alertController.addAction(action)
        }
        
        controller.present(alertController, animated: true) {
            completion?(alertController)
        }
        return alertController
    }
    
    public static func showAlert(withMessage message: String, controller: UIViewController) {
        showAlert(withTitle: "温馨提示", message: message, ok: "确定", controller: controller, handler: nil)
    }
    
    @available(iOS 8.0, *)
    public static func showAlert(withMessage message: String, controller: UIViewController, handler: ((UIAlertAction) -> Void)?) {
        showAlert(withTitle: "温馨提示", message: message, ok: "确定", controller: controller, handler: handler)
    }
    
    @available(iOS 8.0, *)
    public static func showAlert(withTitle title: String?, message: String?, ok: String, controller pController: UIViewController, handler: ((UIAlertAction) -> Void)?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: ok, style: .default, handler: handler)
        controller.addAction(action)
        pController.present(controller, animated: true, completion: nil)
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
