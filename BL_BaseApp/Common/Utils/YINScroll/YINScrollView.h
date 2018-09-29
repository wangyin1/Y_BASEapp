//
//  YINScrollView.h
//  BL_BaseApp
//
//  Created by apple on 2017/10/21.
//  Copyright © 2017年 王印. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SMPageControl.h"


@class YINScrollView;

@protocol YINScrollViewDelegate <NSObject>

@optional

- (void)yINScrollView:(YINScrollView *)scrollView didClickItem:(UIView *)item index:(NSInteger)index;

- (NSInteger)numberOfItemsForYINScrollView:(YINScrollView *)scrollView;

- (UIView *)yINScrollView:(YINScrollView *)scrollView itemForIndex:(NSInteger)index;

@end

typedef void(^YINItemClickBlock)(NSInteger index);

//滑动方向枚举
typedef NS_ENUM(NSUInteger, YINScrollOrientation) {
    YINScrollOrientationHorizontal,//横
    YINScrollOrientationVertical,//竖
};

//pagecontroll位置 只有横向生效
typedef NS_ENUM(NSUInteger, YINScrollPageControlPostion) {
    YINScrollPageControlPostionBottomCenter,
    YINScrollPageControlPostionCenter,
    YINScrollPageControlPostionTopCenter,
    YINScrollPageControlPostionTopLeft,
    YINScrollPageControlPostionTopRight,
    YINScrollPageControlPostionBottomLeft,
    YINScrollPageControlPostionBottomRight,
};

@interface YINScrollView : UIView



@property(nonatomic,strong)UIScrollView     *scrollView;

@property(nonatomic,assign)YINScrollPageControlPostion       pageControlPostion;

@property(nonatomic,strong)SMPageControl      *pageControl;

@property(nonatomic,assign)BOOL     autoLoop;

@property(nonatomic,assign)CGFloat  autoScrollDelay;

//当前显示的视图所占bound的比例 默认为1
@property (assign,nonatomic) CGFloat  centerRatio;

- (void)showItemIndex:(NSInteger)index;



//滑动方向
@property(nonatomic,assign)YINScrollOrientation     orientation;//默认为横向

@property(nonatomic,weak)id  <YINScrollViewDelegate>   delegate;

//加载图片 网络地址或者uiimage
- (void)loadImages:(NSArray *)images;
//加载图片 并且实现点击回调
- (void)loadImages:(NSArray *)images ImageClickBlock:(YINItemClickBlock)block;
//调用刷新显示  代理实现
- (void)reload;

@end
