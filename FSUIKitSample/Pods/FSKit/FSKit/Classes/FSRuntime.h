//
//  FSRuntime.h
//  FBRetainCycleDetector
//
//  Created by Fudongdong on 2018/3/13.
//

#import <Foundation/Foundation.h>

@interface FSRuntime : NSObject

// 获取类所有的属性
+ (NSArray<NSString *> *)propertiesForClass:(Class)_class;

// 获取类所有的成员变量,耗时是propertiesForClass方法的 四分之一 左右
+ (NSArray<NSString *> *)ivarsForClass:(Class)_class;

// 将字符串转化为Set方法，如将"name"转化为setName方法
+ (SEL)setterSELWithAttibuteName:(NSString*)attrName;

// 给对象的属性赋值
+ (void)setValue:(id)value forPropertyName:(NSString *)name ofObject:(id)object;
// 给对象的成员变量赋值 name: 不带前面的下划线
+ (void)setValue:(id)value forIvarName:(NSString *)name ofObject:(id)object;

// 根据字典key-value给对象的同名属性赋值
+ (id)entity:(Class)Entity dic:(NSDictionary *)dic;

// 获取属性的值
+ (id)valueForGetSelectorWithPropertyName:(NSString *)name object:(id)instance;

// 将一个对象转换为字典
+ (NSDictionary *)dictionaryWithObject:(id)model;

// 获取类的类方法
+ (NSArray<NSString *> *)classMethodListOfClass:(Class)cls;
// 获取类的实例方法
+ (NSArray<NSString *> *)methodListOfClass:(Class)_class;

@end
