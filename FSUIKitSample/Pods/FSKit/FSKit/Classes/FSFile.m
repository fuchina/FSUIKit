//
//  FSFile.m
//  Expand
//
//  Created by Fudongdong on 2017/8/15.
//  Copyright © 2017年 china. All rights reserved.
//

#import "FSFile.h"

@implementation FSFile

+ (NSError *)wirteToFile:(NSString *)path content:(NSString *)content{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        NSError *error = nil;
        BOOL success = [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (!success) {
            return error;
        }else{
            return nil;
        }
    }
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:path];
    [file seekToEndOfFile];
    NSData *stringData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [file writeData:stringData];
    [file closeFile];
    return nil;
}

@end
