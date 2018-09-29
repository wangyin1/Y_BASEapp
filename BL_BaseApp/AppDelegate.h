//
//  AppDelegate.h
//  BL_BaseApp
//
//  Created by 王印 on 16/7/20.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign)UIInterfaceOrientationMask       orientation;

- (void)setWindowRootViewController;
//后去app当前显示的控制器
- (UIViewController *)currentTopController;

@end

