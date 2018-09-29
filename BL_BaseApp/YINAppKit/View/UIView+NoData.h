//
//  UIView+NoData.h
//  BL_BaseApp
//
//  Created by BL_xinYin on 16/9/12.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface UIView (NoData)

/**
 显示无数据
 */
- (void)showNoDataView;

/**
 移除
 */
- (void)removeNoDataView;

//可定制的无数据视图 默认为显示暂无数据label
//居中显示
@property(nonatomic,strong)UIView       *nodataView;

@end


//依赖与mjrefresh
@interface UITableView (NoData)

@property(nonatomic,assign)BOOL     autoShowNoData;//自动显示隐藏无数据视图 根据协议返回的section个数以及cell个数联合判断 （默认为NO，需要手动调用showNoDataView显示）
@end

//依赖与mjrefresh
@interface UICollectionView (NoData)

@property(nonatomic,assign)BOOL     autoShowNoData;//自动显示隐藏无数据视图 根据协议返回的section个数以及cell个数联合判断 （默认为NO，需要手动调用showNoDataView显示）
@end
