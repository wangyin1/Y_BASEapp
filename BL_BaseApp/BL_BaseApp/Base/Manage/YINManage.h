//
//  YINManage.h
//  BL_BaseApp
//
//  Created by apple on 2017/6/29.
//  Copyright © 2017年 王印. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    OPENTYPEPUSH,
    OPENTYPEPRESENT,
    OPENTYPENULL,
} OPENTYPE;


@protocol YINManageDelegate <NSObject>

// 打开模块主控制器
- (void)openWithData:(id)data;

//接受到消息 用于模块间通信
- (void)onMessage:(NSString *)message AndData:(id)data;

@end

//模块化编程，用manage来管理模块。 使得代码耦合度降低
//模块之间的跳转 通信管理

@interface YINManage : NSObject <YINManageDelegate>

//单利类
+ (instancetype)instance;

//页面打开方法
- (void)openPage:(UIViewController *)vc Animation:(OPENTYPE)animationtype;

@end



