//
//  AppDelegate.m
//  BL_BaseApp
//
//  Created by 王印 on 16/7/20.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "WFirstVC.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "YINSocketViewController.h"
#import "BLWebViewController.h"
#import "XHLaunchAd.h"
#import "BaseTabarController.h"
#import "runtimeKit.h"
#import "Aspects.h"
#import "MJExtension.h"
#import "JPUSHService+Tool.h"
#import "BLCarController.h"
#import "AFNetworkReachabilityManager+IPV6.h"
#import "LHDemoViewController.h"

@interface AppDelegate ()<JPUSHServiceToolDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //iOS11适配
    [self checkiOS11System];
    
    //添加3dtouch快捷按钮
    [self addShortcutItem:@[@{@"type":@"test1",@"title":@"按钮一",@"subTitle":@"功能介绍1",@"image":@(UIApplicationShortcutIconTypeAdd)},@{@"type":@"test2",@"title":@"按钮儿",@"subTitle":@"功能介绍2",@"image":@(UIApplicationShortcutIconTypePlay)}]];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];

    [self setWindowRootViewController];

    [self.window makeKeyAndVisible];
    [self initADView];//初始化启动广告控件
    [self DIYSetting];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AFNetworkingReachabilityDidChangeNotification object:nil];
    }];
    
//    //极光推送
//    [JPUSHService startWithOption:launchOptions Appkey:@"" ApsForProduction:YES Delegete:self registrationIDCompletionHandler:^(int code, NSString * token) {
//
//    }];
//    [JPUSHService jpushToolEnterAPPWithOption:launchOptions];
    return YES;
}





- (void)DIYSetting{
    //-------------
    
    //这里其他sdk初始化
    
    //-------------
}


//添加快捷按钮 首次运行app无效
- (void)addShortcutItem:(NSArray <NSDictionary *>*)items{
    NSMutableArray *iconItems = @[].mutableCopy;
    [items enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIApplicationShortcutIcon *icon = nil;
        if([[obj objectForKey:@"image"] isKindOfClass:[NSNumber class]]){
             icon =  [UIApplicationShortcutIcon iconWithType:[[obj objectForKey:@"image"]integerValue]];
        }else if([[obj objectForKey:@"image"] isKindOfClass:[NSString class]]){
            icon = [UIApplicationShortcutIcon iconWithTemplateImageName:[obj objectForKey:@"image"]];
        }
        UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:obj[@"type"] localizedTitle:obj[@"title"] localizedSubtitle:obj[@"subTitle"] icon:icon userInfo:nil];
        [iconItems addObject:item];
    }];
    [[UIApplication sharedApplication] setShortcutItems:iconItems];
}

//通过3d touch 快捷进入
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler NS_AVAILABLE_IOS(9_0) __TVOS_PROHIBITED{
    //先走didFinishLaunchingWithOptions
    //根据类型判断
    if([shortcutItem.type isEqualToString:@"test1"]){
        
        //逻辑处理
        
    }else if ([shortcutItem.type isEqualToString:@"test2"]){
        
        
    }
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
//        [self showLoginViewController]; 调用用户模块的登录协议 可优化
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LHDemoViewController alloc]init]];
    }
}

//添加启动广告控件
- (void)initADView{
    [[NSUserDefaults standardUserDefaults] setObject:@"http://pic77.nipic.com/file/20150910/21756640_103521161000_2.jpg" forKey:@"adimageurl"];
    XHLaunchAd *launchAd = [[XHLaunchAd alloc] initWithFrame:self.window.bounds andDuration:ADIMAGEURL?6:3];
    NSString *imgUrlString = ADIMAGEURL;//广告图地址，（可写死，后台改变广告图时，图片地址不变，也可在进入app后调用接口获取，再缓存，下次启动app生效）
    [launchAd imgUrlString:imgUrlString options:XHWebImageRefreshCached completed:^(UIImage *image, NSURL *url) {
    }];
    launchAd.hideSkip = !ADIMAGEURL;
    if (ADIMAGEURL) {
        [launchAd addInWindow];
    }
}

- (UIViewController *)currentTopController{
    return [self.window topMostController];
}


//---------------------------如果要使用极光推送，请打开此段代码---------------------------
//- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    [JPUSHService registerDeviceToken:deviceToken];
//}
//
//// 在前台收到消息
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//    [JPUSHService application:application didReceiveNotificationUnderIOS10:userInfo];
//}

// //点击消息栏
//- (void)jpushtool_TapNotification:(NSDictionary *)userInfo{
//
//}
//
//
//- (BOOL)jpushtool_ShowNotificationActiveReceiveNotification:(NSDictionary *)userInfo{
//
//    return YES;
//}
//---------------------------end---------------------------

//- (void)configBugly {
//
//    //初始化 Bugly 异常上报
//    BuglyConfig *config = [[BuglyConfig alloc] init];
//    config.delegate = self;
//    config.debugMode = YES;
//    config.reportLogLevel = BuglyLogLevelInfo;
//    [Bugly startWithAppId:@"a1b8dec9ef"
//#if DEBUG
//        developmentDevice:YES
//#endif
//                   config:config];
//    //捕获 JSPatch 异常并上报
//    [JPEngine handleException:^(NSString *msg) {
//        NSException *jspatchException = [NSException exceptionWithName:@"Hotfix Exception" reason:msg userInfo:nil];
//        [Bugly reportException:jspatchException];
//    }];
//    //检测补丁策略
//    [[BuglyMender sharedMender] checkRemoteConfigWithEventHandler:^(BuglyHotfixEvent event, NSDictionary *patchInfo) {
//        //有新补丁或本地补丁状态正常
//        if (event == BuglyHotfixEventPatchValid || event == BuglyHotfixEventNewPatch) {
//            //获取本地补丁路径
//            NSString *patchDirectory = [[BuglyMender sharedMender] patchDirectory];
//            if (patchDirectory) {
//                //指定执行的 js 脚本文件名
//                NSString *patchFileName = @"main.js";
//                NSString *patchFile = [patchDirectory stringByAppendingPathComponent:patchFileName];
//                //执行补丁加载并上报激活状态
//                if ([[NSFileManager defaultManager] fileExistsAtPath:patchFile] &&
//                    [JPEngine evaluateScriptWithPath:patchFile] != nil) {
//                    BLYLogInfo(@"evaluateScript success");
//                    [[BuglyMender sharedMender] reportPatchStatus:BuglyHotfixPatchStatusActiveSucess];
//                }else {
//                    BLYLogInfo(@"evaluateScript failed");
//                    [[BuglyMender sharedMender] reportPatchStatus:BuglyHotfixPatchStatusActiveFail];
//                }
//            }
//        }
//    }];
//}

- (void)checkiOS11System{
    
    //适配iOS11 所有的scrollview 不下移64像素 统一由edgesForExtendedLayout 控制
    if (@available(iOS 11.0, *)) {
        //如果tableview没有设置EstimatedxxHeight 则统一设置为0。 相当于关闭Self-Sizing。如果设置过，就不去修改
        //关闭了Self-Sizing 需要使用的时候设置EstimatedxxHeight 即可。使用习惯恢复到xcode9之前。
        const NSString *ios11_rowHeight = @"ios11_rowHeight";
        const NSString *ios11_headerHeight = @"ios11_headerHeight";
        const NSString *ios11_footerHeight = @"ios11_footerHeight";
        [UITableView aspect_hookSelector:@selector(setEstimatedRowHeight:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>info){
            objc_setAssociatedObject(info.instance, &ios11_rowHeight, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } error:nil];
        [UITableView aspect_hookSelector:@selector(setEstimatedSectionFooterHeight:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>info){
            objc_setAssociatedObject(info.instance, &ios11_footerHeight, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } error:nil];
        [UITableView aspect_hookSelector:@selector(setEstimatedSectionHeaderHeight:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>info){
            objc_setAssociatedObject(info.instance, &ios11_headerHeight, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        } error:nil];
        [UIScrollView aspect_hookSelector:@selector(willMoveToSuperview:) withOptions:AspectPositionAfter usingBlock:^(id <AspectInfo> info){
            NSLog(@"%@",NSStringFromClass([info.instance class]));
            if ([[info.instance class] isKindOfClass:NSClassFromString(@"WKScrollView")]) {
                return ;
            }
            [(UIScrollView *)info.instance setContentInsetAdjustmentBehavior:2];
            if ([info.instance isKindOfClass:[UITableView class]]) {
                if (![objc_getAssociatedObject(info.instance, &ios11_rowHeight) boolValue]) {
                    [info.instance setEstimatedRowHeight:0];
                }
                if (![objc_getAssociatedObject(info.instance, &ios11_headerHeight) boolValue]) {
                    [info.instance setEstimatedSectionHeaderHeight:0];
                }
                if (![objc_getAssociatedObject(info.instance, &ios11_footerHeight) boolValue]) {
                    [info.instance setEstimatedSectionFooterHeight:0];
                }
            }
        } error:nil];
    } else {
        
    }
}



#pragma -- mark  强制调用系统键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    return NO;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return self.orientation;
}

@end
