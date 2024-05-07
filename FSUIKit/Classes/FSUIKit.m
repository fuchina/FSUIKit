//
//  FSUIKit.m
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/4/3.
//

#import "FSUIKit.h"
#import "FSCalculator.h"

static CGRect oldframe;

@implementation FSUIKit

+ (void)alert:(UIAlertControllerStyle)style controller:(UIViewController *)pController title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(UIAlertAction *action))handler cancelTitle:(NSString *)cancelTitle cancel:(void (^)(UIAlertAction *action))cancel completion:(void (^)(void))completion {
#if DEBUG
    NSMutableArray *clears = [[NSMutableArray alloc] init];
    for (int x = 0; x < titles.count; x ++) {
        if (![clears containsObject:titles[x]]) {
            [clears addObject:titles[x]];
        }
    }
    NSAssert(clears.count == titles.count, @"有重复title");
#endif
    UIAlertController *controller = [self alertControllerWithStyle:style title:title message:message actionTitles:titles styles:styles handler:handler cancelTitle:cancelTitle cancel:cancel];
    [pController presentViewController:controller animated:YES completion:completion];
}

+ (UIAlertController *)alert:(UIAlertControllerStyle)style controller:(UIViewController *)pController title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(FSAlertAction *action))handler {
    UIAlertController *controller = [self alertControllerWithStyle:style title:title message:message actionTitles:titles styles:styles handler:handler cancelTitle:@"取消" cancel:nil];
    [pController presentViewController:controller animated:YES completion:nil];
    return controller;
}

+ (UIAlertController *)alertControllerWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(FSAlertAction *action))handler cancelTitle:(NSString *)cancelTitle cancel:(void (^)(FSAlertAction *action))cancel{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        style = UIAlertControllerStyleAlert;
    }
    
    NSInteger count = MIN(titles.count, styles.count);
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    for (int x = 0; x < count; x ++) {
        FSAlertAction *action = [FSAlertAction actionWithTitle:titles[x] style:[styles[x] integerValue] handler:^(UIAlertAction * _Nonnull action) {
            if (handler) {
                handler((FSAlertAction *)action);
            }
        }];
        action.theTag = x;
        [controller addAction:action];
    }
    if ([cancelTitle isKindOfClass:NSString.class] && cancelTitle.length) {
        FSAlertAction *archiveAction = [FSAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancel) {
                cancel((FSAlertAction *)action);
            }
        }];
        [controller addAction:archiveAction];
    }
    return controller;
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

+ (void)alertInput:(NSInteger)number controller:(UIViewController *)controller title:(NSString *)title message:(NSString *)message buttons:(NSInteger)buttons buttonConfig:(void (^)(FSAlertActionData *data))buttonConfig textFieldConifg:(void (^)(UITextField *textField))textFieldConfig completion:(void (^)(void))completion {
    if (number < 1) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: title message: message preferredStyle: UIAlertControllerStyleAlert];
    for (int x = 0; x < number; x ++) {
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            if (textFieldConfig) {
                textField.tag = x;
                textFieldConfig(textField);
            }
        }];
    }
    
    for (int x = 0; x < buttons; x ++) {
        FSAlertActionData *data = [[FSAlertActionData alloc] init];
        data.index = x;
        data.style = UIAlertActionStyleDefault;
        
        if (buttonConfig) {
            buttonConfig(data);
        }
        
        FSAlertAction *action = [FSAlertAction actionWithTitle: data.title style: data.style handler: ^(UIAlertAction * _Nonnull action) {
            FSAlertAction *act = (FSAlertAction *)action;
            if (act.data.click) {
                act.data.click(action);
            }
        }];
        action.data = data;
        [alertController addAction: action];
    }
    
    [controller presentViewController: alertController animated: YES completion: completion];
}

+ (void)showAlertWithMessage:(NSString *)message controller:(UIViewController *)controller{
    [self showAlertWithTitle:@"温馨提示" message:message ok:@"确定" controller:controller handler:nil];
}

+ (void)showAlertWithMessage:(NSString *)message controller:(UIViewController *)controller handler:(void (^)(UIAlertAction *action))handler{
    [self showAlertWithTitle:@"温馨提示" message:message ok:@"确定" controller:controller handler:handler];
}

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message ok:(NSString *)ok controller:(UIViewController *)pController handler:(void (^)(UIAlertAction *action))handler{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:ok style:UIAlertActionStyleDefault handler:handler];
    [controller addAction:action];
    [pController presentViewController:controller animated:YES completion:nil];
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

+ (void)captureScrollView:(UIScrollView *)scrollView finished:(void(^)(UIImage *image))completion{
    if (!completion) {
        return;
    }
    
    UIImage * tableViewScreenshot = [FSImage imageForUIView:scrollView];
    completion(tableViewScreenshot);
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        CGRect frame = scrollView.frame;
//          //设置控件显示的区域大小     key:显示
//        scrollView.frame = CGRectMake(0, scrollView.frame.origin.y, scrollView.contentSize.width, scrollView.contentSize.height);
//        CALayer *layer = scrollView.layer;
//        CGRect fr = scrollView.frame;
//
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            //设置截屏大小(截屏区域的大小必须要跟视图控件的大小一样)
//                UIGraphicsBeginImageContextWithOptions(fr.size, YES, 0.0);
//                [layer renderInContext:UIGraphicsGetCurrentContext()];
//                UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                scrollView.frame = frame;
//                completion(viewImage);
//            });
//        });
//    });
}

//截取view生成一张图片
+ (UIImage *)shotWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//Avilable in iOS 8.0 and later
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    return effectView;
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

+ (CGFloat)scrollViewPage:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    if (pageWidth < 0.01) {
        return 0;
    }
    CGFloat page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    int currentPage = page;
    return currentPage;
}

+ (void)findSubView:(Class)ClassOfSubView inView:(UIView *)view completion:(void(^)(id subView))completion {
    if (![view isKindOfClass:UIView.class]) {
        return;
    }
    if (!completion) {
        return;
    }
    if (!ClassOfSubView) {
        return;
    }
    for (UIView *sub in view.subviews) {
        if ([sub isKindOfClass:ClassOfSubView]) {
            completion(sub);
        }
    }
}

+ (void)setCornerRadii:(CGSize)size forView:(UIView *)view withRectCorner:(UIRectCorner)corners {
    if (![view isKindOfClass:UIView.class]) {
        return;
    }
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

@end
