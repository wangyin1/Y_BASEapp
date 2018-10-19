//
//  KeyChain.h
//  KeyChain
//
//  Created by chenlishuang on 2017/8/21.
//  Copyright © 2017年 chenlishuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

/**
 钥匙串使用
 */
@interface KeyChain : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)serviece;
@end
