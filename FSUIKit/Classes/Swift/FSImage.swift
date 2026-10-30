// FSImageS.swift
// Translated from FSImage.h/m

import UIKit
import Photos
import FSKit

public class FSImage: NSObject {
    
    /// 等比缩到指定宽度（按**像素**缩，与屏幕缩放无关）
    ///
    /// ★ 2026-10-30：`UIGraphicsBeginImageContext*` 系列自 iOS 17 起弃用，改用 `UIGraphicsImageRenderer`。
    /// `format.scale` 必须钉成 1 —— 这里是「按像素缩小」不是适配屏幕（原实现传的也是 1.0），
    /// 输出位图尺寸必须和以前完全一致：压缩工具页要显示压缩后的字节数与像素尺寸。
    public static func compressImage(_ sourceImage: UIImage, targetWidth: CGFloat) -> UIImage {
        let sourceWidth = sourceImage.size.width
        let sourceHeight = sourceImage.size.height
        guard sourceWidth > 0, sourceHeight > 0, targetWidth > 0 else { return sourceImage }

        let targetHeight = (targetWidth / sourceWidth) * sourceHeight

        let compressRate = sourceWidth * sourceHeight / (targetWidth * targetHeight)
        if compressRate <= 1.0 { return sourceImage }

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: targetWidth, height: targetHeight),
                                              format: format)
        return renderer.image { _ in
            sourceImage.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        }
    }
    
    public static func requestPhotoLibraryAddPermission(completion: @escaping (Bool) -> Void) {
        if #available(iOS 14, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
            if status == .authorized || status == .limited {
                completion(true)
                return
            }
            if status == .denied || status == .restricted {
                completion(false)
                return
            }
            // 2026-10-17：该回调是 @Sendable 闭包，completion 非 Sendable，装箱后捕获。
            let box = FSUncheckedSendable(completion)
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                box.value(newStatus == .authorized || newStatus == .limited)
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized {
                completion(true)
                return
            }
            if status == .denied || status == .restricted {
                completion(false)
                return
            }
            // 2026-10-17：同上。
            let box = FSUncheckedSendable(completion)
            PHPhotoLibrary.requestAuthorization { newStatus in
                box.value(newStatus == .authorized)
            }
        }
    }

    public static func saveToPhotoLibrary(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        // 2026-10-17：下面 performChanges 的 completionHandler 是 @Sendable，装箱后捕获。
        let box = FSUncheckedSendable(completion)
        requestPhotoLibraryAddPermission { granted in
            guard granted else {
                completion(false)
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetCreationRequest.creationRequestForAsset(from: image)
            }, completionHandler: { success, _ in
                box.value(success)
            })
        }
    }
}
