//
//  UIButton+Countdown.m
//  BL_BaseApp
//
//  Created by bolaa on 17/4/10.
//  Copyright © 2017年 王印. All rights reserved.
//

#import "UIButton+Countdown.h"



@implementation UIButton (Countdown)

//开始倒计时
- (void)Countdown_startWithTime:(NSInteger)time Complete:(void(^)())block{
    
    self.userInteractionEnabled = NO;
    [self setTitle:[NSString stringWithFormat:@"%ld秒",time] forState:0];
     [self startWithBlock:block];
}

- (void)startWithBlock:(void(^)())block{
    if (self.userInteractionEnabled) {
        return;
    }
    if ([self.titleLabel.text integerValue]==1) {
        self.userInteractionEnabled = YES;
        if (block) {
            block();
        }
        
    }else if([self.titleLabel.text integerValue]==0){
        self.userInteractionEnabled = YES;
        if (block) {
            block();
        }
        
    }else{
        [self setTitle:[NSString stringWithFormat:@"%ld秒",[self.titleLabel.text integerValue]-1] forState:0];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startWithBlock:block];
        });
    }
    
}

- (void)Countdown_stopWithTitle:(NSString *)title{
    [self setTitle:title forState:0];
    self.userInteractionEnabled = YES;
}

@end
