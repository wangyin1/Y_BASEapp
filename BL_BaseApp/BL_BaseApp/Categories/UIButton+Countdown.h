//
//  UIButton+Countdown.h
//  BL_BaseApp
//
//  Created by bolaa on 17/4/10.
//  Copyright © 2017年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Countdown)
//开始倒计时
//一共多久
//结束回调 改变标题
- (void)Countdown_startWithTime:(NSInteger)time Complete:(void(^)())block;

//结束倒计时
- (void)Countdown_stopWithTitle:(NSString *)title;
@end
