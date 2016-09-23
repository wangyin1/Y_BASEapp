//
//  Manager.h
//  Contact
//
//  Created by zz on 14/12/29.
//  Copyright (c) 2014年 zz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Manager : NSObject

//验证邮箱
+ (BOOL)validateEmail:(NSString *)email;

//验证手机
+ (BOOL)validateMobile:(NSString *)mobile;

//验证汽车
+ (BOOL)validateCarNo:(NSString *)carNo;

//验证用户名
+ (BOOL)validateUserName:(NSString *)name;

//验证密码
+ (BOOL)validatePassword:(NSString *)passWord;

//验证昵称
+ (BOOL)validateNickname:(NSString *)nickname;

//验证身份证
+ (BOOL) validateIdentityCard: (NSString *)value;

//验证数字
+ (BOOL)validateNumber:(NSString *)string;

//验证浮点数
+ (BOOL)validatePureFloat:(NSString*)string;

//验证整数
+ (BOOL)validatePureInt:(NSString*)string;
/**
 *  是否是合法的电话号码
 *
 *  @param aString 电话号码
 *
 *  @return YES or NO
 */
+ (BOOL)validateTelephoneNumber:(NSString *)aString;
@end
