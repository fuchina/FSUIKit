//
//  FSDate.h
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/4/3.
//

#import <Foundation/Foundation.h>

@interface FSDate : NSObject

// 该月第一秒/最后一秒
+ (NSInteger)theFirstSecondOfMonth:(NSDate *)date;
+ (NSInteger)theLastSecondOfMonth:(NSDate *)date;
// 该天第一秒/最后一秒
+ (NSInteger)theFirstSecondOfDay:(NSDate *)date;
+ (NSInteger)theLastSecondOfDay:(NSDate *)date;

// 该年第一秒/最后一秒
+ (NSInteger)theFirstSecondOfYear:(NSInteger)year;
+ (NSInteger)theLastSecondOfYear:(NSInteger)year;

// 解决差8小时问题
+ (NSDate *)chinaDateByDate:(NSDate *)date;

// 获取日期是当年的第几天
+ (NSInteger)daythOfYearForDate:(NSDate *)date;

// 是否为闰年
+ (BOOL)isLeapYear:(int)year;

// 根据年月计算当月有多少天
+ (NSInteger)daysForMonth:(NSInteger)month year:(NSInteger)year;

+ (NSDateComponents *)componentForDate:(NSDate *)date;

+ (NSDate *)dateByString:(NSString *)str formatter:(NSString *)formatter;

+ (NSString *)stringWithDate:(NSDate *)date formatter:(NSString *)formatter;

// 除了年不是当年数字，月日是当月日
+ (NSDateComponents *)chineseDate:(NSDate *)date;

// 获取农历日期，数组共三个元素，分别是农历的年月日
+ (NSArray<NSString *> *)chineseCalendarForDate:(NSDate *)date;

/**
 *  计算上次日期距离现在多久
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param format1     上次日期格式
 *  @param currentTime 最近日期(需要和格式对应)
 *  @param format2     最近日期格式
 *
 *  @return xx分钟前、xx小时前、xx天前
 *  eg. NSLog(@"\n\nresult: %@", [Utilities timeIntervalFromLastTime:@"2015年12月8日 15:50"
 lastTimeFormat:@"yyyy年MM月dd日 HH:mm"
 ToCurrentTime:@"2015/12/08 16:12"
 currentTimeFormat:@"yyyy/MM/dd HH:mm"]);
 */
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1
                         ToCurrentTime:(NSString *)currentTime
                     currentTimeFormat:(NSString *)format2;

// 同一天
+ (BOOL)isTheSameDayA:(NSDate *)aDate b:(NSDate *)bDate;

@end
