// FSImageS.swift
// Translated from FSImage.h/m

import UIKit

@objcMembers
public class FSImageS: NSObject {
    
    public static func image(from color: UIColor) -> UIImage? {
        return image(from: color, size: CGSize(width: 1, height: 10))
    }
    
    public static func image(from color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    public static func image(withSize size: CGSize, direction isHorizon: Bool, offsetLeft left: CGFloat, offsetRight right: CGFloat, ratios: [NSNumber], colors: [UIColor]) -> UIImage? {
        guard !ratios.isEmpty, ratios.count == colors.count else { return nil }
        
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        var sum: CGFloat = 0
        for (index, ratio) in ratios.enumerated() {
            let fratio = CGFloat(ratio.floatValue)
            let color = colors[index]
            
            context.setFillColor(color.cgColor)
            if isHorizon {
                context.fill(CGRect(x: 0, y: sum * size.height, width: size.width, height: fratio * size.height))
            } else {
                context.fill(CGRect(x: sum * size.width, y: 0, width: fratio * size.width, height: size.height))
            }
            sum += fratio
        }
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    public static func image(withSize size: CGSize, backgroundColor: UIColor?, mainColor: UIColor?, marginColor: UIColor?) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        if let bgColor = backgroundColor {
            context.setFillColor(bgColor.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: size.width * 0.25, height: size.height))
            context.fill(CGRect(x: size.width * 0.75, y: 0, width: size.width * 0.25, height: size.height))
        }
        
        if let main = mainColor {
            context.setFillColor(main.cgColor)
            context.fill(CGRect(x: size.width * 0.3125, y: 0, width: size.width * 0.375, height: size.height))
        }
        
        if let margin = marginColor {
            context.setFillColor(margin.cgColor)
            context.fill(CGRect(x: size.width * 0.25, y: 0, width: size.width * 0.0625, height: size.height))
            context.fill(CGRect(x: size.width * 0.6875, y: 0, width: size.width * 0.0625, height: size.height))
        }
        
        if let image = UIImage(named: "arrow") {
            context.draw(image.cgImage!, in: CGRect(x: size.width / 2 - 8, y: size.height / 2 - 8, width: 16, height: 16))
        }
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    public static func decodedImage(with image: UIImage) -> UIImage {
        if image.images != nil { return image }
        
        guard let imageRef = image.cgImage else { return image }
        let imageSize = CGSize(width: CGFloat(imageRef.width), height: CGFloat(imageRef.height))
        let imageRect = CGRect(origin: .zero, size: imageSize)
        
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return image }
        var bitmapInfo = imageRef.bitmapInfo
        
        let infoMask = bitmapInfo.intersection(.alphaInfoMask)
        let anyNonAlpha = infoMask == CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue) ||
                          infoMask == CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue) ||
                          infoMask == CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue)
        
        if infoMask == CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue) && colorSpace.numberOfComponents > 1 {
            bitmapInfo.remove(.alphaInfoMask)
            bitmapInfo.insert(CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue))
        } else if !anyNonAlpha && colorSpace.numberOfComponents == 3 {
            bitmapInfo.remove(.alphaInfoMask)
            bitmapInfo.insert(CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue))
        }
        
        guard let context = CGContext(data: nil, width: Int(imageSize.width), height: Int(imageSize.height), bitsPerComponent: imageRef.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return image }
        
        context.draw(imageRef, in: imageRect)
        guard let decompressedImageRef = context.makeImage() else { return image }
        
        return UIImage(cgImage: decompressedImageRef, scale: image.scale, orientation: image.imageOrientation)
    }
    
    public static func compressImage(_ sourceImage: UIImage, targetWidth: CGFloat) -> UIImage {
        let sourceWidth = sourceImage.size.width
        let sourceHeight = sourceImage.size.height
        let targetHeight = (targetWidth / sourceWidth) * sourceHeight
        
        let compressRate = sourceWidth * sourceHeight / (targetWidth * targetHeight)
        if compressRate <= 1.0 { return sourceImage }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight), false, 1.0)
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? sourceImage
    }
    
    public static func compressImage(_ image: UIImage, width minWidth: Int) -> UIImage? {
        guard image.size.width >= 1 else { return image }
        
        var comp = 1
        let oriWidth = Int(image.size.width)
        var targetWidth = oriWidth
        
        while targetWidth > minWidth {
            comp *= 2
            targetWidth = oriWidth / comp
        }
        if targetWidth < minWidth {
            comp /= 2
        }
        if comp < 2 { return image }
        
        if comp > 0 {
            let width = oriWidth / comp
            return compressImage(image, targetWidth: CGFloat(width))
        }
        return image
    }
    
    public static func image(for view: UIView) -> UIImage? {
        let size = view.bounds.size
        let savedFrame = view.frame
        let isScrollView = view is UIScrollView
        
        if isScrollView, let sView = view as? UIScrollView {
            let newSize = CGSize(width: sView.frame.width, height: sView.contentSize.height + sView.contentInset.top + sView.contentInset.bottom)
            view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: newSize.width, height: newSize.height)
        }
        
        var image: UIImage?
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            if #available(iOS 12.0, *) {
                format.preferredRange = .standard
            }
            let renderer = UIGraphicsImageRenderer(size: view.bounds.size, format: format)
            image = renderer.image { context in
                view.layer.render(in: context.cgContext)
            }
        }
        
        if isScrollView {
            view.frame = savedFrame
        }
        return image
    }
    
    public static func imageGradual(fromColorWithARed aRed: CGFloat, aGreen: CGFloat, aBlue: CGFloat, aAlpha: CGFloat, toColorWithBRed bRed: CGFloat, bGreen: CGFloat, bBlue: CGFloat, bAlpha: CGFloat, width: CGFloat, height: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        guard let rgb = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        
        context.scaleBy(x: width, y: height)
        let colors: [CGFloat] = [aRed, aGreen, aBlue, aAlpha, bRed, bGreen, bBlue, bAlpha]
        guard let backGradient = CGGradient(colorSpace: rgb, colorComponents: colors, locations: nil, count: 2) else { return nil }
        
        context.drawLinearGradient(backGradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 1.0, y: 0), options: .drawsBeforeStartLocation)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
