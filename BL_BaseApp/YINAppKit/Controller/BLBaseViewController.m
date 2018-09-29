//
//  BLBaseViewController.m
//  BL_BaseApp
//
//  Created by 王印 on 16/7/22.
//  Copyright © 2016年 王印. All rights reserved.
//
#import "Aspects.h"
#import "BLBaseViewController.h"
#import "BLWebViewController.h"
#import "AppDelegate.h"




@interface BLBaseViewController ()

@property(nonatomic,strong)UIView       *loadAnimationView;

@property(nonatomic,assign)NSInteger         fristLoad;

@property(nonatomic,strong)UIView           *netNoEableView;
    
 @property(nonatomic,weak)UIView     *navLine;
    
    
@end

@implementation BLBaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.fristLoad = 0;
        self.navagationBarTextColor = [UIColor whiteColor];
        self.navagationBarColor = [UIColor colorWithRed:16/255.f green:31/255.f blue:65/255.f alpha:1];
        self.screenOrientation = UIInterfaceOrientationMaskPortrait;
    }
    return self;
}


- (void)aviewDidLoadFinish{
    if (self.fristLoad!=0) {
        return;
    }
    if ([self respondsToSelector:@selector(viewDidLoadFinish)]) {
        [self viewDidLoadFinish];
    }
}



- (UIView *)netNoEableView{
    if (!_netNoEableView) {
        _netNoEableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        _netNoEableView.backgroundColor = [UIColor grayColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _netNoEableView.frame.size.width-10, _netNoEableView.frame.size.height)];
        label.text = NetErrorMessage;
        label.textColor = [UIColor redColor];
        label.font = [UIFont boldSystemFontOfSize:15];
        [_netNoEableView addSubview:label];
    }
    return _netNoEableView;
}

- (UIView *)loadAnimationView{
    if (!_loadAnimationView) {
        _loadAnimationView = [[UIView alloc]initWithFrame:self.view.frame];
        _loadAnimationView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UIActivityIndicatorView * activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.center = self.view.center;
        [activity startAnimating];
        [_loadAnimationView addSubview:activity];
        UILabel *  label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        label.textAlignment = 1;
        label.center =CGPointMake(activity.center.x, activity.center.y+40);
        label.textColor = [UIColor grayColor];
        label.text = @"正在加载...";
        label.font = [UIFont systemFontOfSize:13];
        [_loadAnimationView addSubview:label];
        
    }
    return _loadAnimationView;
}

- (void)setNavLargeTitleMode:(BOOL)openLargeTitleeMode{
    
    _navLargeTitleMode = openLargeTitleeMode;
    
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = openLargeTitleeMode;
        self.navigationItem.largeTitleDisplayMode = openLargeTitleeMode?UINavigationItemLargeTitleDisplayModeAlways:UINavigationItemLargeTitleDisplayModeNever;
    } else {
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *back = [[UIBarButtonItem alloc]init];
    back.title = @"";
    self.navigationItem.backBarButtonItem = back;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(atextDidChange)name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(atextDidChange)name:UITextViewTextDidChangeNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationNetStatusChange) name:AFNetworkingReachabilityDidChangeNotification object:nil];
//    [self.navigationController aspect_hookSelector:@selector(pushViewController:animated:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
//
//    } error:nil];
    weakify(self)
    [self.navigationController aspect_hookSelector:@selector(popViewControllerAnimated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
        BLBaseViewController *vc = ((UINavigationController *)info.instance).viewControllers[ ((UINavigationController *)info.instance).viewControllers.count-2];
        [weak_self changeColorWithViewController:vc];
    } error:nil];
    [self.navigationController aspect_hookSelector:@selector(pushViewController:animated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
        UIViewController  *vc = info.arguments.firstObject;
        if ([vc isKindOfClass:[BLBaseViewController class]]) {
            [weak_self changeColorWithViewController:(BLBaseViewController *)vc];
        }
    } error:nil];
    [self.navigationController aspect_hookSelector:@selector(popToRootViewControllerAnimated:) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
        BLBaseViewController *vc = ((UINavigationController *)info.instance).viewControllers.firstObject;
        [weak_self changeColorWithViewController:vc];
    } error:nil];
}
    
- (void)changeColorWithViewController:(BLBaseViewController *)vc{
    self.navigationController.navigationBar.barTintColor = vc.navagationBarColor?: [UIColor blackColor];
    self.navigationController.navigationBar.tintColor =vc.navagationBarTextColor?: [UIColor whiteColor];
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:vc.navagationBarTextColor?:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.largeTitleTextAttributes = attributes;
    } else {
        // Fallback on earlier versions
    }
}

- (void)notificationNetStatusChange{
    weakify(self);
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (status==AFNetworkReachabilityStatusNotReachable) {
        [weak_self showNetError];
    }else{
        [weak_self hidenNetError];
    }
    if ([weak_self respondsToSelector:@selector(netStatusChange:)]) {
        [weak_self netStatusChange:status];
    }
}


- (void)atextDidChange{
    if ([self respondsToSelector:@selector(textDidChange)]) {
        [self textDidChange];
    }
}


//- (void)setRefreshView:(UIScrollView *)refreshView
//{
//    if (_refreshView!=refreshView) {
//        _refreshView = refreshView;
//        WEAKSELF
//        refreshView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [weakSelf headerRefreshRefreshView:refreshView];
//        }];
//        
//        refreshView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//            [weakSelf footerRefreshRefreshView:refreshView];
//        }];
//    }
//}



- (void)showNetError{
    if (!self.netNoEableView.superview) {
        [self.view addSubview:self.netNoEableView];
        weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weak_self hidenNetError];
        });
    }
}


- (void)hidenNetError{
    if (self.netNoEableView.superview) {
        [self.netNoEableView removeFromSuperview];
    }
}

////下拉刷新
//- (void)headerRefreshRefreshView:(UIScrollView *)view{
//    NSLog(@"刷新");
//    
//}
////上拉加载更多
//- (void)footerRefreshRefreshView:(UIScrollView *)view{
//    NSLog(@"加载更多");
//}


- (void)showLoad{
    [self.loadAnimationView.layer removeFromSuperlayer];
    [self.view.layer addSublayer:self.loadAnimationView.layer];
}

- (void)hidenLoad{
    [self.loadAnimationView.layer removeFromSuperlayer];
}

- (UIImage *)createImageColor:(UIColor *)color size:(CGSize)size {
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    //绘制颜色区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [color setFill];
    [path fill];
    //    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    CGContextSetFillColorWithColor(ctx, color.CGColor);
    //    CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));
    //从图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [(AppDelegate *)[UIApplication sharedApplication].delegate setOrientation:self.screenOrientation];
    NSNumber *orientationTarget = [NSNumber numberWithInt:self.screenOrientation== UIInterfaceOrientationMaskLandscapeLeft?UIInterfaceOrientationLandscapeLeft:(self.screenOrientation==UIInterfaceOrientationMaskLandscapeRight?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait)];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    if (self.navagationBarLucency) {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        
    }else{
        UIImage *imag = nil;
        [self.navigationController.navigationBar setBackgroundImage:imag forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    if (self.navagationBarLucency||self.navagationBarHiden) {
        
        self.edgesForExtendedLayout = UIRectEdgeTop;
        
        self.navigationController.navigationBar.translucent = YES;
    }
    
    if (self.navagationBarHiden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if(!self.navLine){
        self.navLine = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    }
    self.navLine.hidden = self.navagationBarShadowLineHiden;
    [self changeColorWithViewController:self];
    [self setNavLargeTitleMode:self.navLargeTitleMode];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
   
}

- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.screenOrientation;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:self.screenOrientation== UIInterfaceOrientationMaskLandscapeLeft?UIInterfaceOrientationLandscapeLeft:(self.screenOrientation==UIInterfaceOrientationMaskLandscapeRight?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait)];
    return orientationTarget.integerValue;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [(AppDelegate *)[UIApplication sharedApplication].delegate setOrientation:self.screenOrientation];
    NSNumber *orientationTarget = [NSNumber numberWithInt:self.screenOrientation== UIInterfaceOrientationMaskLandscapeLeft?UIInterfaceOrientationLandscapeLeft:(self.screenOrientation==UIInterfaceOrientationMaskLandscapeRight?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait)];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    if (self.fristLoad==0) {
        [self aviewDidLoadFinish];
    }
    self.fristLoad+=1;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)setNavagationBarLucency:(BOOL)navagationBarLucency
{
    _navagationBarLucency = navagationBarLucency;
    if (navagationBarLucency) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        
    }else{
        //配置navagationbar的属性
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
        
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.navagationBarLucency||self.navagationBarHiden) {
        
        self.edgesForExtendedLayout = UIRectEdgeTop;
        
    }
    if(!self.navLine){
        self.navLine = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    }
    self.navLine.hidden = self.navagationBarShadowLineHiden;
    
}

- (void)setNavagationBarHiden:(BOOL)navagationBarHiden{
    _navagationBarHiden = navagationBarHiden;
    if (self.navagationBarHiden) {
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.navagationBarLucency||self.navagationBarHiden) {
    
            self.edgesForExtendedLayout = UIRectEdgeTop;
        
    }
}
    
    

- (void)setNavagationBarShadowLineHiden:(BOOL)navagationBarShadowLineHiden{
    _navagationBarShadowLineHiden = navagationBarShadowLineHiden;
    
    if(!self.navLine){
        self.navLine = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    }
    self.navLine.hidden = navagationBarShadowLineHiden;
    
}
    
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
        if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
            return (UIImageView *)view;
        }
        for (UIView *subview in view.subviews) {
            UIImageView *imageView = [self findHairlineImageViewUnder:subview];
            if (imageView) {
                return imageView;
            }
        }
        return nil;
}
    
//
- (void)pushPage:(UIViewController *)viewController Animated:(BOOL)animated{
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:animated];
    }
}

- (void)pushColseSelf:(UIViewController *)vc{
    
    [self.navigationController pushViewController:vc animated:YES];
    NSMutableArray *arr = [[self.navigationController viewControllers] mutableCopy];
    if (arr.count>=2) {
        [arr removeObjectAtIndex:arr.count-2];
        self.navigationController.viewControllers = arr;
    }
}

//
- (void)popAnimated:(BOOL)animated{
    if (self.navigationController&&self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

//
- (void)popToRootAnimated:(BOOL)animated{
    if (self.navigationController&&self.navigationController.viewControllers.count>1) {
        [self.navigationController popToRootViewControllerAnimated:animated];
    }
}

- (void)pushWeb:(NSString *)url HidenNavBar:(BOOL)hiden{
    BLWebViewController *web = [[BLWebViewController alloc] initWithUrl:url];
    web.hidesBottomBarWhenPushed = YES;
    web.navagationBarHiden = hiden;
    [self pushPage:web Animated:YES];
}

- (void)callPhone:(NSString *)phone{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
}



@end
