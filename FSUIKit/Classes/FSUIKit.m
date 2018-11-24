//
//  FSUIKit.m
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/4/3.
//

#import "FSUIKit.h"
#import "FSWindow.h"
#import "FSKit.h"
#import "FSCalculator.h"

static CGRect oldframe;

@implementation FSUIKit

+ (void)alertOnCustomWindow:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(UIAlertAction *action))handler cancelTitle:(NSString *)cancelTitle cancel:(void (^)(UIAlertAction *action))cancel completion:(void (^)(void))completion{
    UIAlertController *controller = [self alertControllerWithStyle:style title:title message:message actionTitles:titles styles:styles handler:handler cancelTitle:cancelTitle cancel:cancel];
    [FSWindow presentViewController:controller animated:YES completion:completion];
}

+ (void)alertOnCustomWindow:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(UIAlertAction *action))handler{
    UIAlertController *controller = [self alertControllerWithStyle:style title:title message:message actionTitles:titles styles:styles handler:handler cancelTitle:NSLocalizedString(@"Cancel", nil) cancel:nil];
    [FSWindow presentViewController:controller animated:YES completion:nil];
}

+ (void)alert:(UIAlertControllerStyle)style controller:(UIViewController *)pController title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(UIAlertAction *action))handler cancelTitle:(NSString *)cancelTitle cancel:(void (^)(UIAlertAction *action))cancel completion:(void (^)(void))completion{
    UIAlertController *controller = [self alertControllerWithStyle:style title:title message:message actionTitles:titles styles:styles handler:handler cancelTitle:cancelTitle cancel:cancel];
    [pController presentViewController:controller animated:YES completion:completion];
}

+ (void)alert:(UIAlertControllerStyle)style controller:(UIViewController *)pController title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(UIAlertAction *action))handler{
    UIAlertController *controller = [self alertControllerWithStyle:style title:title message:message actionTitles:titles styles:styles handler:handler cancelTitle:NSLocalizedString(@"Cancel", nil) cancel:nil];
    [pController presentViewController:controller animated:YES completion:nil];
}

+ (UIAlertController *)alertControllerWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(UIAlertAction *action))handler cancelTitle:(NSString *)cancelTitle cancel:(void (^)(UIAlertAction *action))cancel{
    NSInteger count = MIN(titles.count, styles.count);
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    for (int x = 0; x < count; x ++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[x] style:[styles[x] integerValue] handler:^(UIAlertAction * _Nonnull action) {
            [FSWindow dismiss];
            if (handler) {
                handler(action);
            }
        }];
        [controller addAction:action];
    }
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [FSWindow dismiss];
        if (cancel) {
            cancel(action);
        }
    }];
    [controller addAction:archiveAction];
    return controller;
}

+ (void)alertInputOnCustomWindow:(NSInteger)number title:(NSString *)title message:(NSString *)message ok:(NSString *)okTitle handler:(void (^)(UIAlertController *bAlert,UIAlertAction *action))handler cancel:(NSString *)cancelTitle handler:(void (^)(UIAlertAction *action))cancelHandler textFieldConifg:(void (^)(UITextField *textField))configurationHandler completion:(void (^)(void))completion{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (number > 0) {
        for (int x = 0; x < number; x ++) {
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                if (configurationHandler) {
                    textField.tag = x;
                    configurationHandler(textField);
                }
            }];
        }
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [FSWindow dismiss];
        if (cancelHandler) {
            cancelHandler(action);
        }
    }];
    __weak typeof(alertController)wAlertController = alertController;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [FSWindow dismiss];
        if (handler) {
            handler(wAlertController,action);
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [FSWindow presentViewController:alertController animated:YES completion:completion];
}

+ (void)alertInput:(NSInteger)number controller:(UIViewController *)controller title:(NSString *)title message:(NSString *)message ok:(NSString *)okTitle handler:(void (^)(UIAlertController *bAlert,UIAlertAction *action))handler cancel:(NSString *)cancelTitle handler:(void (^)(UIAlertAction *action))cancelHandler textFieldConifg:(void (^)(UITextField *textField))configurationHandler completion:(void (^)(void))completion{
    if (![controller isKindOfClass:UIViewController.class]) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (number > 0) {
        for (int x = 0; x < number; x ++) {
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
                if (configurationHandler) {
                    textField.tag = x;
                    configurationHandler(textField);
                }
            }];
        }
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelHandler) {
            cancelHandler(action);
        }
    }];
    __weak typeof(alertController)wAlertController = alertController;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler(wAlertController,action);
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [controller presentViewController:alertController animated:YES completion:completion];
}

+ (void)showAlertWithMessageOnCustomWindow:(NSString *)message{
    [self showAlertWithTitleOnCustomWindow:NSLocalizedString(@"Tips", nil) message:message ok:NSLocalizedString(@"OK", nil) handler:nil];
}

+ (void)showAlertWithMessageOnCustomWindow:(NSString *)message handler:(void (^)(UIAlertAction *action))handler{
    [self showAlertWithTitleOnCustomWindow:NSLocalizedString(@"Tips", nil) message:message ok:NSLocalizedString(@"OK", nil) handler:handler];
}

+ (void)showAlertWithTitleOnCustomWindow:(NSString *)title message:(NSString *)message ok:(NSString *)ok handler:(void (^)(UIAlertAction *action))handler{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [FSWindow dismiss];
        if (handler) {
            handler(action);
        }
    }];
    [controller addAction:action];
    [FSWindow presentViewController:controller animated:YES completion:nil];
}

+ (void)showAlertWithMessage:(NSString *)message controller:(UIViewController *)controller{
    [self showAlertWithTitle:NSLocalizedString(@"Tips", nil) message:message ok:NSLocalizedString(@"OK", nil) controller:controller handler:nil];
}

+ (void)showAlertWithMessage:(NSString *)message controller:(UIViewController *)controller handler:(void (^)(UIAlertAction *action))handler{
    [self showAlertWithTitle:NSLocalizedString(@"Tips", nil) message:message ok:NSLocalizedString(@"OK", nil) controller:controller handler:handler];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message ok:(NSString *)ok controller:(UIViewController *)pController handler:(void (^)(UIAlertAction *action))handler{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:handler];
    [controller addAction:action];
    [pController presentViewController:controller animated:YES completion:nil];
}

+ (void)showMessageInMainThread:(NSString *)message{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, size.width, size.height - 64)];
    
    CGFloat width = size.width - 60;
    CGFloat height = MAX([FSCalculator textHeight:message font:[UIFont systemFontOfSize:15] labelWidth:width], 36);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(size.width / 2 - width / 2, size.height / 2 - height / 2, width, height)];
    label.text = message;
    label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8f];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 3;
    [backView addSubview:label];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:backView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.3 animations:^{
            label.alpha = 0.0;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
        }];
    });
}

+ (void)xuanzhuanView:(UIView *)view{
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

+ (void)showMessage:(NSString *)message{
    if (![message respondsToSelector:@selector(length)] || [message length] == 0) {
        return;
    }
    _fs_dispatch_main_queue_async(^{
        [self showMessageInMainThread:message];
    });
}

+ (void)showFullScreenImage:(UIImageView *)avatarImageView{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = avatarImageView.image;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
        backgroundView.backgroundColor=[UIColor blackColor];
        backgroundView.alpha=0;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
        imageView.image=image;
        imageView.tag=1;
        [backgroundView addSubview:imageView];
        [window addSubview:backgroundView];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
        [backgroundView addGestureRecognizer: tap];
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
            backgroundView.alpha=1;
        }completion:nil];
    });
}

+ (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha=0;
    }completion:^(BOOL finished) {
        [backgroundView
         removeFromSuperview];
    }];
}

+ (UIImage *)compressImageData:(NSData *)imageData{
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    if (imageData.length < 500 * 1024) {
        return image;
    }
    NSInteger compressRate = 0;
    if (image.size.height > image.size.width) {
        compressRate = [FSCalculator computeSampleSize:image minSideLength:750 maxNumOfPixels:1334 * 750];  // 安卓:1240 * 860
    }else{
        compressRate = [FSCalculator computeSampleSize:image minSideLength:750 maxNumOfPixels:750 * 1334];
    }
    
    NSInteger width = image.size.width / compressRate;
    return [self compressImage:image targetWidth:width];
}

+ (UIImage *)compressImage:(UIImage *)image width:(NSInteger)minWidth minHeight:(NSInteger)minHeight{
    if (![image isKindOfClass:UIImage.class]) {
        return nil;
    }
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (image.size.width < size.width) {
        return image;
    }
    NSInteger compressRate = 0;
    if (image.size.height > image.size.width) {
        compressRate = [FSCalculator computeSampleSize:image minSideLength:minWidth maxNumOfPixels:minWidth * minHeight];  // 安卓:1240 * 860
    }else{
        compressRate = [FSCalculator computeSampleSize:image minSideLength:minWidth maxNumOfPixels:minWidth * minHeight];
    }
    NSInteger width = image.size.width / compressRate;
    return [self compressImage:image targetWidth:width];
}

+ (UIImage *)compressImage:(UIImage *)image{
    if (![image isKindOfClass:UIImage.class]) {
        return nil;
    }
    if (image.size.width < [UIScreen mainScreen].bounds.size.width){
        return image;
    }
    NSInteger compressRate = 0;
    if (image.size.height > image.size.width) {
        compressRate = [FSCalculator computeSampleSize:image minSideLength:640 maxNumOfPixels:1136 * 640];  // 安卓:1240 * 860
    }else{
        compressRate = [FSCalculator computeSampleSize:image minSideLength:640 maxNumOfPixels:1136 * 640];
    }
    NSInteger width = image.size.width / compressRate;
    return [self compressImage:image targetWidth:width];
}

+ (UIImage *)compressImage:(UIImage *)image width:(NSInteger)width{
    if (![image isKindOfClass:UIImage.class]) {
        return nil;
    }
    if (image.size.width < [UIScreen mainScreen].bounds.size.width) {
        return image;
    }
    NSInteger compressRate = 0;
    if (image.size.height > image.size.width) {
        compressRate = [FSCalculator computeSampleSize:image minSideLength:width maxNumOfPixels:width * 1.775 * width];  // 安卓:1240 * 860
    }else{
        compressRate = [FSCalculator computeSampleSize:image minSideLength:width maxNumOfPixels:width * width * 1.775];
    }
    
    NSInteger targetWidth = image.size.width / compressRate;
    return [self compressImage:image targetWidth:targetWidth];
}

+ (UIImage*)imageForUIView:(UIView*)view{
    //    UIGraphicsBeginImageContext(view.bounds.size);// 只会生成屏幕所见的部分
    CGSize size = view.bounds.size;
    if ([view isKindOfClass:UIScrollView.class]) {
        UIScrollView *sView = (UIScrollView *)view;
        size = CGSizeMake(sView.frame.size.width,sView.contentSize.height+ sView.contentInset.top+ sView.contentInset.bottom);
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, view.layer.contentsScale);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    //    CGContextRestoreGState(currnetContext);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    CGRect frame = scrollView.frame;
    //设置控件显示的区域大小     key:显示
    scrollView.frame = CGRectMake(0, scrollView.frame.origin.y, scrollView.contentSize.width, scrollView.contentSize.height);
    
    //设置截屏大小(截屏区域的大小必须要跟视图控件的大小一样)
    UIGraphicsBeginImageContextWithOptions(scrollView.frame.size, YES, 0.0);
    [[scrollView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    scrollView.frame = frame;
    return viewImage;
}

//截取view生成一张图片
+ (UIImage *)shotWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//全屏截图
+ (UIImage *)shotFullScreen{
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    UIGraphicsBeginImageContext(window.bounds.size);
    //    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return image;
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, 0.0); // no ritina
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if(window == screenWindow){
            break;
        }else{
            [window.layer renderInContext:context];
        }
    }
    
    //    //    ////////////////////////
    if ([screenWindow respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [screenWindow drawViewHierarchyInRect:screenWindow.bounds afterScreenUpdates:YES];
    } else {
        [screenWindow.layer renderInContext:context];
    }
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    screenWindow.layer.contents = nil;
    UIGraphicsEndImageContext();
    
    float iOSVersion = [UIDevice currentDevice].systemVersion.floatValue;
    if(iOSVersion < 8.0){
        image = [self rotateUIInterfaceOrientationImage:image];
    }
    return image;
}

//Avilable in iOS 8.0 and later
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    return effectView;
}

+ (UIImage *)rotateUIInterfaceOrientationImage:(UIImage *)image{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationLandscapeRight:{
            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationLeft];
        }break;
        case UIInterfaceOrientationLandscapeLeft:{
            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationRight];
        }break;
        case UIInterfaceOrientationPortraitUpsideDown:{
            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationDown];
        }break;
        case UIInterfaceOrientationPortrait:{
            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationUp];
        }break;
        case UIInterfaceOrientationUnknown:{
        }break;
        default:
            break;
    }
    
    return image;
}


/**
 *  调整图片饱和度, 亮度, 对比度
 *
 *  @param image      目标图片
 *  @param saturation 饱和度
 *  @param brightness 亮度: -1.0 ~ 1.0
 *  @param contrast   对比度
 *
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    
    [filter setValue:@(saturation) forKey:@"inputSaturation"];
    [filter setValue:@(brightness) forKey:@"inputBrightness"];
    [filter setValue:@(contrast) forKey:@"inputContrast"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}

+ (UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    if (sourceImage.size.width < defineWidth) {
        return sourceImage;
    }
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)compressImage:(UIImage *)sourceImage targetWidth:(CGFloat)targetWidth{
    CGFloat sourceWidth = sourceImage.size.width;
    CGFloat sourceHeight = sourceImage.size.height;
    CGFloat targetHeight = (targetWidth / sourceWidth) * sourceHeight;
    
    CGFloat compressRate = sourceWidth * sourceHeight / (targetWidth * targetHeight);
    if (compressRate <= 1.0f) {
        return sourceImage;
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter = [CIFilter filterWithName:name];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return resultImage;
}

#pragma mark - 对图片进行模糊处理
// CIGaussianBlur ---> 高斯模糊
// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
// CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
// CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:image];
    CIFilter *filter;
    if (name.length != 0) {
        filter = [CIFilter filterWithName:name];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        if (![name isEqualToString:@"CIMedianFilter"]) {
            [filter setValue:@(radius) forKey:@"inputRadius"];
        }
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];
        UIImage *resultImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        return resultImage;
    }else{
        return nil;
    }
}



//截取view中某个区域生成一张图片
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self shotWithView:view].CGImage, scope);
    UIGraphicsBeginImageContext(scope.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, scope.size.width, scope.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//下移
    CGContextScaleCTM(context, 1.0f, -1.0f);//上翻
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
    return image;
}

+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //圆的边框宽度为2，颜色为红色
    CGContextSetLineWidth(context,2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    //在圆区域内画出image原图
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    
    //生成新的image
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (UIImage *)imageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 10);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


+ (UIImage *)QRImageFromString:(NSString *)sourceString{
    if (sourceString == nil) {
        sourceString = @"";
    }
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *ciImage = [filter outputImage];
    //UIImage *unsharpImage = [UIImage imageWithCIImage:ciImage];//不清晰
    UIImage *image = [self createNonInterpolatedUIImageFormCIImage:ciImage withSize:960];
    return image;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(cs);
    UIImage *result = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return result;
}

/*
 ** lineFrame:     虚线的 frame
 ** length:        虚线中短线的宽度
 ** spacing:       虚线中短线之间的间距
 ** color:         虚线中短线的颜色
 */
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing
                            lineColor:(UIColor *)color{
    UIView *dashedLine = [[UIView alloc] initWithFrame:lineFrame];
    dashedLine.backgroundColor = [UIColor clearColor];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:dashedLine.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(dashedLine.frame) / 2, CGRectGetHeight(dashedLine.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:color.CGColor];
    [shapeLayer setLineWidth:CGRectGetHeight(dashedLine.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:length], [NSNumber numberWithInt:spacing], nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(dashedLine.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [dashedLine.layer addSublayer:shapeLayer];
    return dashedLine;
}


@end
