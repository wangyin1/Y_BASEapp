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
#import "MJRefresh.h"
@interface UIView ()

@end

@implementation UIView (NoData)

- (void)showNoDataView
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    });
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


@implementation UITableView (NoData)

- (void)setAutoShowNoData:(BOOL)autoShowNoData{

    objc_setAssociatedObject(self, @selector(autoShowNoData), @(autoShowNoData), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    __weak typeof(self)weakSelf = self;
    [self setMj_reloadDataBlock:^(NSInteger totalDataCount) {
        [weakSelf checkData];
    }];
    [self reloadData];
    
}

- (BOOL)autoShowNoData{
      return [objc_getAssociatedObject(self, @selector(autoShowNoData)) boolValue];
}

- (void)checkData{
    
    if (self.autoShowNoData) {
      
        if (self.mj_totalDataCount>0) {
            [self removeNoDataView];
        }else{
            [self showNoDataView];
        }
    }
}

@end


@implementation UICollectionView (NoData)

- (void)setAutoShowNoData:(BOOL)autoShowNoData{
    objc_setAssociatedObject(self, @selector(autoShowNoData), @(autoShowNoData), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    __weak typeof(self)weakSelf = self;
    [self setMj_reloadDataBlock:^(NSInteger totalDataCount) {
        [weakSelf checkData];
    }];
    [self reloadData];
}

- (BOOL)autoShowNoData{
    return [objc_getAssociatedObject(self, @selector(autoShowNoData)) boolValue];
}
- (void)checkData{
    if (self.autoShowNoData) {
        if (self.mj_totalDataCount>0) {
            [self removeNoDataView];
        }else{
            [self showNoDataView];
        }
    }
}

@end
