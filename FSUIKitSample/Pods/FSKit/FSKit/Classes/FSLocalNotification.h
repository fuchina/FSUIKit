//
//  FSLocalNotification.h
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/2/5.
//

/*
设计目的：
1.可以在未来的某个时间点发出通知；
2.可以循环通知，即这次通知后以后还可以通知；
3.可以更改、删除；
 */

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@interface FSLocalNotification : NSObject

+ (FSLocalNotification *)sharedInstance;

- (void)allNotications:(void(^)(NSArray *list))all;

- (void)addLocalNotificationWithIdentifier:(NSString *)identifier
                                     title:(NSString *)title
                                  subTitle:(NSString *)subTitle
                                      body:(NSString *)body
                                  userInfo:(NSDictionary *)userInfo
                                      date:(NSDate *)date
                              calendarUnit:(NSCalendarUnit)unit    // 传入的是分，则每个小时的那一分都通知；即上升一个周期。多传如|，可能会混乱，未测试
                                   repeats:(BOOL)repeats
                                   success:(void(^)(NSDate *date))success
                                      fail:(void(^)(NSError *error))fail;

// 根据identifier删除通知
- (void)removeNotification:(NSArray<NSString *> *)identifiers delivered:(BOOL)delivered pending:(BOOL)pending;

+ (UNCalendarNotificationTrigger *)calendarNotificationTriggerWithDate:(NSDate *)date unit:(NSCalendarUnit)unit repeats:(BOOL)repeats NS_AVAILABLE_IOS(10_0);

+ (void)cancelAllLocalNotification;

@end
