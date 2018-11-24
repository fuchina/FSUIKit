//
//  FSPdf.h
//  FSPDF
//
//  Created by fudon on 2017/1/10.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSPdf : NSObject

// 将文本生成pdf文件，返回path;
+ (NSString *)pdfForString:(NSString *)text pdfName:(NSString *)pdfName;
+ (NSString *)pdfForString:(NSString *)text pdfName:(NSString *)pdfName password:(NSString *)password;

// 将UIImage转换为pdf，fileName为pdf名字，可以设置密码password
+ (NSString *)pdfForImage:(UIImage *)image pdfName:(NSString *)pdfName password:(NSString *)password;
+ (NSString *)pdfForImageData:(NSData *)data pdfName:(NSString *)pdfName password:(NSString *)password;

// 将UIView生成pdf文件，返回文件路径
// eg. [FSPdf pdfForView:self.view fileName:@"abc.pdf"];
+ (NSString *)pdfForView:(UIView *)view pdfName:(NSString *)pdfName;

@end
