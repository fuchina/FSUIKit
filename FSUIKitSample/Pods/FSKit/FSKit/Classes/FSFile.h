//
//  FSFile.h
//  Expand
//
//  Created by Fudongdong on 2017/8/15.
//  Copyright © 2017年 china. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSFile : NSObject

/*
 *  path为文件路径，content为内容，返回失败原因，nil表示成功
 *  [FSFile wirteToFile:@"/Users/fudon/Desktop/file.txt" content:[NSDate date].description];
 */
+ (NSError *)wirteToFile:(NSString *)path content:(NSString *)content;

@end
