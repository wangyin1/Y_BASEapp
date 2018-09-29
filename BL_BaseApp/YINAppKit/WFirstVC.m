//
//  WFirstVC.m
//  yipingcang
//
//  Created by 王印 on 16/2/26.
//  Copyright © 2016年 王印. All rights reserved.
//
#import "SMPageControl.h"
#import "WFirstVC.h"



@interface WFirstVC ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView     *scrollView;
@property(nonatomic,strong)SMPageControl        *pageControl;
@end

@implementation WFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];

}






- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWith, ScreenHight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(3*_scrollView.bounds.size.width, _scrollView.bounds.size.height);
        for (int i = 0; i< 3; i++) {
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i*_scrollView.bounds.size.width, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
            imageV.contentMode = 2;
            imageV.clipsToBounds = YES;
            imageV.image = [UIImage imageNamed:[@"app" stringByAppendingFormat:@"%d",i]];
            imageV.backgroundColor = [UIColor colorWithRed:arc4random()%1 green:arc4random()%1 blue:arc4random()%1 alpha:arc4random()%1];
            [_scrollView addSubview:imageV];
        }
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(2.5*_scrollView.bounds.size.width- 60, _scrollView.bounds.size.height-80, 120, 40);
        [button setTitle:@"立即体验" forState:0];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        button.tintColor = [UIColor whiteColor];
        ViewBorderRadius(button,4,2,[UIColor whiteColor]);
        [button addTarget:self action:@selector(lookApp) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
    }
    return _scrollView;
}

- (SMPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[SMPageControl alloc]initWithFrame:CGRectMake(ScreenWith/2.f-30, ScreenHight-50, 60, 30)];
        _pageControl.pageIndicatorImage = [UIImage imageNamed:@"point1"];
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorImage =  [UIImage imageNamed:@"point"];
    }
    return _pageControl;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.hidden = scrollView.contentOffset.x>1.5*scrollView.bounds.size.width;
    self.pageControl.currentPage = scrollView.contentOffset.x/ScreenWith;
}

//进入app
- (void)lookApp{
    
    NSString *nowVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //写入持久化
    [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:nowVersion];
    
    //进入登录页面
    [MYAPP setWindowRootViewController];
}

@end
