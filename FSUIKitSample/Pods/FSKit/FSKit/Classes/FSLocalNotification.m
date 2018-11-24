//
//  FSLocalNotification.m
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/2/5.
//

#import "FSLocalNotification.h"

@interface FSLocalNotification()<UNUserNotificationCenterDelegate>

@end

@implementation FSLocalNotification

static FSLocalNotification *_instance = nil;
+ (FSLocalNotification *)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FSLocalNotification alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self preparatoryWork];
    }
    return self;
}

- (void)preparatoryWork{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {

                              }];
//        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//            NSLog(@"settings:%@",settings);
//        }];
    }
}

- (void)removeNotification:(NSArray<NSString *> *)identifiers delivered:(BOOL)delivered pending:(BOOL)pending{
    if (@available(iOS 10.0, *)) {
        if ((delivered || pending)) {
            BOOL validateArray = [identifiers isKindOfClass:NSArray.class] && identifiers;
            if (validateArray) {
                BOOL allString = YES;
                Class _Class_String = NSString.class;
                for (NSString *str in identifiers) {
                    if (![str isKindOfClass:_Class_String]) {
                        allString = NO;
                        return;
                    }
                }
                if (allString) {
                    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                    if (delivered) {
                        [center removeDeliveredNotificationsWithIdentifiers:identifiers];
                    }
                    if (pending) {
                        [center removePendingNotificationRequestsWithIdentifiers:identifiers];
                    }
                }
            }
        }
    }
}

- (void)allNotications:(void(^)(NSArray *list))all{
    if (all) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [center getDeliveredNotificationsWithCompletionHandler:^(NSArray<UNNotification *> * _Nonnull notifications) {
                [list addObjectsFromArray:notifications];
                
                [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
                    [list addObjectsFromArray:requests];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        all(list);
                    });
                }];
            }];
        }else{
            NSInteger i = 2;
            NSAssert(i == 1, @"待实现");
        }
    }
}

- (void)addLocalNotificationWithIdentifier:(NSString *)identifier title:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body userInfo:(NSDictionary *)userInfo date:(NSDate *)date calendarUnit:(NSCalendarUnit)unit repeats:(BOOL)repeats success:(void(^)(NSDate *date))success fail:(void(^)(NSError *error))fail{
    Class StringClass = NSString.class;
    if (!([identifier isKindOfClass:StringClass] && identifier.length)) {
        NSAssert(identifier, @"LocalNotification's identifier has no length");
        return;
    }
    if (![date isKindOfClass:NSDate.class]) {
        return;
    }
    if (@available(iOS 10.0,*)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if ([title isKindOfClass:StringClass] && title.length) {
            content.title = title;
        }
        if ([subTitle isKindOfClass:StringClass] && subTitle.length) {
            content.subtitle = subTitle;
        }
        if ([body isKindOfClass:StringClass] && body.length) {
            content.body = body;
        }
        if ([userInfo isKindOfClass:NSDictionary.class] && userInfo.count) {
            content.userInfo = userInfo;
        }
        content.sound = [UNNotificationSound defaultSound];
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        content.badge = @(badge);
        
        UNCalendarNotificationTrigger *trigger = [FSLocalNotification calendarNotificationTriggerWithDate:date unit:unit repeats:repeats];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error && fail) {
                    fail(error);
                }else if (success){
                    success(trigger.nextTriggerDate);
                }
            });
        }];
    }
}

+ (UNCalendarNotificationTrigger *)calendarNotificationTriggerWithDate:(NSDate *)date unit:(NSCalendarUnit)unit repeats:(BOOL)repeats NS_AVAILABLE_IOS(10_0){
    if (@available(iOS 10,*)) {
        NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [calendar components:unit fromDate:date];
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:comps repeats:repeats];
        return trigger;
    }
    return nil;
}

- (void)addLocalNotificationWithIdentifier:(NSString *)identifier title:(NSString *)title subTitle:(NSString *)subTitle body:(NSString *)body success:(void(^)(void))success fail:(void(^)(NSError *error))fail{
    Class StringClass = NSString.class;
    if (!([identifier isKindOfClass:StringClass] && identifier.length)) {
        NSAssert(identifier, @"LocalNotification's identifier has no length");
        return;
    }
    if (@available(iOS 10.0,*)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if ([title isKindOfClass:StringClass] && title.length) {
            content.title = title;
        }
        if ([subTitle isKindOfClass:StringClass] && subTitle.length) {
            content.subtitle = subTitle;
        }
        if ([body isKindOfClass:StringClass] && body.length) {
            content.body = body;
        }
        content.sound = [UNNotificationSound defaultSound];
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
        content.badge = @(badge);
        
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error && fail) {
                    fail(error);
                }else if (success){
                    success();
                }
            });
        }];
    }
}

+ (void)cancelAllLocalNotification{
    if (@available(iOS 10,*)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeAllDeliveredNotifications];
        [center removeAllPendingNotificationRequests];
    }else{
        [[UIApplication sharedApplication] cancelAllLocalNotifications];        
    }
}

#pragma mark IOS10
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler NS_AVAILABLE_IOS(10_0){
    UIApplication *app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber += app.applicationIconBadgeNumber + 1;
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:UNPushNotificationTrigger.class]) {
        
    } else {
        NSLog(@"iOS10 前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
//        [self.dataArray addObject:content];
//        [self.timeArray addObject:[self convertNSDateToNSString:[NSDate date]]];
//        [self.tableView reloadData];
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler NS_AVAILABLE_IOS(10_0){
    
}

@end
