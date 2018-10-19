//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

@implementation MBProgressHUD (MJ)
#pragma mark 显示信息
//所有的显示效果都要调用该方法；
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view{
  if (view == nil){
    view = [[UIApplication sharedApplication].windows lastObject];
  }
  // 快速显示一个提示信息
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
  
    if (text.length>10) {
        hud.detailsLabelText = text;
    }else{
        hud.labelText = text;
    }
    hud.color = [[UIColor blackColor]colorWithAlphaComponent:0.6];
  // 设置图片
  hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
  // 再设置模式
  hud.mode = MBProgressHUDModeCustomView;

  // 隐藏时候从父控件中移除
  hud.removeFromSuperViewOnHide = YES;

  // 1秒之后再消失
  [hud hide:YES afterDelay:1.0];
}

#pragma mark 显示错误信息
//也同样是调用show方法，只是显示的图片不一样；
+ (void)showError:(NSString *)error toView:(UIView *)view{
  [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
  [self show:success icon:@"success.png" view:view];
}

+ (void)showMessage:(NSString *)message time:(NSTimeInterval)time{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    if (message.length>10) {
        hud.detailsLabelText = message;
    }else{
        hud.labelText = message;
    }
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.color = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:time];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
  if (view == nil){
    view = [[UIApplication sharedApplication].windows lastObject];
  }
  // 快速显示一个提示信息
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
//    if (message.length>10) {
//        hud.detailsLabelText = message;
//    }else{
        hud.labelText = message;
//    }
    hud.color =  [[UIColor blackColor]colorWithAlphaComponent:0.6];
  // 隐藏时候从父控件中移除
  hud.removeFromSuperViewOnHide = YES;
    
  // YES代表需要蒙版效果
  //如果dimBackground设置为true，那么背景就会变成阴影；
  hud.dimBackground = false;
  return hud;
}

+ (void)showSuccess:(NSString *)success{
  [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
  [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
  return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
  [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
  [self hideHUDForView:nil];
}
@end
