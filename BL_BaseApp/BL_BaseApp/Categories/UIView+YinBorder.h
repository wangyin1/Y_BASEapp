//
//  UIView+YinBorder.h
//  BL_BaseApp
//
//  Created by bolaa on 17/3/16.
//  Copyright © 2017年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YinBorder)

@property(nonatomic,readonly)NSInteger  y_borderWidth;//默认为1

@property(nonatomic,readonly)NSInteger  y_borderMargin;//边框离自己的距离

@property(nonatomic,readonly)UIColor     *y_borderColor;//默认为黑色

@property(nonatomic,readonly)NSInteger      y_radius;//圆角范围 默认为0

@property(nonatomic,readonly)BOOL     y_inside;//是否在内部


///----------------重复调用方法 只保留最后一次创建的边框--------------

//设置边框 默认为 内边框 宽度为1
- (void)y_makeBorderWithColor:(UIColor *)color Radius:(NSInteger)radius Inside:(BOOL)inside;


//设置边框
- (void)y_makeBorderWithColor:(UIColor *)color Width:(NSInteger)width  Radius:(NSInteger)radius Margin:(NSInteger)margin Inside:(BOOL)inside;

@end
