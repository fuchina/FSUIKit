//
//  FSEntity.h
//  myhome
//
//  Created by Fusum on 2017/8/10.
//  Copyright © 2017年 fuhope. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
-(void)setAttributes:(NSDictionary*)dataDic;

@end
