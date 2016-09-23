//
//  AppDelegate.m
//  BL_BaseApp
//
//  Created by 王印 on 16/7/20.
//  Copyright © 2016年 王印. All rights reserved.
//
#import "JPEngine.h"
#import "WFirstVC.h"
#import "AppDelegate.h"
#import "BLLoginViewController.h"
#import "XHLaunchAd.h"
#import "BLJSPatchManager.h"
#import "BaseTabarController.h"

@interface AppDelegate ()


@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor clearColor];
    [self setWindowRootViewController];
    [self.window makeKeyAndVisible];
    [self initADView];//初始化启动广告控件
    //设置补丁下载地址
    [BLJSPatchManager setPatchUrl:[JSPATCHURL copy]];
    //下载补丁
    [BLJSPatchManager start];
    
    [self DIYSetting];
                
    return YES;
}

- (void)DIYSetting{
    //-------------
    
    //这里其他sdk初始化
    
    //-------------
}

//根据基本信息设置app该显示的root模块
- (void)setWindowRootViewController{
    if (!NOTFIRST) {//第一次进入app
        self.window.rootViewController = [[WFirstVC alloc]init];
    }else if (LOGIN){//已经登录 进入app正常使用root页面 此处修改为需求页面
        
        BaseTabarController *root = [[BaseTabarController alloc] initWithtabBarItemTitles:@[@"shouye",@"aa"] ImageNames:@[@"",@""] SelectImages:@[@"",@""] SelectedColor:[UIColor redColor] DesSelectColor:[UIColor blueColor] ViewControllers:@[[BLBaseViewController new],[BLBaseViewController new]]];
        root.barBackgroundColor = [UIColor greenColor];
        root.showLine = NO;
        self.window.rootViewController = root;
        
    }else{//未登录
        [self showLoginViewController];
    }
}

//添加启动广告控件
- (void)initADView{
    XHLaunchAd *launchAd = [[XHLaunchAd alloc] initWithFrame:self.window.bounds andDuration:ADIMAGEURL?6:3];
    NSString *imgUrlString = ADIMAGEURL;//广告图地址，（可写死，后台改变广告图时，图片地址不变，也可在进入app后调用接口获取，再缓存，下次启动app生效）
    [launchAd imgUrlString:imgUrlString options:XHWebImageRefreshCached completed:^(UIImage *image, NSURL *url) {
    }];
    launchAd.hideSkip = !ADIMAGEURL;
    if (ADIMAGEURL) {
        [launchAd addInWindow];
    }
}
#pragma mark 弹出登录页面
- (void)showLoginViewController
{
    BLLoginViewController *loginViewController = [[BLLoginViewController alloc]init];
    loginViewController.navagationBarColor = [UIColor orangeColor];
    UINavigationController *naLoginViewController = [[UINavigationController alloc]initWithRootViewController:loginViewController];
    [self.window setRootViewController:naLoginViewController];
}

#pragma -- mark  强制调用系统键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    return NO;
}
@end
