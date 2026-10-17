// FSUIKitS.swift
// Translated from FSUIKit.h/m
//
//  2026-10-15 全 SwiftUI 化：`alert / alertInput / showAlertWithMessage` 原来构造
//  UIAlertController 后 `controller.present(...)`，必须有 UIViewController 宿主；
//  现改为交给 `FSAlertCenter`（SwiftUI 全局弹窗，由根视图渲染）。
//  签名保持不变、`controller` 参数被忽略 ⇒ 全项目 343 处调用点一行都不用改。

import UIKit

import FSKit

public class FSUIKit: NSObject {
    
    @discardableResult
    public static func alert(style: UIAlertController.Style, controller: UIViewController, title: String, message: String, actionTitles: [String], styles: [UIAlertAction.Style], handler: ((UIAlertAction) -> Void)?, cancelTitle: String, cancel: ((UIAlertAction) -> Void)?, completion: (() -> Void)?) -> UIAlertController {
        
        let alertController = self.alertControllerWithStyle(style, title: title, message: message, actionTitles: actionTitles, styles: styles, handler: handler, cancelTitle: cancelTitle, cancel: cancel);
        // 2026-10-15：弹窗已由 FSAlertCenter（SwiftUI 全局弹窗）渲染
        completion?()
        return alertController
    }

    @discardableResult
    public static func alert(style: UIAlertController.Style, controller: UIViewController, title: String, message: String, actionTitles: [String], styles: [UIAlertAction.Style], handler: ((FSAlertAction) -> Void)?) -> UIAlertController {
        
        let ac = self.alertControllerWithStyle(style, title: title, message: message, actionTitles: actionTitles, styles: styles, handler: handler, cancelTitle: "取消", cancel: nil)
        // 2026-10-15：弹窗已由 FSAlertCenter（SwiftUI 全局弹窗）渲染
        return ac
    }
    
    static func alertControllerWithStyle(_ style1: UIAlertController.Style, title:String, message: String, actionTitles: [String], styles: [UIAlertAction.Style], handler: ( (FSAlertAction) -> Void)?, cancelTitle: String, cancel: ((FSAlertAction) -> Void)?) -> UIAlertController {
        
        var style = style1
        if UIDevice.current.userInterfaceIdiom == .pad {
            style = UIAlertController.Style.alert
        }
        
        let count = min(actionTitles.count, styles.count)
        let controller = UIAlertController(title: title, message: message, preferredStyle: style)
        
        var specs: [FSAlertActionSpec] = []

        // Swift 6 语言模式：`FSAlertAction`（`UIAlertAction` 子类）的 init 是 @MainActor 隔离，
        // 传入的 handler 闭包会被「送」到主隔离域 ⇒ 闭包须为 @Sendable（UIAlertAction 的
        // handler 由 UIKit 在主线程回调），其中捕获的非 Sendable 调用方闭包用
        // FSUncheckedSendable 装箱后跨域携带。本类保持 nonisolated（见 FSAlertCenter 注释）。
        let handlerBox = FSUncheckedSendable(handler)

        for i in 0..<count {
            let action = FSAlertAction(title: actionTitles[i], style: styles[i], handler: { @Sendable act in
                handlerBox.value?(act as! FSAlertAction)
            })
            action.theTag = i
            controller.addAction(action)

            specs.append(FSAlertActionSpec(title: actionTitles[i], style: styles[i]) {
                if handler != nil {
                    handler!(action)
                }
            })
        }
        
        let cancelBox = FSUncheckedSendable(cancel)
        let archiveAction = FSAlertAction(title: cancelTitle, style: .cancel, handler: { @Sendable act in
            cancelBox.value?(act as! FSAlertAction)
        })
        
        controller.addAction(archiveAction)

        specs.append(FSAlertActionSpec(title: cancelTitle, style: .cancel) {
            if cancel != nil {
                cancel!(archiveAction)
            }
        })

        FSAlertCenter.shared.show(FSAlertSpec(isAlert: (style == UIAlertController.Style.alert),
                                              title: title,
                                              message: message,
                                              actions: specs),
                                  container: controller)

        return controller
    }
    
    @discardableResult
    public static func alertInput(number: Int, title: String, message: String, buttons: Int, buttonConfig: (FSAlertActionData) -> Void, textFieldConfig: ((UITextField) -> Void)?, completion: ((UIAlertController) -> Void)?) -> UIAlertController {
        
        let count = (1...5).contains(number) ? number : 1
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let tfConfigBox = FSUncheckedSendable(textFieldConfig)
        for i in 0..<count {
            alert.addTextField(configurationHandler: { @Sendable tf in
                MainActor.assumeIsolated {
                    tf.tag = i
                    tfConfigBox.value?(tf)
                }
            })
        }

        let textFields = alert.textFields ?? []
        var specs: [FSAlertActionSpec] = []

        for i in 0..<buttons {
            let data = FSAlertActionData()
            data.index = i
            data.style = .default

            buttonConfig(data)

            let act = FSAlertAction(title: data.title, style: data.style, handler: nil)
            act.data = data

            specs.append(FSAlertActionSpec(title: data.title, style: data.style) {
                // 把 SwiftUI 输入框的文本回写进容器，保持 `alert.textFields` 语义
                for (idx, tf) in textFields.enumerated() where idx < FSAlertCenter.shared.inputTexts.count {
                    tf.text = FSAlertCenter.shared.inputTexts[idx]
                }
                if data.click != nil {
                    data.click!(alert, act)
                }
            })
        }
        
        let inputs = textFields.map { tf in
            FSAlertInputSpec(placeholder: tf.placeholder ?? "",
                             keyboardType: tf.keyboardType,
                             text: tf.text ?? "",
                             showsClearButton: tf.clearButtonMode != .never) { _ in }
        }

        FSAlertCenter.shared.show(FSAlertSpec(isAlert: true,
                                              title: title,
                                              message: message,
                                              actions: specs,
                                              inputs: inputs),
                                  container: alert)

        completion?(alert)

        return alert
    }
    
    public static func showAlertWithMessage(_ message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        self.showAlertWithTitle(title: "温馨提示", message: message, ok: "确定", handler: handler)
    }
    
    public static func showAlertWithTitle(title: String, message: String, ok: String, handler: ((UIAlertAction) -> Void)? = nil) {
        // 2026-10-15 全 SwiftUI 化：改走 FSAlertCenter
        let action = UIAlertAction(title: ok, style: .default, handler: nil)
        FSAlertCenter.shared.show(FSAlertSpec(isAlert: true,
                                              title: title,
                                              message: message,
                                              actions: [FSAlertActionSpec(title: ok, style: .default) {
                                                  handler?(action)
                                              }]))
    }
    
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
        let image = FSImage.image(for: scrollView)
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
