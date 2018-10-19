//
//  JPUSHService+Tool.h
//  BL_BaseApp
//
//  Created by 王印 on 16/9/19.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "JPUSHService.h"

@class JPUSHService;

@protocol JPUSHServiceToolDelegate <NSObject>
//用户点击通知时
- (void)jpushtool_TapNotification:(NSDictionary *)userInfo;

//在前台时收到通知 是否显示消息框
- (BOOL)jpushtool_ShowNotificationActiveReceiveNotification:(NSDictionary *)userInfo;

@end



@interface JPUSHService (Tool)


/**
 启动sdk 适配ios8-ios10 并且回调注册成功的registrationID

 @param option
 @param appkey
 @param isProduction      是否正式环境
 @param delegate
 @param completionHandler 注册成功回调
 */
+ (void)startWithOption:(NSDictionary *)option Appkey:(NSString *)appkey ApsForProduction:(BOOL)isProduction Delegete:(id<JPUSHServiceToolDelegate>)delegate registrationIDCompletionHandler:(void (^)(int, NSString *))completionHandler;


/**
 该方法用在启动app时判断是否有远程通知信息，如果有，会执行用户点击通知协议
 进入app调用 在didFinishLaunchingWithOptions方法的最后调用 《固定写》
 
 @param option app信息字典
 */
+ (void)jpushToolEnterAPPWithOption:(NSDictionary *)option;

#pragma mark ios8以上 ios10 以下系统 通知相关处理
+ (void)application:(UIApplication *)application didReceiveNotificationUnderIOS10:(NSDictionary *)userInfo;

@end
