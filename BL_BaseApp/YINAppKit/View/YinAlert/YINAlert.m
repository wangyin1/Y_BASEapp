//
//  YINAlert.m
//  BL_BaseApp
//
//  Created by apple on 2017/12/25.
//  Copyright © 2017年 王印. All rights reserved.
//

#import "YINAlert.h"
static NSString *alertKey = @"yinalertKey";
@interface YINAlert ()

@property(nonatomic,strong)UIView       *allView;
@property(nonatomic,assign)YINAlertShowAnimation        dismisAnimation;
@property(nonatomic,assign)CGRect       toFrame;

@end


@implementation YINAlert



- (UIView *)allView{
    if (!_allView) {
        _allView = [[UIView alloc] init];
        _allView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOut)];
        [_allView addGestureRecognizer:tap];
    }
    return _allView;
}

- (void)tapOut{
    if (self.tapOutDismiss) {
        [self dismiss];
    }
}





- (void)setContentView:(UIView *)contentView{
    if (_contentView&&_contentView.superview) {
        [_contentView removeFromSuperview];
    }

    _contentView = contentView;
    if (contentView) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doNothing)];
        [contentView addGestureRecognizer:tap];
        self.toFrame = self.contentView.frame;
        [self.allView addSubview:contentView];
    }
}

- (void)doNothing{
    
}

- (void)resetFrame:(YINAlertShowAnimation)type{
    
    switch (type) {
        case YINAlertShowAnimationFade:
            self.contentView.alpha = 0.2;
            
            break;
        case YINAlertShowAnimationFromUp:
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, - self.contentView.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
            break;
        case YINAlertShowAnimationFromDown:
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.allView.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
            break;
        case YINAlertShowAnimationFromLeft:
            self.contentView.frame = CGRectMake(-self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
            break;
        case YINAlertShowAnimationFromRight:
            self.contentView.frame = CGRectMake(self.allView.frame.origin.x, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
            break;
            
        case YINAlertShowAnimationZoomSale:
            self.contentView.transform = CGAffineTransformMakeScale(0.6, .6);
            break;
        default:
            break;
    }
}

//弹出
- (void)showInView:(UIView *)view;{
    
    self.allView.frame = view.bounds;
    if (self.allView.superview) {
        [self.allView removeFromSuperview];
    }
    self.dismisAnimation =self.animationType;
    [view addSubview:self.allView];
    [self resetFrame:self.animationType];
    
    //防止提前泄漏
     objc_setAssociatedObject(view, &alertKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //动画
    
    switch (self.animationType) {
        case YINAlertShowAnimationFade:
        {
            [UIView animateWithDuration:.3 animations:^{
                self.contentView.alpha = 1;
            }];
           
        }
            break;
        case YINAlertShowAnimationZoomSale:
        {
            [UIView animateWithDuration:.3 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(1, 1);
            }];
            
        }
            break;
            
        default:{
            [UIView animateWithDuration:.3 animations:^{
                self.contentView.frame = self.toFrame;
            }];
        }
            break;
    }
    
    [UIView animateWithDuration:.3 animations:^{
       self.allView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    }];

}



- (void)showInView:(UIView *)view Animation:(YINAlertShowAnimation)animationType;{
    self.animationType = animationType;
    [self showInView:view];
}

//消失
- (void)dismiss;{
    
    [UIView animateWithDuration:.3 animations:^{
        [self resetFrame:self.dismisAnimation];
        self.allView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }completion:^(BOOL finished) {
        objc_setAssociatedObject(self.allView.superview, &alertKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self.allView removeFromSuperview];
    }];
}

//消失
- (void)dismissAnmation:(YINAlertShowAnimation )animationType;
{
    self.dismisAnimation = animationType;
    [self dismiss];
}

+ (instancetype)showYinAlertWithContent:(UIView *)contentView InSuperView:(UIView *)superView AnimationType:(YINAlertShowAnimation)animationType{
    
    YINAlert *alert = [[YINAlert alloc] init];
    alert.animationType = animationType;
    alert.contentView = contentView;
    alert.tapOutDismiss = YES;
    if (superView) {
        [alert showInView:superView];
    }
    
    return alert;
}

+ (UIAlertController *)systemAlertWithTitle:(NSString *)title Message:(NSString *)message AlertStyle:(UIAlertControllerStyle)style Actions:(NSArray <NSString *> *)actions ClickBlock:(void(^)(NSInteger index))block;{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    [actions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (block) {
                block(idx);
            }
        }];
        [alert addAction:action];
    }];
    return alert;
}

+ (UIAlertController *)showSystemAlertFromController:(UIViewController *)vc WithTitle:(NSString *)title Message:(NSString *)message  AlertStyle:(UIAlertControllerStyle)style  Actions:(NSArray <NSString *> *)actions ClickBlock:(void(^)(NSInteger index))block;{
    
    UIAlertController *alert = [YINAlert systemAlertWithTitle:title Message:message AlertStyle:style Actions:actions ClickBlock:block];
    
    [vc presentViewController:vc animated:YES completion:^{
        
    }];
     return alert;
}
@end
