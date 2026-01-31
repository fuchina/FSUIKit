//
//  FSShare.h
//  myhome
//
//  Created by FudonFuchina on 2017/8/25.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface FSShare : NSObject<WXApiDelegate>

+ (void)wechatAPIRegisterAppKey:(NSString *)appKey;

+(FSShare *)sharedInstance;

@property (nonatomic,copy) void (^result)(BOOL bSatus,NSString *bMessage);

+ (BOOL)handleOpenUrl:(NSURL *)url;

// 微信分享图片
+ (void)wxImageShareActionWithImage:(UIImage *)image controller:(UIViewController *)controller result:(void(^)(NSString *bResult))completion;

// 微信文件分享【@fileName不要带扩展名】
+ (void)wxFileShareActionWithPath:(NSString *)path fileName:(NSString *)fileName extension:(NSString *)extension controller:(UIViewController *)controller result:(void(^)(NSString *bResult))completion;

// 微信文字分享
+ (void)wxContentShare:(NSString *)content scene:(int)scene controller:(UIViewController *)controller;

// 微信url分享
+ (void)wxUrlShareTitle:(NSString *)title description:(NSString *)description url:(NSString *)url controller:(UIViewController *)controller;

// 短信分享
+ (void)messageShareWithMessage:(NSString *)message on:(UIViewController *)controller recipients:(NSArray *)recipients;
+ (void)messageShareWithMessage:(NSString *)message on:(UIViewController *)controller recipients:(NSArray *)recipients data:(NSData *)fileData fileName:(NSString *)fileName fileType:(NSString *)fileType;    // @"image/jpeg"    @"text/txt"     @"text/doc"     @"file/pdf"
- (void)messageShareWithMessage:(NSString *)message on:(UIViewController *)controller recipients:(NSArray *)recipients data:(NSData *)fileData fileName:(NSString *)fileName fileType:(NSString *)fileType;

// 邮件分享
+ (void)emailShareWithSubject:(NSString *)subject on:(UIViewController *)c messageBody:(NSString *)body recipients:(NSArray *)recipients;
+ (void)emailShareWithSubject:(NSString *)subject on:(UIViewController *)c messageBody:(NSString *)body recipients:(NSArray *)recipients fileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)fileType;
- (void)emailShareWithSubject:(NSString *)subject on:(UIViewController *)controller  messageBody:(NSString *)body recipients:(NSArray *)recipients fileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)fileType;

// 打开UIDocumentInteractionController
- (void)openUIDocumentInteractionController:(NSURL *)fileURL inController:(UIViewController *)controller;

@end
