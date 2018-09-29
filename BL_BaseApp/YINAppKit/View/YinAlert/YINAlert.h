//
//  YINAlert.h
//  BL_BaseApp
//
//  Created by apple on 2017/12/25.
//  Copyright © 2017年 王印. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSUInteger, YINAlertShowAnimation) {
    YINAlertShowAnimationFade,//渐变
    YINAlertShowAnimationFromUp,
    YINAlertShowAnimationFromLeft,//从左
    YINAlertShowAnimationFromRight,//从右
    YINAlertShowAnimationFromDown,//从下
    YINAlertShowAnimationZoomSale,//由小变大
};


//弹出视图控制器
@interface YINAlert : NSObject

//-------------对象方法----------------
//

//被弹出的视图 需要设置frame 就是弹出动画结束后的坐标和大小
@property(nonatomic,strong)UIView   *contentView;

//点击contentView以外的区域是否关闭弹窗
@property(nonatomic,assign)BOOL  tapOutDismiss;

//默认为渐变fade
@property(nonatomic,assign)YINAlertShowAnimation    animationType;

//弹出
- (void)showInView:(UIView *)view;

- (void)showInView:(UIView *)view Animation:(YINAlertShowAnimation)animationType;

//消失 默认以show的反方向动画
- (void)dismiss;

//消失
- (void)dismissAnmation:(YINAlertShowAnimation)animationType;

//--------------end---------------

+ (instancetype)showYinAlertWithContent:(UIView *)contentView InSuperView:(UIView *)superView AnimationType:(YINAlertShowAnimation )animationType;



//system

+ (UIAlertController *)systemAlertWithTitle:(NSString *)title Message:(NSString *)message AlertStyle:(UIAlertControllerStyle)style Actions:(NSArray <NSString *> *)actions ClickBlock:(void(^)(NSInteger index))block;

+ (UIAlertController *)showSystemAlertFromController:(UIViewController *)vc WithTitle:(NSString *)title Message:(NSString *)message  AlertStyle:(UIAlertControllerStyle)style  Actions:(NSArray <NSString *> *)actions ClickBlock:(void(^)(NSInteger index))block;

@end
