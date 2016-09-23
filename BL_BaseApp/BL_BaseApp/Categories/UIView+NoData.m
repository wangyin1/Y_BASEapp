//
//  UIView+NoData.m
//  BL_BaseApp
//
//  Created by BL_xinYin on 16/9/12.
//  Copyright © 2016年 王印. All rights reserved.
//


#import <objc/runtime.h>
#import "UIView+NoData.h"
#import "UIColor+Extension.h"
@interface UIView ()

@end

@implementation UIView (NoData)

- (void)showNoDataView
{
    [self removeNoDataView];
    if (!self.nodataView) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"暂无内容";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor hexColor:@"363636"];
        self.nodataView = label;
    }
    [self addSubview:self.nodataView];
    [self.nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
}

- (void)removeNoDataView
{
    [self.nodataView removeFromSuperview];
}

- (UIView *)nodataView
{

    return objc_getAssociatedObject(self, @selector(nodataView));
}
- (void)setNodataView:(UIView *)nodataView{
    
    objc_setAssociatedObject(self, @selector(nodataView), nodataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
