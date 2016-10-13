//
//  JPUSHService+Tool.m
//  BL_BaseApp
//
//  Created by 王印 on 16/9/19.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <objc/runtime.h>
#import <UserNotifications/UserNotifications.h>
#import "JPUSHService+Tool.h"

@interface FounctionTool : NSObject<JPUSHRegisterDelegate>
@property(nonatomic,weak)id<JPUSHServiceToolDelegate>  delegate;

@end

@implementation FounctionTool

+ (instancetype)shareInstance{
    SYNTH_SHARED_INSTANCE();
}


#pragma mark  ios  通知相关相关处理

//iOS 10 系统点击消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@", userInfo);
        
        [self.delegate jpushtool_TapNotification:userInfo];
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();
    
}

//ios10 系统在前台收到通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS10 前台收到远程通知:%@",userInfo);
    if ([self.delegate jpushtool_ShowNotificationActiveReceiveNotification:userInfo]) {
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    }
}

@end



@implementation JPUSHService (Tool)


+ (void)startWithOption:(NSDictionary *)option Appkey:(NSString *)appkey ApsForProduction:(BOOL)isProduction Delegete:(id<JPUSHServiceToolDelegate>)delegate registrationIDCompletionHandler:(void (^)(int, NSString *))completionHandler
{
    
    [FounctionTool shareInstance].delegate = delegate;
    [JPUSHService setupWithOption:option appKey:appkey
                          channel:@"App Store"
                 apsForProduction:isProduction];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:[FounctionTool shareInstance]];
        
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService registrationIDCompletionHandler:completionHandler];
}

+ (void)jpushToolEnterAPPWithOption:(NSDictionary *)option{
    NSDictionary *data = [option objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (data) {
        [[FounctionTool shareInstance].delegate jpushtool_TapNotification:data];
    }
}


#pragma mark ios8以上 ios10 以下系统 通知相关处理

+ (void)application:(UIApplication *)application
    didReceiveNotificationUnderIOS10:(NSDictionary *)userInfo{
    if (application.applicationState==UIApplicationStateInactive) {//点击消息
        [[FounctionTool shareInstance].delegate jpushtool_TapNotification:userInfo];
    }else if (application.applicationState==UIApplicationStateActive){//在前台收到消息
         [[FounctionTool shareInstance].delegate jpushtool_ShowNotificationActiveReceiveNotification:userInfo];
    }
}
@end
