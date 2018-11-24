//
//  FSKit.m
//  Pods
//
//  Created by fudon on 2017/6/17.
//
//

#import "FSKit.h"
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "sys/utsname.h"
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <sys/mount.h>

@implementation FSKit

NSTimeInterval _fs_timeIntevalSince1970(void){
    return [[NSDate date] timeIntervalSince1970];
}

NSInteger _fs_integerTimeIntevalSince1970(void){
    return (NSInteger)[[NSDate date] timeIntervalSince1970];
}

+ (void)pushToViewControllerWithClass:(NSString *)className navigationController:(UINavigationController *)navigationController param:(NSDictionary *)param configBlock:(void (^)(id vc))configBlockParam{
    Class Controller = NSClassFromString(className);
    if (Controller) {
        UIViewController *viewController = [[Controller alloc] init];
        //... 根据字典给属性赋值
        for (NSString *key in param) {
            SEL setSEL = [FSRuntime setterSELWithAttibuteName:key];
            if ([viewController respondsToSelector:setSEL]) {
                [viewController performSelector:setSEL onThread:[NSThread currentThread] withObject:[param objectForKey:key] waitUntilDone:YES];
            }
        }
        
        if (configBlockParam) {
            configBlockParam(viewController);
        }
        [navigationController pushViewController:viewController animated:YES];
    }
}

+ (void)presentToViewControllerWithClass:(NSString *)className controller:(UIViewController *)viewController param:(NSDictionary *)param configBlock:(void (^)(UIViewController *vc))configBlockParam presentCompletion:(void(^)(void))completion{
    Class Controller = NSClassFromString(className);
    if (Controller) {
        UIViewController *presentViewController = [[Controller alloc] init];
        //... 根据字典给属性赋值
        for (NSString *key in param) {
            SEL setSEL = [FSRuntime setterSELWithAttibuteName:key];
            if ([viewController respondsToSelector:setSEL]) {
                [viewController performSelectorOnMainThread:setSEL
                                                 withObject:[param objectForKey:key]
                                              waitUntilDone:[NSThread isMainThread]];
            }
        }
        if (configBlockParam) {
            configBlockParam(presentViewController);
        }
        [viewController presentViewController:presentViewController animated:YES completion:completion];
    }
}

+ (void)copyToPasteboard:(NSString *)copyString{
    if (![copyString isKindOfClass:NSString.class]) {
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:copyString];
}

void _fs_userDefaults_setObjectForKey(id object,NSString *key){
    if (object && _fs_isValidateString(key)) {
        NSUserDefaults *fdd = [NSUserDefaults standardUserDefaults];
        [fdd setObject:object forKey:key];
        [fdd synchronize];
    }
}

id _fs_userDefaults_objectForKey(NSString *key){
    if (_fs_isValidateString(key)) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:key];
    }
    return nil;
}

void _fs_clearUserDefaults(void){
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict = [defs dictionaryRepresentation];
    for(id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}

+ (void)letScreenLock:(BOOL)lock{
    [UIApplication sharedApplication].idleTimerDisabled = !lock;
}

+ (void)gotoAppCentPageWithAppId:(NSString *)appID{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appID]]];
}

+ (void)setStatusBarBackgroundColor:(UIColor *)color{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]){
        statusBar.backgroundColor = color;
    }
}

+ (double)usedMemory{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

+ (double)availableMemory{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

+ (NSInteger)folderSizeAtPath:(NSString *)folderPath extension:(NSString *)extension{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    NSInteger folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        if (extension) {
            if ([[fileAbsolutePath pathExtension] isEqualToString:extension]) {
                folderSize += [self fileSizeAtPath:fileAbsolutePath];
            }
        }else{
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
    }
    return folderSize;
}

+ (NSInteger)fileSizeAtPath:(NSString *)filePath{
    NSInteger size = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL exist = [manager fileExistsAtPath:filePath isDirectory:&isDir];
    // 判断路径是否存在
    if (!exist) return size;
    if (isDir) { // 是文件夹
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:filePath];
        for (NSString *subPath in enumerator) {
            NSString *fullPath = [filePath stringByAppendingPathComponent:subPath];
            NSInteger subSize = (NSInteger)[manager attributesOfItemAtPath:fullPath error:nil].fileSize;
            size += subSize;
        }
    }else{ // 是文件
        size += [manager attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    return size;
}


//磁盘总空间
+ (CGFloat)diskOfAllSizeBytes{
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemSize];
        size = [number floatValue];
    }
    return size;
}

//磁盘可用空间
+ (CGFloat)diskOfFreeSizeBytes{
    CGFloat size = 0.0;
    NSError *error;
    NSDictionary *dic = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error) {
    }else{
        NSNumber *number = [dic objectForKey:NSFileSystemFreeSize];
        size = [number floatValue];
    }
    return size;
}

//获取文件夹下所有文件的大小
+ (long long)folderSizeAtPath:(NSString *)folderPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *filesEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folerSize = 0;
    while ((fileName = [filesEnumerator nextObject]) != nil) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        folerSize += [self fileSizeAtPath:filePath];
    }
    return folerSize;
}

// 获取当前设备可用内存(单位：MB）
+ (double)availableMemoryNew{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return vm_page_size *vmStats.free_count;
}

// 获取当前任务所占用的内存（单位：MB）
+ (double)currentAppMemory{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    return taskInfo.resident_size;
}

+ (CGSize)keyboardNotificationScroll:(NSNotification *)notification baseOn:(CGFloat)baseOn{
    CGSize keyboardSize = [self keyboardSizeFromNotification:notification];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        return CGSizeMake(size.width, MAX(keyboardSize.height + baseOn, size.height));
    }else if ([notification.name isEqualToString:UIKeyboardWillHideNotification]){
        return  CGSizeMake(size.width, MAX(baseOn, size.height));
    }
    return CGSizeZero;
}

+ (CGFloat)freeStoragePercentage{
    CGFloat total = [self getTotalDiskSize];
    if (total > 1) {
        return [self getAvailableDiskSize] / total;
    }
    return 0;
}

+ (NSInteger)getTotalDiskSize{   // 获取磁盘总量
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0){
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
    }
    return (NSInteger)freeSpace;
}

+ (NSInteger)getAvailableDiskSize{   // 获取磁盘可用量
    struct statfs buf;
    unsigned long long freeSpace = -1;
    if (statfs("/var", &buf) >= 0){
        freeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
    }
    return (NSInteger)freeSpace;
}

+ (CGSize)keyboardSizeFromNotification:(NSNotification *)notification{
    if ([notification.name isEqualToString:UIKeyboardWillShowNotification] || [notification.name isEqualToString:UIKeyboardWillChangeFrameNotification] || [notification.name isEqualToString:UIKeyboardWillHideNotification]) {
        NSDictionary *info = [notification userInfo];
        NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGSize keyboardSize = [value CGRectValue].size;
        return keyboardSize;
    }
    return CGSizeZero;
}

+ (NSArray *)maxandMinNumberInArray:(NSArray *)array{
    if (array.count == 0) {
        return nil;
    }
    int i;
    double max = [array[0] doubleValue];
    double min = max;
    
    for (i = 1; i < array.count; i++)
    {
        CGFloat number = [array[i] doubleValue];
        
        if (number > max)
            max = number;
        
        if (number < min)
            min = number;
    }
    return @[@(max),@(min)];
}

+ (NSArray *)maopaoArray:(NSArray *)array{
    if (array.count == 0) {
        return nil;
    }
    
    NSMutableArray *mArray = [[NSMutableArray alloc] initWithArray:array];
    for (int x = 0; x < mArray.count - 1; x ++) {
        for (int y = 0; y < mArray.count - 1 - x; y ++) {
            double first = [mArray[y] floatValue];
            double second = [mArray[y + 1] floatValue];
            if (first > second) {
                double temp = first;
                [mArray replaceObjectAtIndex:y withObject:@(second)];
                [mArray replaceObjectAtIndex:y+1 withObject:@(temp)];
            }
        }
    }
    return mArray;
}

+ (NSArray *)addCookies:(NSArray *)nameArray value:(NSArray *)valueArray cookieDomain:(NSString *)cookName{
    if (nameArray.count != valueArray.count) {
        return nil;
    }
    NSMutableArray *cookieArray = [[NSMutableArray alloc] init];
    
    for (int x = 0; x < nameArray.count; x ++) {
        NSMutableDictionary *cookieProperties = [[NSMutableDictionary alloc] init];
        [cookieProperties setObject:nameArray[x] forKey:NSHTTPCookieName];
        [cookieProperties setObject:valueArray[x] forKey:NSHTTPCookieValue];
        [cookieProperties setObject:cookName forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:cookName forKey:NSHTTPCookieOriginURL];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
        
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [cookieArray addObject:cookie];
    }
    return cookieArray;
}

+ (NSArray *)deviceInfos{
    NSString *name = @"name";
    NSString *value = @"value";
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    UIDevice *device = [UIDevice currentDevice];
    NSDictionary *dic0 = @{name:@"我的设备",value:device.name};
    //    NSDictionary *dic1 = @{name:@"手机模型",value:device.model};
    //    NSDictionary *dic2 = @{name:@"本地模型",value:device.localizedModel};
    NSDictionary *dic3 = @{name:@"系统版本",value:[[NSString alloc] initWithFormat:@"%@%@",device.systemName,device.systemVersion]};
    NSDictionary *dic4 = @{name:@"唯一标识符",value:[[[UIDevice currentDevice] identifierForVendor] UUIDString]};
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat width = rect.size.width * scale;
    CGFloat height = rect.size.height * scale;
    NSDictionary *dic5 = @{name:@"屏幕分辨率",value:[[NSString alloc] initWithFormat:@"%@ x %@",@(width),@(height)]};
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString *mCarrier = [NSString stringWithFormat:@"%@",[carrier carrierName]];
    NSDictionary *dic6 = @{name:@"运营商",value:mCarrier};
    NSDictionary *dic7 = @{name:@"网络类型",value:[self networkTypeForType:info.currentRadioAccessTechnology]};
    NSDictionary *dic8 = @{name:@"电池信息",value:[self getBatteryState]};
    NSDictionary *dic9 = @{name:@"电量",value:@(device.batteryLevel).stringValue};
    NSDictionary *dic10 = @{name:@"iP地址",value:[self iPAddress]};
    //    NSDictionary *dic12 = @{name:@"内存",value:[self kMGTUnit:[NSProcessInfo processInfo].physicalMemory]};
    //    NSDictionary *dic13 = @{name:@"可用内存",value:[self kMGTUnit:[self getAvailableMemorySize]]};
    NSDictionary *dic14 = @{name:@"磁盘总量",value:_fs_KMGUnit([self getTotalDiskSize])};
    NSDictionary *dic15 = @{name:@"磁盘可用空间",value:_fs_KMGUnit([self getAvailableDiskSize])};
    
    [array addObject:dic0];
    //    [array addObject:dic1];
    //    [array addObject:dic2];
    [array addObject:dic3];
    [array addObject:dic4];
    [array addObject:dic5];
    [array addObject:dic6];
    [array addObject:dic7];
    [array addObject:dic8];
    [array addObject:dic9];
    [array addObject:dic10];
    //    [array addObject:dic12];
    //    [array addObject:dic13];
    [array addObject:dic14];
    [array addObject:dic15];
    return array;
}

/*
 CTRadioAccessTechnologyGPRS
 CTRadioAccessTechnologyEdge
 CTRadioAccessTechnologyWCDMA
 CTRadioAccessTechnologyHSDPA
 CTRadioAccessTechnologyHSUPA
 CTRadioAccessTechnologyCDMA1x
 CTRadioAccessTechnologyCDMAEVDORev0
 CTRadioAccessTechnologyCDMAEVDORevA
 CTRadioAccessTechnologyCDMAEVDORevB
 CTRadioAccessTechnologyeHRPD
 CTRadioAccessTechnologyLTE
 */
+ (NSString *)networkTypeForType:(NSString *)type{
    if ([type isEqualToString:CTRadioAccessTechnologyGPRS]) {
        return @"GPRS(2.5G)";
    }else if ([type isEqualToString:CTRadioAccessTechnologyEdge]){
        return @"Edge(2.75G)";
    }else if ([type isEqualToString:CTRadioAccessTechnologyWCDMA]){
        return @"WCDMA(3G)";
    }else if ([type isEqualToString:CTRadioAccessTechnologyHSDPA]){
        return @"HSDPA(3.5G)";
    }else if ([type isEqualToString:CTRadioAccessTechnologyHSUPA]){
        return @"HSUPA";
    }else if ([type isEqualToString:CTRadioAccessTechnologyCDMA1x]){
        return @"CDMA1x";
    }else if ([type isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]){
        return @"CDMAEVDORev0";
    }else if ([type isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]){
        return @"CDMAEVDORevA";
    }else if ([type isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]){
        return @"CDMAEVDORevB";
    }else if ([type isEqualToString:CTRadioAccessTechnologyeHRPD]){
        return @"HRPD";
    }else if ([type isEqualToString:CTRadioAccessTechnologyLTE]){
        return @"LTE(4G)";
    }else{
        if (type == nil) {
            return @"例外";
        }
        return type;
    }
}

+ (long long)getAvailableMemorySize{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    
    return ((vm_page_size * vmStats.free_count + vm_page_size * vmStats.inactive_count));
}

+ (NSString*)getBatteryState {
    UIDevice *device = [UIDevice currentDevice];
    if (device.batteryState == UIDeviceBatteryStateUnknown) {
        return @"未知";
    }else if (device.batteryState == UIDeviceBatteryStateUnplugged){
        return @"未充电";
    }else if (device.batteryState == UIDeviceBatteryStateCharging){
        return @"充电";
    }else if (device.batteryState == UIDeviceBatteryStateFull){
        return @"电量已满";
    }
    return nil;
}

+ (NSString *)appVersionNumber{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appBundleName{
    NSString *name = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    return name;
}

+ (NSString *)appName{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleDisplayName"];
}

UIColor *_fs_randomColor(void){
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

+ (UIColor *)colorWithHexString: (NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIFont *)angleFontWithRate:(CGFloat)rate fontSize:(NSInteger)fontSize{
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(rate * (CGFloat)M_PI / 180), 1, 0, 0);
    UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:[UIFont systemFontOfSize:fontSize].fontName matrix:matrix];
    UIFont *font = [UIFont fontWithDescriptor:desc size:fontSize];
    return font;
}

+ (NSURL *)convertTxtEncoding:(NSURL *)fileUrl{
    NSString *filePath = [fileUrl path];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        
        if ( [[manager attributesOfItemAtPath:filePath error:nil] fileSize] > 1024*1024.0f) {
            return fileUrl;
        }
    }
    
    NSString *tmpFilePath = [NSString stringWithFormat:@"%@/tmp/%@", NSHomeDirectory(), [fileUrl lastPathComponent]];
    NSURL *tmpFileUrl = [NSURL fileURLWithPath:tmpFilePath];
    NSStringEncoding encode;
    NSString *contentStr = [NSString stringWithContentsOfURL:fileUrl usedEncoding:&encode error:NULL];
    
    if (contentStr)
    {
        [contentStr writeToURL:tmpFileUrl atomically:YES encoding:NSUTF16StringEncoding error:NULL];
        return tmpFileUrl;
    }else{
        NSStringEncoding convertEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        contentStr = [NSString stringWithContentsOfURL:fileUrl encoding:convertEncoding error:NULL];
        
        if (contentStr)
        {
            [contentStr writeToURL:tmpFileUrl atomically:YES encoding:NSUTF16StringEncoding error:NULL];
            
            return tmpFileUrl;
        }
        else
        {
            return fileUrl;
        }
    }
}

+ (NSURL *)fileURLForBuggyWKWebView8:(NSURL *)fileURL{
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager= [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" load flawlesly :)
    return dstURL;
}

+ (id)storyboardInstantiateViewControllerWithStoryboardID:(NSString *)storybbordID{
    if (storybbordID == nil) {
        return nil;
    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [sb instantiateViewControllerWithIdentifier:storybbordID];
}

+ (BOOL)isNeedCompress:(NSData *)imageData{
    return imageData.length > 500 * 1024;
}

+ (BOOL)isPortait:(UIImage *)image{
    return image.size.height >= image.size.width;
}

NSString* _fs_KMGUnit(NSInteger size){
    if (size >= (1024 * 1024 * 1024)) {
        return [[NSString alloc] initWithFormat:@"%.2f G",size / (1024 * 1024 * 1024.0f)];
    }else if (size >= (1024 * 1024)){
        return [[NSString alloc] initWithFormat:@"%.2f M",size / (1024 * 1024.0f)];
    }else{
        return [[NSString alloc] initWithFormat:@"%.2f K",size / 1024.0f];
    }
}

+ (NSInteger)weekdayStringFromDate:(NSDate*)inputDate{
    NSArray *weekdays = [NSArray arrayWithObjects: @(0), @(7), @(1), @(2), @(3), @(4), @(5), @(6), nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [[weekdays objectAtIndex:theComponents.weekday] integerValue];
}

+ (NSString *)iPAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

+ (NSArray *)arrayFromArray:(NSArray *)array withString:(NSString *)string{
    if (array == nil || string == nil) {
        return nil;
    }
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:string];
    for (int x = 0; x < str.length; x ++) {
        [retArray addObject:[str substringWithRange:NSMakeRange(x, 1)]];
    }
    
    for (int x = 0; x < retArray.count; x ++) {
        for (int y = 0; y < array.count; y ++) {
            NSRange range = [array[y] rangeOfString:retArray[x]];
            if (range.location != NSNotFound) {
                if (![result containsObject:array[y]]) {
                    [result addObject:array[y]];
                }
            }
        }
    }
    return result;
}

+ (NSArray *)arrayReverseWithArray:(NSArray *)array{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSInteger x = array.count - 1; x >= 0; x --) {
        [temp addObject:array[x]];
    }
    return temp;
}

+ (NSString *)randomNumberWithDigit:(int)digit{
    NSUInteger value = arc4random();
    NSMutableString *string = [[NSMutableString alloc] initWithFormat:@"%lu",(unsigned long)value];
    NSMutableString *strLst;
    if (string.length >= digit) {
        strLst = (NSMutableString *)[string substringFromIndex:string.length - digit];
    }else{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int x = 0; x < digit - string.length; x ++) {
            NSInteger count = arc4random();
            int last = count % 10;
            NSString *str = [[NSString alloc] initWithFormat:@"%d",last];
            [array addObject:str];
        }
        [array addObject:string];
        strLst = (NSMutableString *)[array componentsJoinedByString:@""];
    }
    return strLst;
}

+ (NSArray *)arrayByOneCharFromString:(NSString *)string{
    if (string.length == 0) {
        return nil;
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int x = 0; x < string.length; x ++) {
        [array addObject:[string substringWithRange:NSMakeRange(x, 1)]];
    }
    return array;
}

+ (NSString *)blankInChars:(NSString *)string byCellNo:(int)num{
    if (string.length == 0) {
        return nil;
    }
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int x = 0; x < string.length; x ++) {
        [array addObject:[string substringWithRange:NSMakeRange(x, 1)]];
    }
    
    NSMutableArray *last = [[NSMutableArray alloc] init];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (int x = 0; x < array.count;  x++) {
        [temp addObject:array[x]];
        if (temp.count == num ) {
            [last addObject:temp];
            temp = [[NSMutableArray alloc] init];
        }
        
        if ((temp.count + last.count * num) == array.count) {
            [last addObject:temp];
        }
    }
    
    NSMutableArray *finish = [[NSMutableArray alloc] init];
    for (int x = 0; x < last.count; x ++) {
        [last[x] addObject:@" "];
        NSMutableArray *tempArr = last[x];
        for (int y = 0; y < tempArr.count; y ++) {
            [finish addObject:tempArr[y]];
        }
    }
    NSString *lastString = [finish componentsJoinedByString:@""];
    return lastString;
}

+ (NSString *)jsonStringWithObject:(id)dic{
    if ([NSJSONSerialization isValidJSONObject:dic]){
        NSError *error;
        //        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

+ (NSString *)JSONString:(NSString *)aString{
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

+ (id)objectFromJSonstring:(NSString *)jsonString{
    if (jsonString.length == 0) {
        return nil;
    }
    NSError *error;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    id dataClass = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return dataClass;
}

+ (BOOL)popToController:(NSString *)className navigationController:(UINavigationController *)navigationController animated:(BOOL)animated{
    BOOL success = NO;
    for (int x = 0; x < navigationController.viewControllers.count; x ++) {
        UIViewController *controller = navigationController.viewControllers[x];
        if ([controller isKindOfClass:NSClassFromString(className)]) {
            [navigationController popToViewController:controller animated:animated];
            return YES;
        }
    }
    return success;
}

+ (NSString *)dataToString:(NSData *)data withEncoding:(NSStringEncoding)encode{
    return [[NSString alloc] initWithData:data encoding:encode];
}

+ (NSString *)homeDirectoryPath:(NSString *)fileName{
    if (fileName.length == 0) {
        return nil;
    }
    NSString *path = NSHomeDirectory();
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (NSString *)documentsPath:(NSString *)fileName{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [array lastObject];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (NSString *)temporaryDirectoryFile:(NSString *)fileName{
    if (fileName.length == 0) {
        return nil;
    }
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSString *filePath = [tmpDirectory stringByAppendingPathComponent:fileName];
    return filePath;
}

+ (BOOL)keyedArchiverWithArray:(NSArray *)array toFilePath:(NSString *)fileName{
    if (array.count == 0 || fileName.length == 0) {
        return NO;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL success = [NSKeyedArchiver archiveRootObject:array toFile:filePath];
    if (success) {
        return YES;
    }
    return NO;
}

+ (NSArray *)keyedUnarchiverWithArray:(NSString *)fileName{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (BOOL)keyedArchiverWithData:(NSData *)data toFilePath:(NSString *)fileName{
    if (data.length == 0 || fileName.length == 0) {
        return NO;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL success = [NSKeyedArchiver archiveRootObject:data toFile:filePath];
    if (success) {
        return YES;
    }
    return NO;
}

+ (NSData *)keyedUnarchiverWithData:(NSString *)fileName{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath ];
}

+ (NSData*)rsaEncryptString:(SecKeyRef)key data:(NSString*)data{
    if (key == nil) {
        return nil;
    }
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    NSData *stringBytes = [data dataUsingEncoding:NSUTF8StringEncoding];
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([stringBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<blockCount; i++) {
        int bufferSize = (int)MIN(blockSize,[stringBytes length] - i * blockSize);
        NSData *buffer = [stringBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes],
                                        [buffer length], cipherBuffer, &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer)
                free(cipherBuffer);
            return nil;
        }
    }
    if (cipherBuffer)
        free(cipherBuffer);
    return encryptedData;
}

//压缩图片到指定文件大小
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length/1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}

+ (BOOL)keyedArchiverWithNumber:(NSNumber *)number toFilePath:(NSString *)fileName{
    if (number == nil || fileName.length == 0) {
        return NO;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL success = [NSKeyedArchiver archiveRootObject:number toFile:filePath];
    if (success) {
        return YES;
    }
    return NO;
}

+ (NSNumber *)keyedUnarchiverWithNumber:(NSString *)fileName{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:filePath ];
}

+ (BOOL)keyedArchiverWithString:(NSString *)string toFilePath:(NSString *)fileName{
    if (string.length == 0 || fileName.length == 0) {
        return NO;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL success = [NSKeyedArchiver archiveRootObject:string toFile:filePath];
    if (success) {
        return YES;
    }
    return NO;
}

+ (NSString *)keyedUnarchiverWithString:(NSString *)fileName{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath ];
}

+ (BOOL)keyedArchiverWithDictionary:(NSDictionary *)dic toFilePath:(NSString *)fileName{
    if (dic.count == 0 || fileName.length == 0) {
        return NO;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL success = [NSKeyedArchiver archiveRootObject:dic toFile:filePath];
    if (success) {
        return YES;
    }
    return NO;
}

+ (NSDictionary *)keyedUnarchiverWithDictionary:(NSString *)fileName{
    if (fileName.length == 0) {
        return nil;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    return  [NSKeyedUnarchiver unarchiveObjectWithFile:filePath ];
}

+ (BOOL)createFile:(NSString *)fileName withContent:(NSString *)string{
    if (fileName.length == 0 || string.length == 0) {
        return NO;
    }
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [arrayPath lastObject];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [fileManager createFileAtPath:filePath contents:data attributes:nil];
}

+ (BOOL)moveFile:(NSString *)filePath toPath:(NSString *)newPath{
    if (filePath.length == 0 || newPath.length == 0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager moveItemAtPath:filePath toPath:newPath error:nil];
}

+ (BOOL)renameFile:(NSString *)filePath toPath:(NSString *)newPath{
    if (filePath.length == 0 || newPath.length == 0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager moveItemAtPath:filePath toPath:newPath error:nil];
}

+ (BOOL)copyFile:(NSString *)filePath toPath:(NSString *)newPath{
    if (filePath.length == 0 || newPath.length == 0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    BOOL success = [fileManager copyItemAtPath:filePath toPath:newPath error:&error];
    return success;
}

+ (BOOL)removeFile:(NSString *)filePath{
    if (filePath.length == 0) {
        return NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (isExist) {
        return [fileManager removeItemAtPath:filePath error:nil];
    }
    return NO;
}

+ (BOOL)isChinese:(NSString *)string{
    NSString *chinese = @"^[\\u4E00-\\u9FA5\\uF900-\\uFA2D]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",chinese];
    return [phoneTest evaluateWithObject:string];
}

+ (BOOL)isValidateEmail:(NSString *)email{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length)){
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        NSRange range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        for(NSString* string in userNameArray){
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        for(NSString *string in domainArray){
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
            return NO;
        }
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isValidateUserPasswd:(NSString *)str{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[a-zA-Z0-9]{6,16}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0){
        return YES;
    }
    return NO;
}

+ (BOOL)isChar:(NSString *)str{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[a-zA-Z]*$"    //^[0-9]*$
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0){
        return YES;
    }
    return NO;
}

+ (BOOL)isNumber:(NSString *)str{
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[0-9]*$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    if(numberofMatch > 0){
        return YES;
    }
    return NO;
}

+ (BOOL)isString:(NSString *)aString containString:(NSString *)bString{
    for (int x = 0; x < aString.length; x ++) {
        NSRange range = NSMakeRange(x,1);
        NSString *subString = [aString substringWithRange:range];
        if ([subString isEqualToString:bString]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isStringContainsStringAndNumber:(NSString *)sourceString{
    if ([sourceString isKindOfClass:NSString.class]) {
        if (sourceString.length == 0) {
            return NO;
        }
        BOOL containsNumber = NO;
        BOOL containsChar = NO;
        for (int x = 0; x < sourceString.length; x ++) {
            NSString *componentString = [sourceString substringWithRange:NSMakeRange(x, 1)];
            if (_fs_isPureInt(componentString)) {
                containsNumber = YES;
            }else{
                containsChar = YES;
            }
        }
        return containsChar&&containsNumber;
    }else{
        return NO;
    }
    return NO;
}

+ (BOOL)isURLString:(NSString *)sourceString{
    NSString *matchString = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",matchString];
    return [phoneTest evaluateWithObject:sourceString];
}

+ (BOOL)isHaveChineseInString:(NSString *)string{
    for(NSInteger i = 0; i < [string length]; i++){
        int a = [string characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isAllNum:(NSString *)string{
    unichar c;
    for (int i=0; i<string.length; i++) {
        c=[string characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)isValidateString:(NSString *)string{
    return [string isKindOfClass:NSString.class] && string.length;
}

BOOL _fs_isPureInt(NSString *string){
    if (![string isKindOfClass:NSString.class]) {
        string = [string description];
    }
    if (string.length == 0) {
        return NO;
    }
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

BOOL _fs_isPureFloat(NSString *string){
    if (![string isKindOfClass:NSString.class]) {
        string = [string description];
    }
    if (string.length == 0) {
        return NO;
    }
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

BOOL _fs_isValidateString(NSString *string){
    return [string isKindOfClass:NSString.class] && string.length;
}

BOOL _fs_isValidateArray(NSArray *array){
    return [array isKindOfClass:NSArray.class] && array.count;
}

BOOL _fs_isValidateDictionary(NSDictionary *dictionary){
    return [dictionary isKindOfClass:NSDictionary.class] && dictionary.count;
}

BOOL _fs_floatEqual(CGFloat aNumber,CGFloat bNumber){
    NSNumber *a=[NSNumber numberWithFloat:aNumber];
    NSNumber *b=[NSNumber numberWithFloat:bNumber];
    return [a compare:b] == NSOrderedSame;
}

+ (BOOL)isChineseEnvironment{
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    return [languageName isEqualToString:@"zh-Hans-CN"];
}



+ (NSNumber *)fileSize:(NSString *)filePath{
    if (filePath.length == 0) {
        return nil;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attrDic = [fileManager attributesOfItemAtPath:filePath error:nil];
    NSNumber *fileSize = [attrDic objectForKey:NSFileSize];
    return fileSize;
}

NSString *_fs_md5(NSString *str){
    if (![str isKindOfClass:NSString.class]) {
        return nil;
    }
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr),result);
    return [NSString  stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4],
            result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12],
            result[13], result[14], result[15]
            ];
}

+ (NSString *)stringDeleteNewLineAndWhiteSpace:(NSString *)string{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)macaddress{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return outstring;
}

+ (NSString *)identifierForVendorFromKeyChain{
    NSString *identifierStr = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString * const KEY_USERNAME_PASSWORD = @"com.fuhope.myapp";
    NSString * const KEY_PASSWORD = @"com.fuhope.myapp";
    
    NSMutableDictionary *readUserPwd = (NSMutableDictionary *)[self load:KEY_USERNAME_PASSWORD];
    if (!readUserPwd) {
        NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
        [usernamepasswordKVPairs setObject:identifierStr forKey:KEY_PASSWORD];
        [self save:KEY_USERNAME_PASSWORD data:usernamepasswordKVPairs];
        return identifierStr;
    }else{
        return [readUserPwd objectForKey:KEY_PASSWORD];
    }
}

+ (NSString *)asciiCodeWithString:(NSString *)string{
    NSMutableString *str = [[NSMutableString alloc] init];
    for (int x = 0; x < string.length; x ++) {
        NSString *aStr = [string substringWithRange:NSMakeRange(x, 1)];
        [str appendFormat:@"%d",[aStr characterAtIndex:0]];
    }
    return str;
}

+ (NSString *)stringFromASCIIString:(NSString *)string{
    unsigned short asciiCode = [string intValue];
    return [[NSString alloc] initWithFormat:@"%C",asciiCode];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

//取
+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

+ (NSString *)DataToHex:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    NSMutableDictionary  *temp = [[NSMutableDictionary alloc] init];
    [temp setObject:@"" forKey:@"value"];
    
    for(int i=0;i<[data length];i++){
        NSString *hexStr = @"";
        NSString *newHexStr = [[NSString alloc] initWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length] == 1){
            hexStr = [[NSString alloc] initWithFormat:@"%@0%@",[temp objectForKey:@"value"],newHexStr];
            [temp setObject:hexStr forKey:@"value"];
            //            [hexStr release];    //  注释被保留的原因是在非ARC模式下，会内存泄漏；如果alloc时采用autorelese，数据量大时会导致崩溃
        }else{
            hexStr = [[NSString alloc] initWithFormat:@"%@%@",[temp objectForKey:@"value"],newHexStr];
            [temp setObject:hexStr forKey:@"value"];
            //            [hexStr release];
        }
        //        [newHexStr release];
    }
    //JLog(@"bytes 的16进制数为:%@",hexStr);
    return [temp objectForKey:@"value"];
}

+ (NSString *)cleanString:(NSString *)str{
    if (str == nil) {
        return @"";
    }
    NSMutableString *cleanString = [NSMutableString stringWithString:str];
    [cleanString replaceOccurrencesOfString:@"\n" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    [cleanString replaceOccurrencesOfString:@"\r" withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    [cleanString replaceOccurrencesOfString:@" " withString:@""
                                    options:NSCaseInsensitiveSearch
                                      range:NSMakeRange(0, [cleanString length])];
    return cleanString;
}

+ (NSString *)stringByDate:(NSDate *)date{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString *string = [[NSString alloc] initWithFormat:@"%@",localeDate];
    return string;
}

+ (NSString *)bankStyleDataThree:(id)data{
    if ([data isKindOfClass:NSNumber.class]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@"###,##0.00;"];    // 100,000.00
        NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[data doubleValue]]];
        return formattedNumberString;
    }else if([data isKindOfClass:NSString.class]){
        if (_fs_isPureFloat(data) || _fs_isPureInt(data)) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setPositiveFormat:@"###,##0.00;"];    // 100,000.00
            NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[data doubleValue]]];
            return formattedNumberString;
        }else{
            return @"0.00";
        }
    }else{
        return @"0.00";
    }
}

+ (NSString *)bankStyleData:(id)data{
    if ([data isKindOfClass:NSNumber.class]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        //        [numberFormatter setPositiveFormat:@"###,##0.00;"];    // 100,000.00
        [numberFormatter setPositiveFormat:@"0.00;"];
        NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[data doubleValue]]];
        return formattedNumberString;
    }else if([data isKindOfClass:NSString.class]){
        if (_fs_isPureFloat(data) || _fs_isPureInt(data)) {
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setPositiveFormat:@"0.00;"];
            NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[data doubleValue]]];
            return formattedNumberString;
        }else{
            return @"0.00";
        }
    }else{
        return @"0.00";
    }
}

+ (NSString *)fourNoFiveYes:(float)number afterPoint:(int)position{  // 只入不舍
    NSDecimalNumberHandler  *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

+ (double)forwardValue:(double)number afterPoint:(int)position{  // 只入不舍
    NSNumber *classNumber = [NSNumber numberWithDouble:number];
    NSString *classString = [classNumber stringValue];
    
    NSArray *valueArray = [classString componentsSeparatedByString:@"."];
    if (valueArray.count == 2) {
        NSString *pointString = valueArray[1];
        if (pointString.length <= position) {
            return number;
        }
    }
    
    NSDecimalNumberHandler  *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [roundedOunces doubleValue];
}

+ (NSString *)decimalNumberMutiplyWithString:(NSString *)multiplierValue  valueB:(NSString *)multiplicandValue{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:multiplierValue];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:multiplicandValue];
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber];
    return [product stringValue];
}

+ (NSString *)base64StringForText:(NSString *)text{
    if (text && [text isKindOfClass:NSString.class]) {
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }else{
        return nil;
    }
}

+ (NSString *)textFromBase64String:(NSString *)text{
    if (text == nil) {
        return nil;
    }
    NSData *data = [[NSData alloc] initWithBase64EncodedString:text options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)base64Code:(NSData *)data{
    return [data base64EncodedStringWithOptions:0];
}

+ (NSString *)sessionID:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSDictionary *dic = httpResponse.allHeaderFields;
    NSString *sessionid = [dic objectForKey:@"Set-Cookie"];
    NSString *subSession = @"";
    if (sessionid) {
        NSArray *array = [sessionid componentsSeparatedByString:@";"];
        NSString *session = array[0];
        subSession = [session componentsSeparatedByString:@"="][1];
    }
    return subSession;
}

+ (NSString *)ymdhsByTimeInterval:(NSTimeInterval)fTI{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:fTI];
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeZone* localzone = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:localzone];
    }
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)ymdhsByTimeIntervalString:(NSString *)timeInterval{
    return [self ymdhsByTimeInterval:[timeInterval doubleValue]];
}

+ (NSString *)countOverTime:(NSTimeInterval)time{
    NSInteger seconds = time;
    NSMutableString *overdueTimeString = [[NSMutableString alloc] init];
    NSInteger day = seconds/(60*60*24);
    if (day > 0) {
        [overdueTimeString appendFormat:@"%ld天",(long)day];
    }
    NSInteger hour = (seconds - day*60*60*24)/3600.0;
    if (hour > 0) {
        [overdueTimeString appendFormat:@"%ld小时",(long)hour];
    }
    NSInteger minute = (seconds - day*60*60*24 - hour*3600)/60.0;
    if (minute > 0) {
        [overdueTimeString appendFormat:@"%ld分钟",(long)minute];
    }
    return overdueTimeString;
}

+ (NSString *)pinyinForHans:(NSString *)string{
    NSMutableString *preString = (NSMutableString *)[self pinyinForHansSimple:string];
    /*多音字处理*/
    if ([[(NSString *)string substringToIndex:1] compare:@"长"] == NSOrderedSame){
        [preString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    
    if ([[(NSString *)string substringToIndex:1] compare:@"沈"] == NSOrderedSame){
        [preString replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"厦"] == NSOrderedSame){
        [preString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"地"] == NSOrderedSame){
        [preString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"di"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"重"] == NSOrderedSame){
        [preString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    return preString;
}

+ (NSString *)pinyinForHansSimple:(NSString *)chinese{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

+ (NSString *)convertNumbers:(NSString *)string{
    if (![self isValidateString:string]) {
        return nil;
    }
    NSArray *numbers = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSArray *array = @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
    NSMutableString *name = [[NSMutableString alloc] init];
    for (int x = 0; x < string.length; x ++) {
        NSString *sub = [string substringWithRange:NSMakeRange(x, 1)];
        if ([numbers containsObject:sub]) {
            NSInteger index = [numbers indexOfObject:sub];
            if ((index != NSNotFound) && array.count > index) {
                [name appendString:array[index]];
            }else{
                [name appendString:sub];
            }
        }
    }
    return [self pinyinForHansClear:name];
}

+ (NSString *)pinyinForHansClear:(NSString *)chinese{        // 获取汉字的拼音，没有空格
    NSString *pinyin = [self pinyinForHans:chinese];
    return [self cleanString:pinyin];
}

+ (NSString*)reverseWordsInString:(NSString*)str{
    NSMutableString *reverString = [NSMutableString stringWithCapacity:str.length];
    [str enumerateSubstringsInRange:NSMakeRange(0, str.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences  usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reverString appendString:substring];
    }];
    return reverString;
}

+ (NSString *)twoChar:(NSInteger)value{
    if (value < 10) {
        return [[NSString alloc] initWithFormat:@"0%@",@(value)];
    }
    return [[NSString alloc] initWithFormat:@"%@",@(value)];
}

+ (NSString *)scanQRCode:(UIImage *)image{
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    
    NSString *result = nil;
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        result = feature.messageString;
        if ([result isKindOfClass:NSString.class]) {
            break;
        }
    }
    return result;
}

+ (NSString *)dataToHex:(NSData *)data{
    if (!data || [data length] == 0) {
        return nil;
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}

+ (NSData *)convertHexStrToData:(NSString *)str{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

+ (NSAttributedString *)attributedStringFor:(NSString *)sourceString colorRange:(NSArray *)colorRanges color:(UIColor *)color textRange:(NSArray *)textRanges font:(UIFont *)font{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:sourceString];
    for (int x = 0; x < colorRanges.count; x ++) {
        NSValue *value = colorRanges[x];
        NSRange range;
        [value getValue:&range];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    
    for (int x = 0; x < textRanges.count; x ++) {
        NSValue *value = textRanges[x];
        NSRange range;
        [value getValue:&range];
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    return attributedStr;
}

+ (NSAttributedString *)attributedStringFor:(NSString *)sourceString strings:(NSArray *)colorStrings color:(UIColor *)color fontStrings:(NSArray * __nullable)fontStrings font:(UIFont * __nullable)font{
    NSMutableArray *colorRangs = [[NSMutableArray alloc] initWithCapacity:colorStrings.count];
    NSMutableArray *textRangs = [[NSMutableArray alloc] initWithCapacity:fontStrings.count];
    for (NSString *colorStr in colorStrings) {
        NSRange range = [sourceString rangeOfString:colorStr];
        if (range.location != NSNotFound) {
            [colorRangs addObject:[NSValue valueWithRange:range]];
        }
    }
    for (NSString *fontStr in fontStrings) {
        NSRange range = [sourceString rangeOfString:fontStr];
        if (range.location != NSNotFound) {
            [textRangs addObject:[NSValue valueWithRange:range]];
        }
    }
    return [self attributedStringFor:sourceString colorRange:colorRangs color:color textRange:textRangs font:font];
}

- (NSAttributedString *)middleLineForLabel:(NSString *)text{
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attribtDic];
    return attribtStr;
}

- (NSAttributedString *)underLineForLabel:(NSString *)text{
    // 下划线
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attribtDic];
    return attribtStr;
}

//获取字符串(或汉字)首字母
+ (NSString *)firstCharacterWithString:(NSString *)string{
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pingyin = [str capitalizedString];
    return [pingyin substringToIndex:1];
}

// 银行卡每4个隔空格
+ (NSString *)forthCarNumber:(NSString *)text{
    if (![text isKindOfClass:NSString.class]) {
        text = text.description;
    }
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![self isValidateString:text]) {
        return nil;
    }
    
    NSMutableArray *value = [[NSMutableArray alloc] init];
    NSInteger length = text.length;
    NSInteger numbers = length / 4;
    NSInteger rest = length % 4;
    for (int x = 0; x < numbers; x ++) {
        NSString *subStr = [text substringWithRange:NSMakeRange(x * 4, 4)];
        [value addObject:subStr];
    }
    if (rest) {
        NSString *last = [text substringWithRange:NSMakeRange(length - rest, rest)];
        [value addObject:last];
    }
    return [value componentsJoinedByString:@" "];
}

+ (void)call:(NSString *)phone{
    if (phone != nil) {
        NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",phone];
        NSURL *url = [[NSURL alloc] initWithString:telUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (void)callPhoneWithNoNotice:(NSString *)phone{
    if (phone == nil) {
        return;
    }
    NSString *str=[[NSString alloc] initWithFormat:@"tel:%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (NSString *)deviceModel{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air_5_wifi";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air_5_cell";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air_5_cell";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad mini_wifi";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad mini_cell";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air2";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    if ([deviceString isEqualToString:@"i386"])         return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"iPhone Simulator";
    
    return deviceString;
}

+ (NSString *)easySeeTimesBySeconds:(NSInteger)timeInterVal{
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInterVal];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    NSInteger year = dateComponents.year - 1970;
    NSInteger month = dateComponents.month - 1;
    NSInteger day = dateComponents.day - 1;
    NSInteger hour = dateComponents.hour - 8;
    NSInteger minute = dateComponents.minute;
    NSInteger second = dateComponents.second;
    if (hour < 0) {
        hour += 24;
        day --;
    }
    NSMutableString *valueString = [[NSMutableString alloc] init];
    if (year > 0) {
        [valueString appendString:[[NSString alloc] initWithFormat:@"%@年",@(year)]];
    }
    if (month > 0) {
        [valueString appendString:[[NSString alloc] initWithFormat:@"%@月",@(month)]];
    }
    if (day > 0) {
        [valueString appendString:[[NSString alloc] initWithFormat:@"%@天",@(day)]];
    }
    [valueString appendString:[[NSString alloc] initWithFormat:@"%@时",@(hour)]];
    [valueString appendString:[[NSString alloc] initWithFormat:@"%@分",@(minute)]];
    [valueString appendString:[[NSString alloc] initWithFormat:@"%@秒",@(second)]];
    return valueString;
}

+ (NSString *)tenThousandNumber:(double)value{
    if (value <= 100000) {
        return [[NSString alloc] initWithFormat:@"%.2f",value];
    }
    return [[NSString alloc] initWithFormat:@"%.2f万",value / 10000];
}

+ (NSString *)tenThousandNumberString:(NSString *)value{
    double number = [value doubleValue];
    if (number <= 100000) {
        return value;
    }
    return [[NSString alloc] initWithFormat:@"%.2f万",number / 10000];
}

+ (NSString *)urlEncodedString:(NSString *)urlString{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)urlString,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
}

+ (NSString *)urlDecodedString:(NSString *)urlString{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)urlString,CFSTR(""),kCFStringEncodingUTF8));
}

+ (void)openAppByURLString:(NSString *)str{
    NSString *string = [NSString stringWithFormat:@"%@://://",str];
    NSURL *myURL_APP_A = [NSURL URLWithString:string];
    if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        [[UIApplication sharedApplication] openURL:myURL_APP_A];
    }
}

void _fs_spendTimeInDoSomething(void(^body)(void),void(^time)(double time)){
    NSTimeInterval t = _fs_timeIntevalSince1970();
    if (body) {
        body();
    }
    t = _fs_timeIntevalSince1970() - t;
    if (time) {
        time(t);
    }
}

void _fs_userDefaultsOnce(NSString *key,void (^event)(void)){
    if (!_fs_isValidateString(key)) {
        return;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    id object = [ud objectForKey:key];
    if (!object) {
        if (event) {
            event();
        }
        [ud setObject:@(1) forKey:key];
        [ud synchronize];
    }
}

void _fs_dispatch_global_main_queue_async(dispatch_block_t _global_block,dispatch_block_t _main_block){
    if (_global_block) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            _global_block();

            if (_main_block) {
                dispatch_async(dispatch_get_main_queue(), _main_block);
            }
        });
    }
}

void _fs_dispatch_main_queue_async(dispatch_block_t _main_block){
    if ([NSThread isMainThread]) {
        _main_block();
    } else {
        dispatch_async(dispatch_get_main_queue(), _main_block);
    }
}

void _fs_dispatch_main_queue_sync(dispatch_block_t _main_block){
    if ([NSThread isMainThread]) {
        _main_block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), _main_block);
    }
}

void _fs_dispatch_global_queue_async(dispatch_block_t _global_block){
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), _global_block);
}

void _fs_dispatch_global_queue_sync(dispatch_block_t _global_block){
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), _global_block);
}

/*
 kCFRunLoopEntry = (1UL << 0),        即将进入runloop
 kCFRunLoopBeforeTimers = (1UL << 1), 即将处理timer事件
 kCFRunLoopBeforeSources = (1UL << 2),即将处理source事件
 kCFRunLoopBeforeWaiting = (1UL << 5),即将进入睡眠
 kCFRunLoopAfterWaiting = (1UL << 6), 被唤醒
 kCFRunLoopExit = (1UL << 7),         runloop退出
 kCFRunLoopAllActivities = 0x0FFFFFFFU
 */
void _fs_runloop_observer(void){
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"即将进入runloop");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理timer事件");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理source事件");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将进入睡眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"被唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"runloop退出");
                break;
                
            default:
                break;
        }
    });
    
    CFRunLoopRef rl = CFRunLoopGetCurrent();
    if (observer) {
        CFRunLoopAddObserver(rl,observer, kCFRunLoopDefaultMode);
        CFRelease(observer);
//        CFRunLoopObserverInvalidate(observer);//使Observer无效
//        CFRunLoopRemoveObserver(rl, observer, kCFRunLoopDefaultMode);// 移除Observer
    }
}

void _fs_runloop_freeTime_event(void(^event)(void)){
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopBeforeWaiting:
            case kCFRunLoopExit:{
                if (event) {
                    event();
                }
            }break;
            default:break;
        }
    });
    
    CFRunLoopRef rl = CFRunLoopGetCurrent();
    if (observer) {
        CFRunLoopAddObserver(rl,observer, kCFRunLoopDefaultMode);
        CFRelease(observer);
    }
}

NSString *_fs_highAccuracy_add(NSString *a,NSString *b){
    if (!_fs_isPureFloat(a)) {
        a = @"0";
    }
    if (!_fs_isPureFloat(b)) {
        b = @"0";
    }
    NSDecimalNumber *addendNumber = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *augendNumber = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *sumNumber = [addendNumber decimalNumberByAdding:augendNumber];
    return [sumNumber stringValue];
}

NSString *_fs_highAccuracy_subtract(NSString *a,NSString *b){
    if (!_fs_isPureFloat(a)) {
        a = @"0";
    }
    if (!_fs_isPureFloat(b)) {
        b = @"0";
    }
    NSDecimalNumber *addendNumber = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *augendNumber = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *sumNumber = [addendNumber decimalNumberBySubtracting:augendNumber];
    return [sumNumber stringValue];
}

NSString *_fs_highAccuracy_multiply(NSString *a,NSString *b){
    if (!_fs_isPureFloat(a)) {
        a = @"0";
    }
    if (!_fs_isPureFloat(b)) {
        b = @"0";
    }
    NSDecimalNumber *addendNumber = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *augendNumber = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *sumNumber = [addendNumber decimalNumberByMultiplyingBy:augendNumber];
    return [sumNumber stringValue];
}

NSString *_fs_highAccuracy_divide(NSString *a,NSString *b){
    if (!_fs_isPureFloat(a)) {
        a = @"0";
    }
    if (!_fs_isPureFloat(b)) {
        b = @"0";
    }
    NSDecimalNumber *addendNumber = [NSDecimalNumber decimalNumberWithString:a];
    NSDecimalNumber *augendNumber = [NSDecimalNumber decimalNumberWithString:b];
    NSDecimalNumber *sumNumber = [addendNumber decimalNumberByDividingBy:augendNumber];
    return [sumNumber stringValue];
}

@end


