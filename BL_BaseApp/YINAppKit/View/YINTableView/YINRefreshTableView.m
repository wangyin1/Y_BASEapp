//
//  YINRefreshTableView.m
//  BL_BaseApp
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 王印. All rights reserved.
//
#import "MJRefresh.h"
#import "YINRefreshTableView.h"

@interface YINRefreshTableView()

@end

@implementation YINRefreshTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addHeaderFooter];
        
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addHeaderFooter];
    }
    return self;
}



- (void)setAutoError:(BOOL)autoError{
    __weak typeof(self)weakSelf = self;
    _autoError = autoError;
    [self setMj_reloadDataBlock:^(NSInteger totalDataCount) {
        [weakSelf checkData];
    }];
    [self reloadData];
}
- (void)checkData{
    if (self.autoError) {
        if (self.mj_totalDataCount>0) {
            [self removeErrorView];
        }else{
            [self showErrorView];
        }
    }
}

- (void)showErrorView{
    [self removeErrorView];
    if (self.refreshDelegate&&[self.refreshDelegate respondsToSelector:@selector(errorViewForYinRefreshTableView:)]) {
        if (![self.errorView isEqual:[self.refreshDelegate errorViewForYinRefreshTableView:self]]) {
            self.errorView = [self.refreshDelegate errorViewForYinRefreshTableView:self];
        }
    }
    if (!self.errorView) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"暂无内容";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor hexColor:@"363636"];
        self.errorView = label;
    }
    [self addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0);
    }];
}



- (void)removeErrorView{
    [self.errorView removeFromSuperview];
}

- (void)addHeaderFooter{
    __weak typeof (self)weakSelf = self;
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.refreshDelegate) {
            [weakSelf.refreshDelegate yinRefreshTableView:weakSelf loadingDataWithPage:1 isRefresh:YES];
        }
    }];
    [(MJRefreshNormalHeader *)self.mj_header setTitle:@"" forState:MJRefreshStateIdle];
    [(MJRefreshNormalHeader *)self.mj_header setTitle:@"" forState:MJRefreshStatePulling];
    [(MJRefreshNormalHeader *)self.mj_header setTitle:@"" forState:MJRefreshStateRefreshing];
    [(MJRefreshNormalHeader *)self.mj_header setTitle:@"" forState:MJRefreshStateWillRefresh];
    
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.refreshDelegate) {
            [weakSelf.refreshDelegate yinRefreshTableView:weakSelf loadingDataWithPage:weakSelf.tableViewCurrentPage+1 isRefresh:NO];
        }
    }];
    [(MJRefreshAutoNormalFooter *)self.mj_footer setTitle:@"" forState:MJRefreshStateIdle];
    [(MJRefreshAutoNormalFooter *)self.mj_footer setTitle:@"" forState:MJRefreshStatePulling];
    [(MJRefreshAutoNormalFooter *)self.mj_footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [(MJRefreshAutoNormalFooter *)self.mj_footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    self.autoError = YES;
}

@end
