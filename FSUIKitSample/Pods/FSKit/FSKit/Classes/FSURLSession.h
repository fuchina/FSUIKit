//
//  FSURLSession.h
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/2/2.
//

#import <Foundation/Foundation.h>

@interface FSURLSession : NSObject

+ (void)sessionGet:(NSString *)urlString success:(void (^)(id value))success fail:(void (^)(void))fail;

@end
