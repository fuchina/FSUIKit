//
//  FSCalculator.m
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/4/3.
//

#import "FSCalculator.h"

@implementation FSCalculator

/*
 等额本金计算公式
 rate:年利率，如4.9%，输入4.9；
 month:期数，也就是月数，如10年，输入120
 返回值：总还款除以贷款的倍数
 */
+ (CGFloat)DEBJWithYearRate:(CGFloat)rate monthes:(NSInteger)month{
    if (rate < 0.01) {
        return 1;
    }
    CGFloat money = 1.0;
    CGFloat R = rate / 1200.0f;
    
    CGFloat allInterest = 0;
    double payMonth = money / month;
    for (int x = 0; x < month; x ++) {
        double mI = (money - x * payMonth) * R; // 每月的利息；加上payMonth就是每月的还款额
        allInterest += mI;
    }
    return (money + allInterest) / money;
}

/*
 等额本息计算公式
 rate:年利率，如4.9%，输入4.9；
 month:期数，也就是月数，如10年，输入120
 返回值：总还款除以贷款的倍数
 */
+ (CGFloat)DEBXWithYearRate:(CGFloat)rate monthes:(NSInteger)month{
    if (rate < 0.01) {
        return 1;
    }
    CGFloat money = 1.0f;
    CGFloat R = rate / 1200.0f;
    // 等额本息
    double monthPay = (money * R * pow(1 + R, month)) / (pow(1 + R, month) - 1);
    return monthPay * month / money;
}

/*
 @param
 days:周转天数，单位：天，即多少天后会卖出；
 rate:目标年化收益率，比如20%；
 
 @result
 返回价格倍数，比如输入90，0.3820,返回1.094129，即90天卖出应该定价为所投入资本的1.094129倍
 */
+ (CGFloat)priceRiseWithDays:(CGFloat)days yearRate:(CGFloat)rate{
    days = MAX(days, 1);
    rate = MAX(0, rate);
    CGFloat year = 365.2422;
    CGFloat everyEarn = rate / year;
    CGFloat allEarn = days * everyEarn;
    return (allEarn + 1);
}

+ (NSInteger)computeSampleSize:(UIImage *)image minSideLength:(NSInteger)minSideLength maxNumOfPixels:(NSInteger)maxNumOfPixels{
    NSInteger initialSize = [self computeInitialSampleSize:image minSideLength:minSideLength maxNumOfPixels:maxNumOfPixels];
    NSInteger roundedSize = 0;
    if (initialSize <= 8) {
        roundedSize = 1;
        while (roundedSize < initialSize) {
            roundedSize <<= 1;
        }
    }else{
        roundedSize = (initialSize + 7) / 8 * 8;
    }
    return roundedSize;
}

+ (NSInteger)computeInitialSampleSize:(UIImage *)image minSideLength:(NSInteger)minSideLength maxNumOfPixels:(NSInteger)maxNumOfPixels{
    double w = image.size.width;
    double h = image.size.height;
    
    NSInteger lowerBound = (maxNumOfPixels == -1) ? 1 : (int)ceil(sqrt(w * h / maxNumOfPixels));
    NSInteger upperBound = (minSideLength == -1) ? 128 : (int) MIN(floor(w / minSideLength), floor(h / minSideLength));
    if (upperBound < lowerBound) {
        return lowerBound;
    }
    if ((maxNumOfPixels == -1) && (minSideLength == -1)) {
        return 1;
    }else if (minSideLength == -1) {
        return lowerBound;
    } else {
        return upperBound;
    }
}

+ (CGFloat)textHeight:(NSString *)text font:(UIFont *)font labelWidth:(CGFloat)labelWidth{
    if (![font isKindOfClass:UIFont.class]) {
        return 0;
    }
    if (!([text isKindOfClass:NSString.class] && text.length)) {
        return 0;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange allRange = [text rangeOfString:text];
    [attrStr addAttribute:NSFontAttributeName
                    value:font
                    range:allRange];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                        options:options
                                        context:nil];
    return ceilf(rect.size.height + 2);
}

+ (CGFloat)textWidth:(NSString *)text font:(UIFont *)font labelHeight:(CGFloat)labelHeight{
    if (![font isKindOfClass:UIFont.class]) {
        return 0;
    }
    if (!([text isKindOfClass:NSString.class] && text.length)) {
        return 0;
    }
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, labelHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return ceil(size.width + 2);
}

+ (double)distanceBetweenCoordinate:(CLLocationCoordinate2D)coordinateA toCoordinateB:(CLLocationCoordinate2D)coordinateB{
    double EARTH_RADIUS = 6378.137;//地球半径
    double lat1 = coordinateA.latitude;
    double lng1 = coordinateA.longitude;
    double lat2 = coordinateB.latitude;
    double lng2 = coordinateB.longitude;
    
    double radLat1 = [self rad:lat1];
    double radLat2 = [self rad:lat2];
    double a = radLat1 - radLat2;
    double b = [self rad:lng1] - [self rad:lng2];
    
    double s = 2 * sin(sqrt(pow(sin(a/2),2) + cos(radLat1) * cos(radLat2)* pow(sin(b/2),2)));
    s = s * EARTH_RADIUS;
    s = round(s * 10000) / 10000;
    return s;
}

+ (double)rad:(double)d{
    return d * 3.141592653 / 180.0;
}

+ (CGFloat)taxForSalaryAfterSocialSecurity:(CGFloat)money{
    CGFloat deltaMoney = money - 3500;
    if (deltaMoney <= 0) {
        return 0;
    }
    NSArray *rateArray = [self taxRateForMoney:deltaMoney];
    CGFloat taxRate = [rateArray[0] floatValue];
    CGFloat quickNumber = [rateArray[1] floatValue];
    return deltaMoney * taxRate - quickNumber;
}

+ (NSArray *)taxRatesWithMoneyAfterTax:(CGFloat)money{
    NSArray *rateArray = @[
                           @[@0.03,@0,@0,@1500],
                           @[@0.1,@105,@1500,@4500],
                           @[@.2,@555,@4500,@9000],
                           @[@.25,@1005,@9000,@35000],
                           @[@.3,@2755,@35000,@55000],
                           @[@.35,@5505,@55000,@80000],
                           @[@.45,@13505,@8000000]
                           ];
    NSMutableArray *selectArrays = [[NSMutableArray alloc] init];
    for (int x = 0; x < rateArray.count; x ++) {
        if (x == (rateArray.count - 1)) {
            NSArray *subRateArray = rateArray[x];
            CGFloat marginMin = [subRateArray[2] floatValue];
            CGFloat quickNumber = [subRateArray[1] floatValue];
            CGFloat taxRate = [subRateArray[0] floatValue];
            CGFloat salary = (money - quickNumber - 3500 * taxRate) / (1 - taxRate);
            if ((salary - 3500) > marginMin) {
                [selectArrays addObject:subRateArray];
            }
        }else{
            NSArray *subRateArray = rateArray[x];
            CGFloat marginMin = [subRateArray[2] floatValue];
            CGFloat marginMax = [subRateArray[3] floatValue];
            CGFloat quickNumber = [subRateArray[1] floatValue];
            CGFloat taxRate = [subRateArray[0] floatValue];
            CGFloat salary = (money - quickNumber - 3500 * taxRate) / (1 - taxRate);
            if (((salary - 3500) > marginMin) && ((salary - 3500) <= marginMax)) {
                [selectArrays addObject:subRateArray];
            }
        }
    }
    if (!selectArrays.count) {
        return nil;
    }
    return selectArrays;
}


+ (NSArray *)taxRateForMoney:(CGFloat)money{
    if (money <= 1500) {
        return @[@0.03,@0];
    }else if (money <= 4500){
        return @[@0.1,@105];
    }else if (money <= 9000){
        return @[@.2,@555];
    }else if (money <= 35000){
        return @[@.25,@1005];
    }else if (money <= 55000){
        return @[@.3,@2755];
    }else if (money <= 80000){
        return @[@.35,@5505];
    }else
        return @[@.45,@13505];
}

@end
