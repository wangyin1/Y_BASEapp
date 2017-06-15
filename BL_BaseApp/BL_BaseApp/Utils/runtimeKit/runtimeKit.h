//
//  runtimeKit.h
//  runtimeKit
//
//  Created by 58 on 17/2/25.
//  Copyright © 2017年 yuanmenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
@interface runtimeKit : NSObject
+ (void)print;
- (void)test;
+ (NSString *)fetchClassName:(id )object;
+ (NSArray *)fetchIvarList:(id )object;
+ (NSArray *)fetchIvarClass:(Class )class;
+ (NSArray *)fetchPropertyList:(Class)class;
/**
 *    获取的知识实例方法
 */
+ (NSArray *)fetchMethodList:(Class)class;
+ (NSArray *)fetchProtocolList:(Class )class;

/**
 *   向系统的表中添加 协议
 */
+ (void)registerProtocol:(const char *)protocolName;

+ (void)addPrtocol:(NSString *)protocolString toClass:(Class )class;

/**
 *    向某一个类，添加某一个属性 ,和值
 */
+ (void)addProperty:(id)property ToObject:(id)object;
+ (id )getValueFromProperty:(id )property withObject:(id) object;
+ (BOOL)addInstanceTargetClass:(Class)targetClass originClass:(Class)originClass method:(SEL)methodSel;

//  实例方法交换后 ，调用的是相互对象的实力方法名 其实就是自身list 列表中 对象的交换，所以方法名也变啦
+ (void)instanceMethodExchangeOriginClass:(Class)originClass originMethod:(SEL)originMethod exchangeClass:(Class)class exchangeMethod:(SEL)replaceMethod;
//  类方法的交换，  是自身 类方法表中的方法实现的函数地址的交换，所以还要调用 老方法名 ，但实现变啦
+ (void)classMethodExchangeOriginClass:(Class)originClass originMethod:(SEL)originMethod exchangeClass:(Class)class exchangeMethod:(SEL)replaceMethod;
@end
