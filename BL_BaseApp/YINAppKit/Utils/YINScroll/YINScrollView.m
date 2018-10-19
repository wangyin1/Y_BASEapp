//
//  YINScrollView.m
//  BL_BaseApp
//
//  Created by apple on 2017/10/21.
//  Copyright © 2017年 王印. All rights reserved.
//

#import "YINScrollView.h"

@interface YINScrollView()<UIScrollViewDelegate>

@property(nonatomic,strong)NSMutableArray     *items;

@property(nonatomic,assign)NSInteger        currentIndex;

@property(nonatomic,copy)YINItemClickBlock      clickBlock;

@property(nonatomic,strong)NSTimer      *timer;

@property(nonatomic,assign)BOOL         touch;
@end


@implementation YINScrollView
- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}
- (void)setCenterRatio:(CGFloat)centerRatio{
    _centerRatio = centerRatio;
    
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self addSubview:self.scrollView];
    if (self.autoScrollDelay==0) {
        self.autoScrollDelay = 3;
    }
    [self.scrollView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self setUpTimer];
    NSUInteger totalNumber = self.items.count;
    if (totalNumber==0) {
        if (!self.delegate) {
            return;
        }
        if ([self.delegate numberOfItemsForYINScrollView:self]==0) {
            return;
        }
        totalNumber = [self.delegate numberOfItemsForYINScrollView:self];
    }
    if (totalNumber==1) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }else if (totalNumber>1){
        
        self.scrollView.contentSize = CGSizeMake((self.orientation==YINScrollOrientationHorizontal?3:1)*(self.scrollView.frame.size.width), (self.orientation==YINScrollOrientationVertical?3:1)*self.scrollView.frame.size.height);
    }
    [self addSubview:self.pageControl];
    
    if (self.pageControlPostion==0) {
        [self setPageControlPostion:YINScrollPageControlPostionBottomCenter];
    }
    if (self.delegate) {
        [self reload];
    }
}


- (void)setPageControlPostion:(YINScrollPageControlPostion)pageControlPostion{
    
    if (!self.pageControl.superview) {
        [self addSubview:self.pageControl];
    }
    _pageControlPostion = pageControlPostion;
    switch (pageControlPostion) {
        case YINScrollPageControlPostionCenter:
        {
            [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(@0);
                make.width.equalTo(@300);
                make.height.equalTo(@30);
            }];
        }
            break;
        case YINScrollPageControlPostionTopLeft:{
            
            [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@0);
                make.left.equalTo(@0);
                make.width.equalTo(@300);
                make.height.equalTo(@30);
            }];
        }
            
            
            break;
        case YINScrollPageControlPostionTopRight:{
            
            [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@0);
                make.right.equalTo(@0);
                make.width.equalTo(@300);
                make.height.equalTo(@30);
            }];
        }
            
            
            break;
        case YINScrollPageControlPostionTopCenter:{
            
            [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@0);
                make.centerX.equalTo(@0);
                make.width.equalTo(@300);
                make.height.equalTo(@30);
            }];
        }
            
            
            break;
        case YINScrollPageControlPostionBottomLeft:{
            
            [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@0);
                make.left.equalTo(@0);
                make.width.equalTo(@300);
                make.height.equalTo(@30);
            }];
        }
            
            
            break;
        case YINScrollPageControlPostionBottomRight:{
            
            [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@0);
                make.right.equalTo(@0);
                make.width.equalTo(@300);
                make.height.equalTo(@30);
            }];
        }
            
            
            break;
        case YINScrollPageControlPostionBottomCenter:{
            
            [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@0);
                make.centerX.equalTo(@0);
                make.width.equalTo(@300);
                make.height.equalTo(@30);
            }];
        }
            
            break;
        default:
            break;
    }
    
}
- (void)setOrientation:(YINScrollOrientation)orientation{
    _orientation = orientation;
    self.pageControl.hidden = orientation==YINScrollOrientationVertical;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
}



- (void)setCurrentIndex:(NSInteger)currentIndex{
    
    _currentIndex = currentIndex;
    weakify(self);
    NSUInteger totalNumber = self.items.count;
    if (totalNumber==0) {
        if (!self.delegate) {
            return;
        }
        if ([self.delegate numberOfItemsForYINScrollView:self]==0) {
            return;
        }
        totalNumber = [self.delegate numberOfItemsForYINScrollView:self];
    }
    
    if (totalNumber==1) {
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }else{
        
        self.scrollView.contentSize = CGSizeMake((self.orientation==YINScrollOrientationHorizontal?3:1)*(self.scrollView.frame.size.width), (self.orientation==YINScrollOrientationVertical?3:1)*self.scrollView.frame.size.height);
    }
    
    if (totalNumber==1) {
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
        [self.scrollView addSubview:self.items.count>0?imageV:[self.delegate yINScrollView:self itemForIndex:0]];
        if (self.items.count>0) {
            [self loadImageWithData:self.items[0] ForImageView:(UIImageView *)imageV ];
        }
        [self.scrollView.subviews.firstObject addGestureRecognizer:tap];
        [self.scrollView.subviews.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(weak_self.scrollView);
            make.height.equalTo(weak_self.scrollView);
        }];
    }else if(totalNumber>1){
        
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
        
        //左
        NSInteger index = currentIndex==0?(totalNumber-1):(currentIndex-1);
        UIView *left = [self.items count]>index?imageV:[self.delegate yINScrollView:self itemForIndex:index];
        if (self.items.count>index) {
            [self loadImageWithData:self.items[index] ForImageView:(UIImageView *)left ];
        }
        [self.scrollView addSubview:left];
        [left addGestureRecognizer:tap];
        [left mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.width.equalTo(weak_self.scrollView);
            make.height.equalTo(weak_self.scrollView);
        }];
        
        UIImageView *imageVCenter = [[UIImageView alloc] init];
        imageVCenter.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapCenter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
        UIView *center = self.items.count>currentIndex?imageVCenter:[self.delegate yINScrollView:self itemForIndex:currentIndex];
        if (self.items.count>currentIndex) {
            [self loadImageWithData:self.items[currentIndex] ForImageView:(UIImageView *)center ];
        }
        [center addGestureRecognizer:tapCenter];
        //中
        [self.scrollView addSubview:center];
        
        [center mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weak_self.orientation==YINScrollOrientationHorizontal?left.mas_right:@0);
            make.top.equalTo(weak_self.orientation==YINScrollOrientationVertical?left.mas_bottom:@0);
            make.width.equalTo(weak_self.scrollView);
            make.height.equalTo(weak_self.scrollView);
        }];
        //右
        if (totalNumber==2) {
            UIImageView *imageVR = [[UIImageView alloc] init];
            imageVR.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
            NSInteger indexR = currentIndex==0?1:0;
            UIView *view =  self.items.count>indexR?imageVR:[self.delegate yINScrollView:self itemForIndex:indexR];
            if (self.items.count>indexR) {
                [self loadImageWithData:self.items[indexR] ForImageView:(UIImageView *)view ];
            }
            [view addGestureRecognizer:tapr];
            [self.scrollView addSubview:view];
            
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weak_self.orientation==YINScrollOrientationHorizontal?@0:center.mas_bottom);
                make.left.equalTo(weak_self.orientation==YINScrollOrientationVertical?@0:center.mas_right);
                make.width.equalTo(weak_self.scrollView);
                make.height.equalTo(weak_self.scrollView);
            }];
            
        }else{
            UIImageView *imageVR = [[UIImageView alloc] init];
            imageVR.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickItem:)];
            NSUInteger indexR = (currentIndex==totalNumber-1)?0:(currentIndex+1);
            UIView *view = self.items.count>indexR?imageVR:[self.delegate yINScrollView:self itemForIndex:indexR];
            if (self.items.count>indexR) {
                [self loadImageWithData:self.items[indexR] ForImageView:(UIImageView *)view ];
            }
            [view addGestureRecognizer:tapr];
            [self.scrollView addSubview:view];
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weak_self.orientation==YINScrollOrientationHorizontal?@0:center.mas_bottom);
                make.left.equalTo(weak_self.orientation==YINScrollOrientationVertical?@0:center.mas_right);
                make.width.equalTo(weak_self.scrollView);
                make.height.equalTo(weak_self.scrollView);
            }];
            
        }
    }
    
    if (self.orientation==YINScrollOrientationHorizontal) {
        [self.scrollView setContentOffset:CGPointMake(totalNumber==1?0:self.scrollView.frame.size.width, 0) animated:NO];
    }else{
        [self.scrollView setContentOffset:CGPointMake(0,totalNumber==1?0:self.scrollView.frame.size.height) animated:NO];
    }
    [self layoutScale];
    self.pageControl.currentPage = currentIndex;
}

//根据配置缩放显示
- (void)layoutScale{
//    NSUInteger totalNumber = self.items.count;
//    if (totalNumber==0) {
//        if (!self.delegate) {
//            return;
//        }
//        if ([self.delegate numberOfItemsForYINScrollView:self]==0) {
//            return;
//        }
//        totalNumber = [self.delegate numberOfItemsForYINScrollView:self];
//    }
//    if (totalNumber==1) {
//
//
//
//    }else{
//
//    }
}

- (UIView *)copyView:(UIView *)view{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (void)loadImageWithData:(id)data ForImageView:(UIImageView *)imageV{
    if ([data isKindOfClass:[NSString class]]) {
        
        [imageV sd_setImageWithURL:[NSURL URLWithString:data] placeholderImage:[UIImage imageNamed:data]];
        
    }else if([data isKindOfClass:[UIImage class]]){
        imageV.image = data;
    }
}


//加载图片 网络地址或者uiimage
- (void)loadImages:(NSArray *)images;{
    [self.items removeAllObjects];
    
    for (id object in images) {
        
        [self.items addObject:object];
        
    }
    
    self.pageControl.numberOfPages = images.count;
    [self setUpTimer];
    self.currentIndex = 0;
}


//加载图片 并且实现点击回调
- (void)loadImages:(NSArray *)images ImageClickBlock:(YINItemClickBlock)block{
    [self loadImages:images];
    self.clickBlock = block;
}


//调用刷新显示  代理实现
- (void)reload{
    if (!self.delegate) {
        return;
    }
    if (![self.delegate respondsToSelector:@selector(numberOfItemsForYINScrollView:)]) {
        return;
    }
    NSInteger number = [self.delegate numberOfItemsForYINScrollView:self];
    [self.items removeAllObjects];
    
    self.pageControl.numberOfPages = number;
    
    self.currentIndex = 0;
}

- (void)setAutoLoop:(BOOL)autoLoop{
    _autoLoop = autoLoop;
    if (self.timer) {
        self.timer.fireDate = autoLoop?[NSDate distantPast]:[NSDate distantFuture];
    }
}

- (void)setUpTimer
{
    if (_autoScrollDelay==0) {
        _autoScrollDelay = 4;
    }
    //    if (self.autoScrollDelay < 0.5) return;//太快了
    if (!self.timer) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSTimer  *timer = [NSTimer scheduledTimerWithTimeInterval:MAX(1, _autoScrollDelay) target:self selector:@selector(scorll) userInfo:nil repeats:YES];
            timer.fireDate = [NSDate distantPast];
            self.timer = timer;
        });
        
    }
}

- (void)scorll
{
    if (self.scrollView.subviews.count<2) {
        return;
    }
    if (self.orientation==YINScrollOrientationHorizontal) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x +_scrollView.frame.size.width, 0) animated:YES];
    }else{
        [_scrollView setContentOffset:CGPointMake(0, _scrollView.contentOffset.y +_scrollView.frame.size.height) animated:YES];
    }
}

- (void)clickItem:(UITapGestureRecognizer *)sender{
    if (self.clickBlock) {
        self.clickBlock(self.currentIndex);
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(yINScrollView:didClickItem:index:)]) {
        [self.delegate yINScrollView:self didClickItem:nil index:_currentIndex];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self changeImageWithOffset:self.orientation==YINScrollOrientationHorizontal?scrollView.contentOffset.x:scrollView.contentOffset.y];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.timer.fireDate = [NSDate distantFuture];
}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
//    if (self.touch) {
//        return;
//    }
//    scrollView.userInteractionEnabled = YES;
//    int hpage = (int)roundf(scrollView.contentOffset.x/((scrollView.frame.size.width)+0.01));
//    int vpage = (int)roundf(scrollView.contentOffset.y/((scrollView.frame.size.height)+0.01));
//
//    NSUInteger totalNumber = self.items.count;
//    if (totalNumber==0) {
//        if (!self.delegate) {
//            return;
//        }
//        if ([self.delegate numberOfItemsForYINScrollView:self]==0) {
//            return;
//        }
//        totalNumber = [self.delegate numberOfItemsForYINScrollView:self];
//    }
//    if (totalNumber==0) {
//        return;
//    }
//    NSInteger page = _currentIndex;
//    if (totalNumber==1) {
//
//    }else{
//        if (MAX(vpage, hpage)==2) {
//            page = _currentIndex==(totalNumber-1)?0:_currentIndex+1;
//        }else if (MAX(vpage, hpage)==0){
//            page = _currentIndex==0?totalNumber-1:_currentIndex-1;
//        }
//    }
//    if (page!=_currentIndex) {
//        [self setCurrentIndex:page];
//    }
//}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:MAX(1, _autoScrollDelay)];
}

- (void)changeImageLeft:(NSInteger)LeftIndex center:(NSInteger)centerIndex right:(NSInteger)rightIndex
{
    
    [self setCurrentIndex:centerIndex];
    
}


- (void)changeImageWithOffset:(CGFloat)offsetX
{
    
    NSUInteger totalNumber = self.items.count;
    if (totalNumber==0) {
        if (!self.delegate) {
            return;
        }
        if ([self.delegate numberOfItemsForYINScrollView:self]==0) {
            return;
        }
        totalNumber = [self.delegate numberOfItemsForYINScrollView:self];
    }
    if (totalNumber==0) {
        return;
    }
    NSInteger _MaxImageCount = totalNumber;
    
    CGFloat ScrollWidth = self.orientation==YINScrollOrientationHorizontal? self.scrollView.frame.size.width:self.scrollView.frame.size.height;
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
        
        
        //        self.pageControl.currentIndex = _currentIndex;
    }
}

- (void)showItemIndex:(NSInteger)index{
    NSUInteger totalNumber = self.items.count;
    if (totalNumber==0) {
        if (!self.delegate) {
            return;
        }
        if ([self.delegate numberOfItemsForYINScrollView:self]==0) {
            return;
        }
        totalNumber = [self.delegate numberOfItemsForYINScrollView:self];
    }
    if (index>=0&&index<totalNumber) {
        self.currentIndex = index;
    }
}




- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (SMPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        _pageControl.pageIndicatorTintColor = [UIColor groupTableViewBackgroundColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
        [_pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (void)pageChange:(SMPageControl *)contrl{
    self.currentIndex = contrl.currentPage;
}

-(NSMutableArray *)items{
    if (!_items) {
        _items = @[].mutableCopy;
    }
    return _items;
}
@end

