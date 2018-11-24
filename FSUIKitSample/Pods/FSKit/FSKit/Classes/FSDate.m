//
//  FSDate.m
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/4/3.
//

#import "FSDate.h"

@implementation FSDate

+ (NSDate *)chinaDateByDate:(NSDate *)date{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval: interval];
}

+ (NSInteger)daythOfYearForDate:(NSDate *)date{
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateComponents *component = [self componentForDate:date];
    NSInteger year = component.year;
    NSInteger month = component.month;
    NSInteger day = component.day;
    int a[12]={31,28,31,30,31,30,31,31,30,31,30,31};
    int b[12]={31,29,31,30,31,30,31,31,30,31,30,31};
    int i,sum=0;
    if([self isLeapYear:(int)year])
        for(i=0;i<month-1;i++)
            sum+=b[i];
    else
        for(i=0;i<month-1;i++)
            sum+=a[i];
    sum+=day;
    return sum;
}

+ (BOOL)isLeapYear:(int)year{
    if ((year % 4  == 0 && year % 100 != 0)  || year % 400 == 0)
        return YES;
    else
        return NO;
}

+ (NSInteger)daysForMonth:(NSInteger)month year:(NSInteger)year{
    NSInteger days = 0;
    BOOL isLeapYear = [self isLeapYear:(int)year];
    BOOL isBigMonth = NO;
    if (month <=7) {
        if (month % 2 == 1) {
            isBigMonth = YES;
        }
    }else{
        if (month % 2 == 0) {
            isBigMonth = YES;
        }
    }
    
    if (isLeapYear) {
        if (month == 2) {
            days = 29;
        }else if (isBigMonth){
            days = 31;
        }else{
            days = 30;
        }
    }else{
        if (month == 2) {
            days = 28;
        }else if (isBigMonth){
            days = 31;
        }else{
            days = 30;
        }
    }
    return days;
}

+ (NSDateComponents *)componentForDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:date];
    return components;
}

+ (NSDate *)dateByString:(NSString *)str formatter:(NSString *)formatter{
    if (!([str isKindOfClass:NSString.class] && str.length)) {
        return nil;
    }
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:formatter?:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:str];
    return date;
}

+ (NSString *)stringWithDate:(NSDate *)date formatter:(NSString *)formatter{
    if (![date isKindOfClass:NSDate.class]) {
        return nil;
    }
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:formatter?:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

+ (NSDateComponents *)chineseDate:(NSDate *)date{
    if (![date isKindOfClass:NSDate.class]) {
        return nil;
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    return components;
}

+ (NSArray<NSString *> *)chineseCalendarForDate:(NSDate *)date{
    if (![date isKindOfClass:NSDate.class]) {
        return nil;
    }
    NSDateComponents *components = [self chineseDate:date];
    return @[[self chineseCalendarYear:components.year - 1],[self chineseCalendarMonth:components.month - 1],[self chineseCalendarDay:components.day - 1]];
}

+ (NSString *)chineseCalendarYear:(NSInteger)index{
    NSArray *chineseYears = @[@"甲子",  @"乙丑",  @"丙寅",  @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                              @"甲戌",   @"乙亥",  @"丙子",  @"丁丑",  @"戊寅",  @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                              @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                              @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                              @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                              @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥"];
    return chineseYears[index % chineseYears.count];
}

+ (NSString *)chineseCalendarMonth:(NSInteger)index{
    NSArray *chineseYears = @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"];
    return chineseYears[index % chineseYears.count];
}

+ (NSString *)chineseCalendarDay:(NSInteger)index{
    NSArray *chineseYears = @[  @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                                @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                                @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
    return chineseYears[index % chineseYears.count];
}

/**
 *  计算上次日期距离现在多久
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param format1     上次日期格式
 *  @param currentTime 最近日期(需要和格式对应)
 *  @param format2     最近日期格式
 *
 *  @return xx分钟前、xx小时前、xx天前
 */
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1
                         ToCurrentTime:(NSString *)currentTime
                     currentTimeFormat:(NSString *)format2{
    //上次时间
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    dateFormatter1.dateFormat = format1;
    NSDate *lastDate = [dateFormatter1 dateFromString:lastTime];
    //当前时间
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc]init];
    dateFormatter2.dateFormat = format2;
    NSDate *currentDate = [dateFormatter2 dateFromString:currentTime];
    return [self timeIntervalFromLastTime:lastDate ToCurrentTime:currentDate];
}

+ (NSString *)timeIntervalFromLastTime:(NSDate *)lastTime ToCurrentTime:(NSDate *)currentTime{
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    //上次时间
    NSDate *lastDate = [lastTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:lastTime]];
    //当前时间
    NSDate *currentDate = [currentTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:currentTime]];
    //时间间隔
    NSInteger intevalTime = [currentDate timeIntervalSinceReferenceDate] - [lastDate timeIntervalSinceReferenceDate];
    
    //秒、分、小时、天、月、年
    NSInteger minutes = intevalTime / 60;
    NSInteger hours = intevalTime / 60 / 60;
    NSInteger day = intevalTime / 60 / 60 / 24;
    NSInteger month = intevalTime / 60 / 60 / 24 / 30;
    NSInteger yers = intevalTime / 60 / 60 / 24 / 365;
    
    if (minutes <= 10) {
        return  @"刚刚";
    }else if (minutes < 60){
        return [NSString stringWithFormat: @"%ld分钟前",(long)minutes];
    }else if (hours < 24){
        return [NSString stringWithFormat: @"%ld小时前",(long)hours];
    }else if (day < 30){
        return [NSString stringWithFormat: @"%ld天前",(long)day];
    }else if (month < 12){
        NSDateFormatter * df =[[NSDateFormatter alloc]init];
        df.dateFormat = @"M月d日";
        NSString * time = [df stringFromDate:lastDate];
        return time;
    }else if (yers >= 1){
        NSDateFormatter * df =[[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy年M月d日";
        NSString * time = [df stringFromDate:lastDate];
        return time;
    }
    return @"";
}

+ (BOOL)isTheSameDayA:(NSDate *)aDate b:(NSDate *)bDate{
    if (!([aDate isKindOfClass:NSDate.class] && [bDate isKindOfClass:NSDate.class])) {
        return NO;
    }
    NSDateComponents *f = [self componentForDate:aDate];
    NSDateComponents *s = [self componentForDate:bDate];
    return (f.year == s.year) && (f.month == s.month) && (f.day == s.day);
}

+ (NSInteger)theFirstSecondOfMonth:(NSDate *)date{
    return [self publicFunction:date str:^NSString *(NSDateComponents *c) {
        NSString *str = [[NSString alloc] initWithFormat:@"%d-%@-01 00:00:00",(int)c.year,[self twoChar:c.month]];
        return str;
    }];
}

+ (NSInteger)theLastSecondOfMonth:(NSDate *)date{
    return [self publicFunction:date str:^NSString *(NSDateComponents *c) {
        NSInteger days = [self daysForMonth:c.month year:c.year];
        NSString *str = [[NSString alloc] initWithFormat:@"%d-%@-%d 23:59:59",(int)c.year,[self twoChar:c.month],(int)days];
        return str;
    }];
}

+ (NSInteger)theFirstSecondOfDay:(NSDate *)date{
    return [self publicFunction:date str:^NSString *(NSDateComponents *c) {
        NSString *str = [[NSString alloc] initWithFormat:@"%d-%@-%@ 00:00:00",(int)c.year,[self twoChar:c.month],[self twoChar:c.day]];
        return str;
    }];
}

+ (NSInteger)theLastSecondOfDay:(NSDate *)date{
    return [self publicFunction:date str:^NSString *(NSDateComponents *c) {
        NSString *str = [[NSString alloc] initWithFormat:@"%d-%@-%@ 23:59:59",(int)c.year,[self twoChar:c.month],[self twoChar:c.day]];
        return str;
    }];
}

+ (NSInteger)theFirstSecondOfYear:(NSInteger)year{
    NSString *str = [[NSString alloc] initWithFormat:@"%@-01-01 00:00:00",@(year)];
    NSDate *result = [self dateByString:str formatter:nil];
    NSTimeInterval t = (NSInteger)[result timeIntervalSince1970];
    return t;
}

+ (NSInteger)theLastSecondOfYear:(NSInteger)year{
    NSString *str = [[NSString alloc] initWithFormat:@"%@-12-31 23:59:59",@(year)];
    NSDate *result = [self dateByString:str formatter:nil];
    NSTimeInterval t = (NSInteger)[result timeIntervalSince1970];
    return t;
}

+ (NSInteger)publicFunction:(NSDate *)date str:(NSString *(^)(NSDateComponents *c))callback{
    if (![date isKindOfClass:NSDate.class]) {
        return 0;
    }
    NSDateComponents *c = [self componentForDate:date];
    NSString *str = callback(c);
    NSDate *result = [self dateByString:str formatter:nil];
    NSTimeInterval t = (NSInteger)[result timeIntervalSince1970];
    return t;
}

+ (NSString *)twoChar:(NSInteger)value{
    if (value < 10) {
        return [[NSString alloc] initWithFormat:@"0%@",@(value)];
    }
    return [[NSString alloc] initWithFormat:@"%@",@(value)];
}

@end
