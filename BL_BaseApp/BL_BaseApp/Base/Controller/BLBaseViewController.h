//
//  BLBaseViewController.h
//  BL_BaseApp
//
//  Created by 王印 on 16/7/22.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface BLBaseViewController : UIViewController

/**
 *  navagationbar的基本配置
 */

//字体颜色 默认为[UIColor blackColor]
@property (nonatomic , strong) UIColor *navagationBarTextColor;

//背景颜色 默认为[UIColor whiteColor]
@property (nonatomic , strong) UIColor *navagationBarColor;

//navagationbar 的高度 默认为44 高度改变之后控件靠顶部约束
@property (nonatomic , assign) CGFloat navagationBarHeight;

//设置对应的navagationbar是否透明 默认为NO不透明 YES透明
@property (nonatomic , assign) BOOL navagationBarLucency;

//对哪个子视图做刷新控制
@property (nonatomic , strong) UIScrollView *refreshView;

//navagationbar是否隐藏 默认为不隐藏navagationbar
@property (nonatomic , assign) BOOL navagationBarHiden;

#pragma mark 主动方法
//整页视图加载
- (void)showLoad;

//停止加载
- (void)hidenLoad;

//打电话
- (void)callPhone:(NSString *)phone;

//
- (void)pushPage:(UIViewController *)viewController Animated:(BOOL)animated;

//
- (void)popAnimated:(BOOL)animated;

//
- (void)popToRootAnimated:(BOOL)animated;

//打开一个web页面 是否隐藏navbar
- (void)pushWeb:(NSString *)url HidenNavBar:(BOOL)hiden;

#pragma mark 回调方法
//下拉刷新
- (void)headerRefreshRefreshView:(UIScrollView *)view;

//上拉加载更多
- (void)footerRefreshRefreshView:(UIScrollView *)view;

//控制器上面有文字变化时会调用此方法
- (void)textDidChange:(id)textView;

//生命周期，初始化视图加载完成，只调用一次，网络请求、动画可放在这里处理
- (void)viewDidLoadFinish;




@end
