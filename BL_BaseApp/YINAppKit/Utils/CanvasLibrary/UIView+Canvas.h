//
//  UIView+Canvas.h
//  BL_BaseApp
//
//  Created by bolaa on 16/12/9.
//  Copyright © 2016年 王印. All rights reserved.
//
#import "Aspects.h"
#import <UIKit/UIKit.h>

#import "Canvas.h"

@interface UIView (Canvas)

@property(nonatomic,strong)CSAnimationType      canvasType;//类型
@property(nonatomic,assign)CGFloat              canvasDuration;//持续时间
@property(nonatomic,assign)CGFloat              canvasDelay;//延时
@property(nonatomic,assign)BOOL                 initStart;//是否初始化的时候触发一次

//注册动画类型，默认初始化的时候不会触发
+ (void)registerAnimationType:(CSAnimationType)animationType;

//触发动画
- (void)startCanvasAnimation;

//触发所有子视图动画／只遍历一层结构
- (void)startSubviewCamvasAnimation;
@end
