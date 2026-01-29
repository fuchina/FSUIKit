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

+ (UIAlertController *)alert:(UIAlertControllerStyle)style controller:(UIViewController *)pController title:(NSString *)title message:(NSString *)message actionTitles:(NSArray<NSString *> *)titles styles:(NSArray<NSNumber *> *)styles handler:(void (^)(UIAlertAction *action))handler cancelTitle:(NSString *)cancelTitle cancel:(void (^)(UIAlertAction *action))cancel completion:(void (^)(void))completion {
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
    [pController presentViewController: controller animated:YES completion: completion];
    return controller;
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

+ (UIAlertController *)alertInput:(NSInteger)number controller:(UIViewController *)controller title:(NSString *)title message:(NSString *)message buttons:(NSInteger)buttons buttonConfig:(void (^)(FSAlertActionData *data))buttonConfig textFieldConifg:(void (^)(UITextField *textField))textFieldConfig completion:(void (^)(UIAlertController *alert))completion {
    if (number < 1) {
        return nil;
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
    
    __weak typeof(alertController)wAlertController = alertController;
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
                act.data.click(wAlertController, action);
            }
        }];
        action.data = data;
        [alertController addAction: action];
    }
    
    [controller presentViewController: alertController animated: YES completion:^{
        if (completion) {
            completion(alertController);
        }
    }];
    return alertController;
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

@end
