// FSShare.swift
// Translated from FSShare.h/m
// Note: 微信SDK相关功能需要集成WechatOpenSDK

import UIKit
import MessageUI

//import WechatOpenSDK  暂不支持，需要OC桥接，后续实现

@objcMembers
public class FSShare: NSObject {
    
    public static let shared = FSShare()
    
    public var result: ((Bool, String?) -> Void)?
    
    private var documentController: UIDocumentInteractionController?
    
    private override init() {
        super.init()
    }
    
    // MARK: - 微信注册
    
    public static func wechatAPIRegisterAppKey(_ appKey: String?) {
//        #if !targetEnvironment(simulator)
//        guard let appKey = appKey, !appKey.isEmpty else { return }
//        WXApi.registerApp(appKey, universalLink: "")
//        #endif
    }
    
    public static func handleOpenUrl(_ url: URL) -> Bool {
        return false
//        let share = FSShare()
//        return WXApi.handleOpen(url, delegate: share)
    }
    
    // MARK: - 微信分享图片
    
    public static func wxImageShareAction(with image: UIImage?, controller: UIViewController, result completion: ((String?) -> Void)?) {
//        guard let image = image, image.size.width > 1, image.size.height > 1 else {
//            FSUIKit.showAlert(withMessage: "分享的不是图片", controller: controller)
//            return
//        }
//        
//        guard checkPhoneHasWechat(controller) else { return }
//        
//        let thumbImage = FSImage.compressImage(image, width: 50)
//        
//        let message = WXMediaMessage()
//        message.setThumbImage(thumbImage)
//        
//        let ext = WXImageObject()
//        ext.imageData = image.pngData()
//        message.mediaObject = ext
//        
//        let req = SendMessageToWXReq()
//        req.bText = false
//        req.message = message
//        req.scene = Int32(WXSceneSession.rawValue)
//        WXApi.send(req)
    }
    
    // MARK: - 微信文件分享
    
    public static func wxFileShareAction(withPath path: String?, fileName: String?, extension ext: String?, controller: UIViewController, result completion: ((String?) -> Void)?) {
//        guard let path = path, let fileName = fileName, let ext = ext else { return }
//        
//        let manager = FileManager.default
//        guard manager.fileExists(atPath: path) else { return }
//        guard checkPhoneHasWechat(controller) else { return }
//        
//        let fileObject = WXFileObject()
//        fileObject.fileExtension = ext
//        fileObject.fileData = try? Data(contentsOf: URL(fileURLWithPath: path))
//        
//        let message = WXMediaMessage()
//        message.title = "\(fileName).\(ext)"
//        message.description = "文件分享"
//        message.mediaObject = fileObject
//        
//        let req = SendMessageToWXReq()
//        req.bText = false
//        req.message = message
//        req.scene = Int32(WXSceneSession.rawValue)
//        WXApi.send(req)
    }
    
    // MARK: - 微信文字分享
    
    public static func wxContentShare(_ content: String?, scene: Int32, controller: UIViewController) {
        guard let content = content, !content.isEmpty else { return }
        guard checkPhoneHasWechat(controller) else { return }
        
//        let req = SendMessageToWXReq()
//        req.text = content
//        req.bText = true
//        req.scene = scene
//        WXApi.send(req)
    }
    
    // MARK: - 微信URL分享
    
    public static func wxUrlShareTitle(_ title: String?, description: String?, url: String?, controller: UIViewController) {
        guard checkPhoneHasWechat(controller) else { return }
        
//        let ext = WXWebpageObject()
//        ext.webpageUrl = url ?? ""
//        
//        let message = WXMediaMessage()
//        message.title = title
//        message.description = description
//        message.setThumbImage(UIImage(named: "logo_wx_small"))
//        message.mediaObject = ext
//        
//        let req = SendMessageToWXReq()
//        req.bText = false
//        req.message = message
//        req.scene = Int32(WXSceneSession.rawValue)
//        WXApi.send(req)
    }
    
    // MARK: - 检查微信安装
    
    public static func checkPhoneHasWechat(_ controller: UIViewController) -> Bool {
//        let hasInstalled = WXApi.isWXAppInstalled()
//        if !hasInstalled {
//            FSUIKit.alert(.actionSheet, controller: controller, title: "微信分享", message: "未安装微信，是否去下载？", actionTitles: ["下载"], styles: [NSNumber(value: UIAlertAction.Style.default.rawValue)]) { action in
//                if let url = URL(string: WXApi.getWXAppInstallUrl()) {
//                    if UIApplication.shared.canOpenURL(url) {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    }
//                }
//            }
//        }
//        return hasInstalled
        
        return false
    }
    
    // MARK: - 短信分享
    
    public static func messageShare(withMessage message: String?, on controller: UIViewController, recipients: [String]?) {
        messageShare(withMessage: message, on: controller, recipients: recipients, data: nil, fileName: nil, fileType: nil)
    }
    
    public static func messageShare(withMessage message: String?, on controller: UIViewController, recipients: [String]?, data fileData: Data?, fileName: String?, fileType: String?) {
        shared.messageShare(withMessage: message, on: controller, recipients: recipients, data: fileData, fileName: fileName, fileType: fileType)
    }
    
    public func messageShare(withMessage message: String?, on controller: UIViewController, recipients: [String]?, data fileData: Data?, fileName: String?, fileType: String?) {
        guard MFMessageComposeViewController.canSendText() else {
            FSUIKit.showAlertWithMessage("设备不支持发送短信", controller: controller)
            return
        }
        
        let picker = MFMessageComposeViewController()
        picker.messageComposeDelegate = self
        
        if let recipients = recipients {
            picker.recipients = recipients
        }
        if let message = message {
            picker.body = message
        }
        if let fileData = fileData {
            let name = (fileName?.isEmpty == false) ? fileName! : "\(Int(Date().timeIntervalSince1970))"
            picker.addAttachmentData(fileData, typeIdentifier: fileType ?? "", filename: name)
        }
        
        controller.present(picker, animated: true, completion: nil)
    }
    
    // MARK: - 邮件分享
    
    public static func emailShare(withSubject subject: String?, on controller: UIViewController, messageBody body: String?, recipients: [String]?) {
        emailShare(withSubject: subject, on: controller, messageBody: body, recipients: recipients, fileData: nil, fileName: nil, mimeType: nil)
    }
    
    public static func emailShare(withSubject subject: String?, on controller: UIViewController, messageBody body: String?, recipients: [String]?, fileData data: Data?, fileName: String?, mimeType fileType: String?) {
        shared.emailShare(withSubject: subject, on: controller, messageBody: body, recipients: recipients, fileData: data, fileName: fileName, mimeType: fileType)
    }
    
    public func emailShare(withSubject subject: String?, on controller: UIViewController, messageBody body: String?, recipients: [String]?, fileData data: Data?, fileName: String?, mimeType fileType: String?) {
        guard MFMailComposeViewController.canSendMail() else {
            FSUIKit.showAlertWithMessage("设备不支持发送邮件", controller: controller)
            return
        }
        
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        
        if let subject = subject, !subject.isEmpty {
            picker.setSubject(subject)
        }
        if let recipients = recipients, !recipients.isEmpty {
            picker.setToRecipients(recipients)
        }
        if let body = body {
            picker.setMessageBody(body, isHTML: false)
        }
        if let data = data, !data.isEmpty, let fileName = fileName, let fileType = fileType {
            picker.addAttachmentData(data, mimeType: fileType, fileName: fileName)
        }
        
        controller.present(picker, animated: true, completion: nil)
    }
    
    // MARK: - UIDocumentInteractionController
    
    public func openDocumentInteractionController(_ fileURL: URL?, in controller: UIViewController) {
        guard let fileURL = fileURL else { return }
        
        if documentController == nil {
            documentController = UIDocumentInteractionController(url: fileURL)
            documentController?.delegate = self
        } else {
            documentController?.url = fileURL
        }
        
        let canOpen = documentController?.presentOpenInMenu(from: .zero, in: controller.view, animated: true) ?? false
        if !canOpen {
            FSUIKit.showAlertWithMessage("出现问题，不能打开", controller: controller)
        }
    }
}

// MARK: - WXApiDelegate

//extension FSShare: WXApiDelegate {
//    public func onReq(_ req: BaseReq) {
//        // Handle request
//    }
//    
//    public func onResp(_ resp: BaseResp) {
//        if resp is SendMessageToWXResp {
//            if let windowScene = FSKit.currentWindowScene(),
//               let rootVC = windowScene.keyWindow?.rootViewController {
//                FSUIKit.showAlert(withMessage: resp.errStr, controller: rootVC)
//            }
//        }
//    }
//}

// MARK: - MFMessageComposeViewControllerDelegate

extension FSShare: MFMessageComposeViewControllerDelegate {
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        var msg: String?
        switch result {
        case .cancelled:
            break
        case .sent:
            msg = "短信发送成功"
        case .failed:
            msg = "短信发送失败"
        @unknown default:
            break
        }
        
        if let msg = msg {
            _ = FSToast.toast(msg, duration: 2)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension FSShare: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var msg: String?
        switch result {
        case .cancelled:
            break
        case .saved:
            msg = "邮件保存成功"
        case .sent:
            msg = "邮件推送成功"
        case .failed:
            msg = "邮件发送失败"
        @unknown default:
            break
        }
        
        if let msg = msg {
            _ = FSToast.toast(msg, duration: 2)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIDocumentInteractionControllerDelegate

extension FSShare: UIDocumentInteractionControllerDelegate {
    public func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        documentController = nil
    }
}
