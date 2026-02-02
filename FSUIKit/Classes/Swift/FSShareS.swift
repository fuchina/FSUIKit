// FSShareS.swift
// Translated from FSShare.h/m
// Note: 微信SDK相关功能需要单独集成WechatOpenSDK

import UIKit
import MessageUI

@objcMembers
public class FSShareS: NSObject {
    
    public static let shared = FSShareS()
    
    public var result: ((Bool, String?) -> Void)?
    
    private var documentController: UIDocumentInteractionController?
    
    private override init() {
        super.init()
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
            showAlert(message: "设备不支持发送短信", on: controller)
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
            let name = fileName ?? "\(Int(Date().timeIntervalSince1970))"
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
            showAlert(message: "设备不支持发送邮件", on: controller)
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
    
    public func openDocumentInteractionController(_ fileURL: URL, in controller: UIViewController) {
        if documentController == nil {
            documentController = UIDocumentInteractionController(url: fileURL)
            documentController?.delegate = self
        } else {
            documentController?.url = fileURL
        }
        
        let canOpen = documentController?.presentOpenInMenu(from: .zero, in: controller.view, animated: true) ?? false
        if !canOpen {
            showAlert(message: "出现问题，不能打开", on: controller)
        }
    }
    
    // MARK: - Helper
    
    private func showAlert(message: String, on controller: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default))
        controller.present(alert, animated: true)
    }
}

// MARK: - MFMessageComposeViewControllerDelegate

extension FSShareS: MFMessageComposeViewControllerDelegate {
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
            _ = FSToastS.toast(msg, duration: 2)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension FSShareS: MFMailComposeViewControllerDelegate {
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
            _ = FSToastS.toast(msg, duration: 2)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIDocumentInteractionControllerDelegate

extension FSShareS: UIDocumentInteractionControllerDelegate {
    public func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        documentController = nil
    }
}
