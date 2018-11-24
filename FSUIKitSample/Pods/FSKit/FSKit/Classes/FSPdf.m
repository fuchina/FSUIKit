//
//  FSPdf.m
//  FSPDF
//
//  Created by fudon on 2017/1/10.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSPdf.h"
#import <CoreText/CoreText.h>

@implementation FSPdf

+ (NSString *)pdfForString:(NSString *)text pdfName:(NSString *)pdfName{
    return [self pdfForString:text pdfName:pdfName password:nil];
}

+ (NSString *)pdfForString:(NSString *)text pdfName:(NSString *)pdfName password:(NSString *)password{
    if (!([text isKindOfClass:NSString.class] && text.length)) {
        return nil;
    }
    if (!([pdfName isKindOfClass:NSString.class] && pdfName.length)) {
        pdfName = [[NSString alloc] initWithFormat:@"%@.pdf",@((NSInteger)[[NSDate date] timeIntervalSince1970])];
    }
    
    CFMutableDictionaryRef myDictionary = NULL;
    if (password) {
        myDictionary = CFDictionaryCreateMutable(NULL,0,&kCFTypeDictionaryKeyCallBacks,&kCFTypeDictionaryValueCallBacks);
        CFDictionarySetValue(myDictionary, kCGPDFContextTitle,CFSTR("扶氏软件"));
        CFDictionarySetValue(myDictionary,kCGPDFContextCreator,CFSTR("FuSoft"));

        CFDictionarySetValue(myDictionary, kCGPDFContextUserPassword, (__bridge const void *)(password));
        CFDictionarySetValue(myDictionary, kCGPDFContextOwnerPassword, (__bridge const void *)(password));
    }

    NSString *pdfFileName = [NSTemporaryDirectory() stringByAppendingPathComponent:pdfName];
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, (CFStringRef)text, NULL);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(currentText);
    if (currentText && framesetter) {
        UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, (__bridge NSDictionary * _Nullable)(myDictionary));
        CFRange currentRange = CFRangeMake(0, 0);
        NSInteger currentPage = 0;
        BOOL done = NO;
        do {
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0,
                                                      0,
                                                      [UIScreen mainScreen].bounds.size.width,
                                                      [UIScreen mainScreen].bounds.size.height),
                                           nil);
            currentPage++;
            [self drawPageNumber:currentPage];
            currentRange = [self renderPage:currentPage withTextRange:currentRange andFramesetter:framesetter];
            if (currentRange.location == CFAttributedStringGetLength((CFAttributedStringRef)currentText))
                done = YES;
        } while (!done);
        UIGraphicsEndPDFContext();
        CFRelease(framesetter);
        CFRelease(currentText);
    }else{
        pdfFileName = nil;
        if (currentText) {
            CFRelease(currentText);
        }
        if (framesetter) {
            CFRelease(framesetter);
        }
    }
    return pdfFileName;
}

+ (CFRange)renderPage:(NSInteger)pageNum withTextRange:(CFRange)currentRange
       andFramesetter:(CTFramesetterRef)framesetter{
    CGContextRef  currentContext = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);
    
    // 文本的内容区间
    CGRect frameRect = CGRectMake(20,    // 距离左边
                                  20,    // 距离顶部
                                  [UIScreen mainScreen].bounds.size.width - 40,      // 宽度
                                  [UIScreen mainScreen].bounds.size.height - 50);    // 高度
    
    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);

    CGContextTranslateCTM(currentContext, 0, [UIScreen mainScreen].bounds.size.height);
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CTFrameDraw(frameRef, currentContext);
    currentRange = CTFrameGetVisibleStringRange(frameRef);
    currentRange.location += currentRange.length;
    currentRange.length = 0;
    CFRelease(frameRef);
    
    return currentRange;
}

+ (void)drawPageNumber:(NSInteger)pageNum{
    NSString *pageString = [NSString stringWithFormat:@"- %@ -", @(pageNum)];
    UIFont *font = [UIFont systemFontOfSize:10];
    CGRect rect = [pageString boundingRectWithSize:CGSizeMake(100, 20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    CGRect stringRect = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - rect.size.width / 2,[UIScreen mainScreen].bounds.size.height - 20, rect.size.width,20);
    [pageString drawInRect:stringRect withAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}

+ (NSString *)pdfForView:(UIView *)view pdfName:(NSString *)pdfName{
    if (!([pdfName isKindOfClass:NSString.class] && pdfName.length)) {
        return nil;
    }
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:pdfName];
    
    CGContextRef pdfContext = NULL;
    CFURLRef url = CFURLCreateWithFileSystemPath (NULL, (CFStringRef)path,kCFURLPOSIXPathStyle,false);
    if (url != NULL) {
        CGRect inMediaBox = view.bounds;
        pdfContext = CGPDFContextCreateWithURL (url,&inMediaBox, NULL);
        CFRelease(url);
    }
    if (!pdfContext) {
        return nil;
    }else{
        CGContextBeginPage (pdfContext,nil);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGContextConcatCTM(pdfContext, transform);
        [view.layer renderInContext:pdfContext];
        CGContextEndPage (pdfContext);
        CGContextRelease(pdfContext);
        return path;
    }
}

+ (NSString *)pdfForImage:(UIImage *)image pdfName:(NSString *)pdfName password:(NSString *)password{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    return [self pdfForImageData:data pdfName:pdfName password:password];
}

+ (NSString *)pdfForImageData:(NSData *)data pdfName:(NSString *)pdfName password:(NSString *)password{
    if (!pdfName) {
        pdfName = [[NSString alloc] initWithFormat:@"%@.pdf",@((NSInteger)[[NSDate date] timeIntervalSince1970])];
    }
    if (!data) {
        return nil;
    }
    if (!([password isKindOfClass:NSString.class] && password.length)) {
        password = nil;
    }
    return [self FSCreatePDFFileWithSrc:data toDestFile:pdfName withPassword:password];
}

+ (NSString *)FSCreatePDFFileWithSrc:(NSData *)imgData toDestFile:(NSString *)destFileName withPassword:(NSString *)pw{
    NSString *fileFullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:destFileName];
    const char *path = [fileFullPath UTF8String];
    CFDataRef data = (__bridge CFDataRef)imgData;
    UIImage *image = [UIImage imageWithData:imgData];
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CFStringRef password = (__bridge CFStringRef)pw;
    FSCreatePDFFile(data,rect, path, password);
    
    return fileFullPath;
}

void FSCreatePDFFile (CFDataRef data,CGRect pageRect,const char *filepath,CFStringRef password){
    CGContextRef pdfContext;
    CFStringRef path;
    CFURLRef url;
    CFDataRef boxData = NULL;
    CFMutableDictionaryRef myDictionary = NULL;
    CFMutableDictionaryRef pageDictionary = NULL;
    
    path = CFStringCreateWithCString (NULL, filepath,kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path,kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    myDictionary = CFDictionaryCreateMutable(NULL,0,&kCFTypeDictionaryKeyCallBacks,&kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(myDictionary, kCGPDFContextTitle,CFSTR("Photo from iPrivate Album"));
    CFDictionarySetValue(myDictionary,kCGPDFContextCreator,CFSTR("iPrivate Album"));
    if (password) {
        CFDictionarySetValue(myDictionary, kCGPDFContextUserPassword, password);
        CFDictionarySetValue(myDictionary, kCGPDFContextOwnerPassword, password);
    }
    
    pdfContext = CGPDFContextCreateWithURL (url, &pageRect, myDictionary);
    CFRelease(myDictionary);
    CFRelease(url);
    pageDictionary = CFDictionaryCreateMutable(NULL,0,&kCFTypeDictionaryKeyCallBacks,&kCFTypeDictionaryValueCallBacks);
    boxData = CFDataCreate(NULL,(const UInt8 *)&pageRect, sizeof (CGRect));
    CFDictionarySetValue(pageDictionary, kCGPDFContextMediaBox, boxData);
    CGPDFContextBeginPage (pdfContext, pageDictionary);
    FSDrawContent(pdfContext,data,pageRect);
    CGPDFContextEndPage (pdfContext);  
    
    CGContextRelease (pdfContext);  
    CFRelease(pageDictionary);  
    CFRelease(boxData);  
}

void FSDrawContent(CGContextRef myContext,CFDataRef data,CGRect rect){
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(data);
    CGImageRef image = CGImageCreateWithJPEGDataProvider(dataProvider,
                                                         NULL,
                                                         NO,
                                                         kCGRenderingIntentDefault);
    CGContextDrawImage(myContext, rect, image);
    CGDataProviderRelease(dataProvider);
    CGImageRelease(image);
}

@end
