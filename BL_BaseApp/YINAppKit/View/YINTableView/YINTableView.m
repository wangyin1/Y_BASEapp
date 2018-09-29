//
//  YINTableView.m
//  BL_BaseApp
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 王印. All rights reserved.
//

#import "YINTableView.h"

@implementation YINTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tableFooterView = [UIView new];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableFooterView = [UIView new];
    }
    return self;
}

@end
