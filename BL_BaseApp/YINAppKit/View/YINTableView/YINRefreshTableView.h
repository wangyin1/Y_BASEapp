//
//  YINRefreshTableView.h
//  BL_BaseApp
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 王印. All rights reserved.
//

#import "YINTableView.h"
#import <UIKit/UIKit.h>

@class YINRefreshTableView;

@protocol  YINRefreshTableViewDelegate<NSObject>

@required
//加载页码事件
- (void)yinRefreshTableView:(YINRefreshTableView *)tableView loadingDataWithPage:(NSInteger)page isRefresh:(BOOL)isRefresh;
@optional
//无数据展示ui 也可以通过属性直接赋值
- (UIView *)errorViewForYinRefreshTableView:(YINRefreshTableView *)tableView;
@end

@interface YINRefreshTableView : YINTableView

//根据列表数据自动显示无数据 错误ui 默认为YES
@property (assign,nonatomic) BOOL  autoError;

//手动展示无数据 错误页面
- (void)showErrorView;
- (void)removeErrorView;

//自定义无数据 错误页面UI
@property(nonatomic,strong)UIView       *errorView;

//当前页数 获取到网络数据后对其赋值
@property (assign,nonatomic) NSInteger      tableViewCurrentPage;

@property (weak,nonatomic) id<YINRefreshTableViewDelegate>  refreshDelegate;

@end
