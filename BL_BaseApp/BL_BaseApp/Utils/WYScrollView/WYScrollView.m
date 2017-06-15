//
//  WYScrollView.m
//  无忧学堂
//
//  Created by jacke－xu on 16/2/22.
//  Copyright © 2016年 jacke－xu. All rights reserved.
//

#import "WYScrollView.h"
#import "UIImageView+WebCache.h"
//#import "RPPageControl.h"

#define pageSize 16

//获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)

#define pageColor RGB(67, 199, 176)

/** 滚动宽度*/
#define ScrollWidth self.frame.size.width

/** 滚动高度*/
#define ScrollHeight self.frame.size.height

@interface WYScrollView () <UIScrollViewDelegate>

@property (nonatomic, copy) NSArray *imageArray;
//@property (nonatomic, strong, readwrite) RPPageControl *pageControl;

@end

@implementation WYScrollView
{
    __weak  UIImageView *_leftImageView,*_centerImageView,*_rightImageView;
    
    __weak  UIScrollView *_scrollView;
    
    __weak  UIPageControl *_PageControl;
    
    NSTimer *_timer;
    
    /** 当前显示的是第几个*/
    NSInteger _currentIndex;
    
    /** 图片个数*/
    NSInteger _MaxImageCount;
    
    /** 是否是网络图片*/
    BOOL _isNetworkImage;
}

#pragma mark - 本地图片

-(instancetype)initWithFrame:(CGRect)frame WithLocalImages:(NSArray *)imageArray
{
    if (imageArray.count == 0 ) {
        return nil;
    }
    self = [super initWithFrame:frame];
    if ( self) {
        
        [self setLocalImages:imageArray];
    }
    
    return self;
}

#pragma mark - 网络图片

-(instancetype)initWithFrame:(CGRect)frame WithNetImages:(NSArray *)imageArray
{
    if (imageArray.count==0) {
        return nil;
    }
    self = [super initWithFrame:frame];
    if ( self) {
        
        [self setNetImages:imageArray];
    }
    
    return self;
}

-(void)setLocalImages:(NSArray *)imageArray{

    _isNetworkImage = NO;
    
    /** 创建滚动view*/
    [self createScrollView];
    
    /** 加入本地image*/
    [self setImageArray:imageArray];
    
    /** 设置数量*/
    [self setMaxImageCount:_imageArray.count];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

-(void)setNetImages:(NSArray *)imageArray{

    _isNetworkImage = YES;

    /** 创建滚动view*/
    [self createScrollView];
    
    /** 加入本地image*/
    [self setImageArray:imageArray];
    
    /** 设置数量*/
    [self setMaxImageCount:_imageArray.count];
}

#pragma mark - 设置数量

-(void)setMaxImageCount:(NSInteger)MaxImageCount
{
    _MaxImageCount = MaxImageCount;
    
     /** 复用imageView初始化*/
    [self initImageView];
    
    /** pageControl*/
    [self createPageControl];
    
    /** 定时器*/
    [self setUpTimer];
    
    /** 初始化图片位置*/
    [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
}

- (void)createScrollView
{
    [_scrollView removeFromSuperview];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    /** 复用，创建三个*/
    scrollView.contentSize = CGSizeMake(ScrollWidth * 3, 0);
    
    /** 设置滚动延时时间*/
    _AutoScrollDelay = 0;
    
    /** 开始显示的是第一个   前一个是最后一个   后一个是第二张*/
    _currentIndex = 0;
    _scrollView = scrollView;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotify) name:@"removeTimer" object:nil];
}

//- (void)receiveNotify{
//    
//    [self setUpTimer];
//}

-(void)setImageArray:(NSArray *)imageArray
{
    //如果是网络
    if (_isNetworkImage)
    {
        _imageArray = [imageArray copy];
        
    }else {
        //本地
        NSMutableArray *localimageArray = [NSMutableArray arrayWithCapacity:imageArray.count];
        for (NSString *imageName in imageArray) {
            [localimageArray addObject:[UIImage imageNamed:imageName]];
        }
        _imageArray = [localimageArray copy];
    }
}

- (void)initImageView {
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,ScrollWidth, ScrollHeight)];
    UIImageView *centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScrollWidth, 0,ScrollWidth, ScrollHeight)];
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScrollWidth * 2, 0,ScrollWidth, ScrollHeight)];
    centerImageView.userInteractionEnabled = YES;
    [centerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTap)]];
    [_scrollView addSubview:leftImageView];
    [_scrollView addSubview:centerImageView];
    [_scrollView addSubview:rightImageView];
    _leftImageView = leftImageView;
    _centerImageView = centerImageView;
    _rightImageView = rightImageView;
}

//点击事件
- (void)imageViewDidTap
{
//     [self removeTimer];
    [self.netDelagate didSelectedNetImageAtIndex:_currentIndex];
    [self.localDelagate didSelectedLocalImageAtIndex:_currentIndex];
}

-(void)createPageControl
{
    [_PageControl removeFromSuperview];
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,ScrollHeight - pageSize-10,[UIScreen mainScreen].bounds.size.width, 8)];
    [pageControl setValue:[UIImage imageNamed:@"pic_banner_xz_"] forKeyPath:@"_pageImage"];
    [pageControl setValue:[UIImage imageNamed:@"pic_banner_xz"] forKeyPath:@"_currentPageImage"];
    //    //设置页面指示器的颜色
//    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    //设置当前页面指示器的颜色
//    pageControl.currentPageIndicatorTintColor = [UIColor grayColor];

    pageControl.numberOfPages = _MaxImageCount;
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    _PageControl = pageControl;
    
//    self.pageControl = [[RPPageControl alloc]init];
//    self.pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"pic_banner_xz_"];
//    self.pageControl.pageIndicatorImage = [UIImage imageNamed:@"椭圆-1-拷贝-2"];
//    self.pageControl.numberOfPages = _MaxImageCount;
//    self.pageControl.currentIndex = 0;
////    self.pageControl.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
//    self.pageControl.alignment = RPPageControlAlignmentCenter;
//    self.pageControl.indicatorMargin = -1;
//    [self addSubview:self.pageControl];
//    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self).offset(-10);
////        make.left.mas_equalTo(self);
//        make.bottom.mas_equalTo(self).offset(-10);
//        make.height.mas_equalTo(15);
//        make.width.mas_equalTo((_MaxImageCount-1)*4+(_MaxImageCount+2)*10+15);
//    }];
//    self.pageControl.layer.cornerRadius = 7;
//    self.pageControl.layer.masksToBounds = YES;
}

#pragma mark - 定时器

- (void)setUpTimer
{
    if (_AutoScrollDelay < 0.5) return;//太快了
    
    _timer = [NSTimer timerWithTimeInterval:_AutoScrollDelay target:self selector:@selector(scorll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)scorll
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x +ScrollWidth, 0) animated:YES];
}

#pragma mark - 给复用的imageView赋值

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex
{

    if (_isNetworkImage)
    {
        
        if (self.imageArray.count==1) {
            
            [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[0]] placeholderImage:_placeholderImage];
        }else{
            
            [_leftImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[LeftIndex]] placeholderImage:_placeholderImage];
            [_centerImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[centerIndex]] placeholderImage:_placeholderImage];
            [_rightImageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[rightIndex]] placeholderImage:_placeholderImage];
        }
        
    }else
    {
        if (self.imageArray.count==1) {
            
            _centerImageView.image = _imageArray[centerIndex];
            
        }else{
            
            _leftImageView.image = _imageArray[LeftIndex];
            _centerImageView.image = _imageArray[centerIndex];
            _rightImageView.image = _imageArray[rightIndex];
        }
        
    }

    [_scrollView setContentOffset:CGPointMake(ScrollWidth, 0)];
}

#pragma mark - 滚动代理

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setUpTimer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}


- (void)removeTimer
{
    if (_timer == nil) return;
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //开始滚动，判断位置，然后替换复用的三张图
    [self changeImageWithOffset:scrollView.contentOffset.x];
}

- (void)changeImageWithOffset:(CGFloat)offsetX
{
    if (offsetX >= ScrollWidth * 2)
    {
        _currentIndex++;
        
        if (_currentIndex == _MaxImageCount-1)
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else if (_currentIndex == _MaxImageCount)
        {
            
            _currentIndex = 0;
            
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else
        {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        _PageControl.currentPage = _currentIndex;
//        self.pageControl.currentIndex = _currentIndex;
        
    }
    
    if (offsetX <= 0)
    {
        _currentIndex--;
        
        if (_currentIndex == 0) {
            
            [self changeImageLeft:_MaxImageCount-1 center:0 right:1];
            
        }else if (_currentIndex == -1) {
            
            _currentIndex = _MaxImageCount-1;
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:0];
            
        }else {
            [self changeImageLeft:_currentIndex-1 center:_currentIndex right:_currentIndex+1];
        }
        
        _PageControl.currentPage = _currentIndex;
//        self.pageControl.currentIndex = _currentIndex;
    }
}

-(void)dealloc
{
    [self removeTimer];
}

#pragma mark - set方法，设置间隔时间

- (void)setAutoScrollDelay:(NSTimeInterval)AutoScrollDelay
{
    _AutoScrollDelay = AutoScrollDelay;
    
    [self removeTimer];
    [self setUpTimer];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
