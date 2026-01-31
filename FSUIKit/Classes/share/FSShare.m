//
//  FSShare.m
//  myhome
//
//  Created by FudonFuchina on 2017/8/25.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import "FSShare.h"
#import <MessageUI/MessageUI.h>

#import "FSKit.h"
#import "FSUIKit.h"
#import "FSImage.h"

#import "FSUIKit-Swift.h"

@interface FSShare ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController   *documentController;

@end

@implementation FSShare

static FSShare *_instance = nil;
+(FSShare *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FSShare alloc] init];
    });
    return _instance;
}

+ (void)wechatAPIRegisterAppKey:(NSString *)appKey{
#if TARGET_IPHONE_SIMULATOR
#else
    if ([appKey isKindOfClass:NSString.class] && appKey.length) {
        [WXApi registerApp:appKey];
    }
#endif
}

+ (BOOL)handleOpenUrl:(NSURL *)url{
    FSShare *share = [[FSShare alloc] init];
    return [WXApi handleOpenURL:url delegate:share];
}

#pragma mark WXDelegate
-(void)onReq:(BaseReq*)req {
}

-(void)onResp:(BaseResp*)resp {
    if([resp isKindOfClass:SendMessageToWXResp.class]){   // SendAuthResp
        UIWindowScene *ws = [FSKit currentWindowScene];
        if (@available(iOS 15.0, *)) {
            [FSUIKit showAlertWithMessage: resp.errStr controller: ws.keyWindow.rootViewController];
        }
    }
}

// 微信分享图片
+ (void)wxImageShareActionWithImage:(UIImage *)image controller:(UIViewController *)controller result:(void(^)(NSString *bResult))completion{
    if (!([image isKindOfClass:[UIImage class]] && image.size.width > 1 && image.size.height > 1)) {
        [FSUIKit showAlertWithMessage: @"分享的不是图片" controller: controller];
        return;
    }
    BOOL hasInstalled = [self checkPhoneHasWechat: controller];
    if (!hasInstalled) {
        return;
    }
        
    UIImage *thumbImage = [FSImage compressImage:image width:50];
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumbImage];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(image);
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

// 微信文件分享
+ (void)wxFileShareActionWithPath:(NSString *)path fileName:(NSString *)fileName extension:(NSString *)extension controller:(UIViewController *)controller result:(void(^)(NSString *bResult))completion{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ((![manager fileExistsAtPath:path]) || fileName == nil || extension == nil) {
        return;
    }
    BOOL hasInstalled = [self checkPhoneHasWechat: controller];
    if (!hasInstalled) {
        return;
    }
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = extension;
    ext.fileData = [NSData dataWithContentsOfFile:path];
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = [[NSString alloc] initWithFormat:@"%@.%@",fileName,extension];
    message.description = @"文件分享";
    //    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

+ (void)wxContentShare:(NSString *)content scene:(int)scene controller:(UIViewController *)controller {
    if (!_fs_isValidateString(content)) {
        return;
    }
    BOOL hasInstalled = [self checkPhoneHasWechat: controller];
    if (!hasInstalled) {
        return;
    }
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = content;
    req.bText = YES;
    req.scene = scene;
    [WXApi sendReq:req];
}

+ (void)wxUrlShareTitle:(NSString *)title description:(NSString *)description url:(NSString *)url controller:(UIViewController *)controller {
    BOOL hasInstalled = [self checkPhoneHasWechat: controller];
    if (!hasInstalled) {
        return;
    }
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
 
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:[UIImage imageNamed:@"logo_wx_small"]];
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

+ (BOOL)checkPhoneHasWechat:(UIViewController *)controller {
    BOOL hasInstalledWeChat = [WXApi isWXAppInstalled];
    if (!hasInstalledWeChat) {
        [FSUIKit alert: UIAlertControllerStyleAlert controller: controller title: @"微信分享" message: @"未安装微信，是否去下载？" actionTitles: @[@"下载"] styles: @[@(UIAlertActionStyleDefault)] handler:^(FSAlertAction *action) {
            NSString *url = [WXApi getWXAppInstallUrl];
            NSURL *u = [NSURL URLWithString: url];
            if ([UIApplication.sharedApplication canOpenURL: u]) {
                if (@available(iOS 10.0, *)) {
                    [UIApplication.sharedApplication openURL: u options: @{} completionHandler:^(BOOL success) {}];
                }
            }
        }];
    }
    return hasInstalledWeChat;
}

// 邮件分享
+ (void)emailShareWithSubject:(NSString *)subject on:(UIViewController *)c messageBody:(NSString *)body recipients:(NSArray *)recipients{
    [self emailShareWithSubject:subject on:c messageBody:body recipients:recipients fileData:nil fileName:nil mimeType:nil];
}

+ (void)emailShareWithSubject:(NSString *)subject on:(UIViewController *)c messageBody:(NSString *)body recipients:(NSArray *)recipients fileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)fileType{
    [[FSShare sharedInstance] emailShareWithSubject:subject on:c messageBody:body recipients:recipients fileData:data fileName:fileName mimeType:fileType ];
}

- (void)emailShareWithSubject:(NSString *)subject on:(UIViewController *)controller  messageBody:(NSString *)body recipients:(NSArray *)recipients fileData:(NSData *)data fileName:(NSString *)fileName mimeType:(NSString *)fileType {
    if (![controller isKindOfClass:UIViewController.class]) {
        return;
    }
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    if (_fs_isValidateString(subject)) {
        [picker setSubject:subject];
    }
    if (_fs_isValidateArray(recipients)) {
        [picker setToRecipients:recipients];
    }
    if (body) {
        [picker setMessageBody:body isHTML:NO];
    }
    if ([data isKindOfClass:NSData.class] && data.length) {
        [picker addAttachmentData:data mimeType:fileType fileName:fileName];
    }
    if (picker) {
        [controller presentViewController:picker animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSString *msg = nil;
    switch (result){
        case MFMailComposeResultCancelled:
//            msg = @"邮件发送取消";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件保存成功";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件推送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"邮件发送失败";
            break;
        default:
            break;
    }
    
    if (msg) {
        __unused id obj = [FSToastS toast: msg duration: 2];
    }
    [controller dismissViewControllerAnimated: YES completion: nil];
}

// 短信分享
+ (void)messageShareWithMessage:(NSString *)message on:(UIViewController *)controller recipients:(NSArray *)recipients{
    [self messageShareWithMessage:message on:controller recipients:recipients data:nil fileName:nil fileType:nil];
}

+ (void)messageShareWithMessage:(NSString *)message on:(UIViewController *)controller recipients:(NSArray *)recipients data:(NSData *)fileData fileName:(NSString *)fileName fileType:(NSString *)fileType{    // @"image/jpeg"    @"text/txt"     @"text/doc"     @"file/pdf"
    [[FSShare sharedInstance] messageShareWithMessage:message on:controller recipients:recipients data:fileData fileName:fileName fileType:fileType];
}

- (void)messageShareWithMessage:(NSString *)message on:(UIViewController *)controller recipients:(NSArray *)recipients data:(NSData *)fileData fileName:(NSString *)fileName fileType:(NSString *)fileType{    // @"image/jpeg"    @"text/txt"     @"text/doc"     @"file/pdf"
    if (![controller isKindOfClass:UIViewController.class]) {
        return;
    }
    if (![MFMessageComposeViewController canSendText]) {
        [FSUIKit showAlertWithMessage:@"设备不支持发送短信" controller:controller];
        return;
    }
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    if (recipients) {
        picker.recipients = recipients;
    }
    if (message) {
        picker.body = message;
    }
    if ([fileData isKindOfClass:NSData.class]) {
        if (!([fileName isKindOfClass:NSString.class] && fileName.length)) {
            fileName = @((NSInteger)[[NSDate date] timeIntervalSince1970]).stringValue;
        }
        [picker addAttachmentData:fileData typeIdentifier:fileType filename:fileName];
    }
    if (picker) {
        [controller presentViewController:picker animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSString *msg = nil;
    switch (result){
        case MessageComposeResultCancelled:
//            msg = @"短信发送取消";
            break;
        case MessageComposeResultSent:
            msg = @"短信发送成功";
            break;
        case MessageComposeResultFailed:
            msg = @"短信发送失败";
            break;
        default:
            break;
    }
    
    if (msg) {
        __unused id obj = [FSToastS toast: msg duration: 2];
    }
    [controller dismissViewControllerAnimated: YES completion: nil];
}

- (void)openUIDocumentInteractionController:(NSURL *)fileURL inController:(UIViewController *)controller {
    if (fileURL) {
        if (!self.documentController) {
            self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
            [self.documentController setDelegate:self];
        }else{
            self.documentController.URL = fileURL;
        }
        BOOL canOpen =  [self.documentController presentOpenInMenuFromRect:CGRectZero inView:controller.view animated:YES];
        if (canOpen == NO) {
            [FSUIKit showAlertWithMessage:@"出现问题，不能打开" controller:controller];
        }
    }
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller {
    self.documentController = nil;
}


@end
