//
//  BLBaseViewController.h
//  BL_BaseApp
//
//  Created by 王印 on 16/7/22.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "AFNetworkReachabilityManager.h"

#define NetErrorMessage @"请检查网络设置！"

@protocol BaseControllerDelegate <NSObject>

@optional

//控制器上面有input文字变化时会调用此方法
- (void)textDidChange;

//生命周期，初始化视图加载完成，只调用一次，网络请求、动画可放在这里处理
- (void)viewDidLoadFinish;

//网络状态改变 回调给controller 方便做显示控制 hub关闭 下拉关闭等
- (void)netStatusChange:(AFNetworkReachabilityStatus)status;

@end

@interface BLBaseViewController : UIViewController<BaseControllerDelegate>

/**
 *  navagationbar的基本配置
 */

//字体颜色 默认为[UIColor blackColor]
@property (nonatomic , strong) UIColor *navagationBarTextColor;

//背景颜色 默认为[UIColor whiteColor]
@property (nonatomic , strong) UIColor *navagationBarColor;

//设置对应的navagationbar是否透明 默认为NO不透明 YES透明
@property (nonatomic , assign) BOOL navagationBarLucency;

//navagationbar是否隐藏 默认为不隐藏navagationbar
@property (nonatomic , assign) BOOL navagationBarHiden;

//隐藏nav横线
@property(nonatomic,assign)BOOL     navagationBarShadowLineHiden;

//控制屏幕方向   如果要使用这个属性 需要在xcode配置中四个屏幕方向都选中
@property(nonatomic,assign)UIInterfaceOrientationMask  screenOrientation;

//是否启用大标题模式 仅支持iOS11 默认为NO 。
@property(nonatomic,assign)BOOL       navLargeTitleMode;
    


#pragma mark 主动方法
//整页视图加载
- (void)showLoad;

//停止加载
- (void)hidenLoad;

//打电话
- (void)callPhone:(NSString *)phone;

- (void)pushColseSelf:(UIViewController *)vc;

//
- (void)pushPage:(UIViewController *)viewController Animated:(BOOL)animated;

//
- (void)popAnimated:(BOOL)animated;

//
- (void)popToRootAnimated:(BOOL)animated;

//打开一个web页面 是否隐藏navbar
- (void)pushWeb:(NSString *)url HidenNavBar:(BOOL)hiden;

@end
