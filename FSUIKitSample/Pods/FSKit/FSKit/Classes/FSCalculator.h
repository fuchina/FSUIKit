//
//  FSCalculator.h
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/4/3.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FSCalculator : NSObject

+ (CGFloat)DEBJWithYearRate:(CGFloat)rate monthes:(NSInteger)month;

+ (CGFloat)DEBXWithYearRate:(CGFloat)rate monthes:(NSInteger)month;

+ (CGFloat)priceRiseWithDays:(CGFloat)days yearRate:(CGFloat)rate;

+ (NSInteger)computeSampleSize:(UIImage *)image minSideLength:(NSInteger)minSideLength maxNumOfPixels:(NSInteger)maxNumOfPixels;

// 计算文本宽度
+ (CGFloat)textWidth:(NSString *)text font:(UIFont *)font labelHeight:(CGFloat)labelHeight;
// 计算字符串放在label上需要的高度,font数字要和label的一样
+ (CGFloat)textHeight:(NSString *)text font:(UIFont *)font labelWidth:(CGFloat)labelWidth;

// label调用 sizeToFit 可以实现自适应
+ (double)distanceBetweenCoordinate:(CLLocationCoordinate2D)coordinateA toCoordinateB:(CLLocationCoordinate2D)coordinateB;


// 五险一金后工资应缴税额
+ (CGFloat)taxForSalaryAfterSocialSecurity:(CGFloat)money;
// 根据税后推算税前
+ (NSArray *)taxRatesWithMoneyAfterTax:(CGFloat)money;
// 返回税率（index[0]）和速算扣除数(index[1])
+ (NSArray *)taxRateForMoney:(CGFloat)money;

@end
