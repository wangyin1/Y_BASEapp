//
//  BaseTabarController.h
//  BL_BaseApp
//
//  Created by 王印 on 16/9/3.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabarController : UITabBarController
/**
 *  是否显示横线
 */
@property(nonatomic,assign)BOOL         showLine;

/**
 *  bar的背景颜色
 */
@property(nonatomic,strong)UIColor      *barBackgroundColor;

/**
 *  初始化方法 
 *
 *  @param titles          bar文字数组
 *  @param imageNames      默认情况下图标名数组
 *  @param selectImages    选中时图标数组
 *  @param viewControllers 控制器数组
 *
 *  @return
 */
- (instancetype)initWithtabBarItemTitles:(NSArray <NSString *>*)titles ImageNames:(NSArray<NSString *> *)imageNames SelectImages:(NSArray<NSString *> *)selectImages SelectedColor:(UIColor *)selectedColor DesSelectColor:(UIColor *)desSelectColor ViewControllers:(NSArray <UIViewController *> *)viewControllers;

@end
