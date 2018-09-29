//
//  YINWebViewController.m
//  BL_BaseApp
//
//  Created by 王印 on 16/9/20.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "YINWebViewController.h"

@interface YINWebViewController ()
@property (nonatomic , strong) NSMutableArray *snapShotsArray;
@property (nonatomic , strong) UIProgressView *progressView;
@property (nonatomic , strong) NSString *htmlstr;
@property (nonatomic , strong) NSString *htmlBaseUrl;
@end

@implementation YINWebViewController

- (void)dealloc
{
    [_WebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
        [self.WebView.scrollView setContentInsetAdjustmentBehavior:2];
    } else {
        // Fallback on earlier versions
    }
    self.snapShotsArray = [NSMutableArray array];
    [self.view addSubview:self.WebView];
    
    [self.WebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    if (self.url) {
        [self loadUrl:self.url.absoluteString];
    }else if (self.htmlstr){
        [self LoadH5String:self.htmlstr BaseUrl:self.htmlBaseUrl];
    }
    
    [self.view addSubview:self.progressView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@2);
    }];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backItemImage"] style:1 target:self action:@selector(popBack:)];
    

    self.navigationItem.leftBarButtonItems = @[backItem];
    
}

- (void)setProgressColor:(UIColor *)ProgressColor{
    if (_ProgressColor!=ProgressColor) {
        _ProgressColor = ProgressColor;
        self.progressView.tintColor = ProgressColor;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ProgressColor = [UIColor greenColor];
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url{
    self =  [super init];
    if (self) {
        self.url = [NSURL URLWithString:url];
         self.ProgressColor = [UIColor greenColor];
    }
    return self;
}

- (void)loadUrl:(NSString *)url{
    [self.WebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (instancetype)initWithSoruceFile:(NSURL *)fileURL{
    self =  [super init];
    if (self) {
        self.url = fileURL;
        
        self.ProgressColor = [UIColor greenColor];
    }
    return self;
}

-(instancetype)initWithHtml:(NSString *)html BaseUrl:(NSString *)url{
    self = [super init];
    if (self) {
        self.ProgressColor = [UIColor greenColor];
        self.htmlstr = html;
        self.htmlBaseUrl = url;
    }
    return self;
}

-(void)LoadH5String:(NSString *)hString BaseUrl:(NSString *)url{
    [self.WebView loadHTMLString:hString baseURL:[NSURL URLWithString:url]];
}

- (IMYWebView *)WebView{
    if (!_WebView) {
        _WebView = [[IMYWebView alloc] initWithFrame:self.view.bounds usingUIWebView:NO];
        _WebView.delegate = self;
        [_WebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _WebView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    self.progressView.alpha = 1;
    [self.progressView setProgress:self.WebView.estimatedProgress animated:self.progressView.progress<self.WebView.estimatedProgress];
    if (self.WebView.estimatedProgress>=1) {
        [UIView animateWithDuration:.5 animations:^{
            self.progressView.alpha = 0;
        }completion:^(BOOL finished) {
        }];
    }
}

- (void)webViewDidStartLoad:(IMYWebView *)webView{

    [self.snapShotsArray addObject:webView.currentRequest];
}

- (void)webViewDidFinishLoad:(IMYWebView *)webView{
    if (self.loadFinsh) {
        self.loadFinsh(webView.realWebView);
    }
}

- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

-(BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{


    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked: {
        return  [self pushCurrentSnapshotViewWithRequest:request];
            break;
        }
        case UIWebViewNavigationTypeFormSubmitted: {
           return [self pushCurrentSnapshotViewWithRequest:request];
            break;
        }
        case UIWebViewNavigationTypeBackForward: {
            break;
        }
        case UIWebViewNavigationTypeReload: {
            break;
        }
        case UIWebViewNavigationTypeFormResubmitted: {
            break;
        }
        case UIWebViewNavigationTypeOther: {
          return   [self pushCurrentSnapshotViewWithRequest:request];
            break;
        }
        default: {
            break;
        }
    }
    return YES;
}

#pragma mark - logic of push and pop snap shot views
-(BOOL)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    //    DLog(@"push with request %@",request);
    if (self.snapShotsArray.count==0) {
        return YES;
    }
    NSURLRequest* lastRequest = (NSURLRequest*)[self.snapShotsArray lastObject];
    
    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        NSLog(@"about blank!! return");
        return YES;
    }
    //如果url一样就不进行push
    if ([lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
        return YES;
    }
    
    return YES;
    //    NSLog(@"now array count %d",self.snapShotsArray.count);
}

//点击返回
- (void)popBack:(UIBarButtonItem *)sender{
    
    if (self.WebView.canGoBack) {
        [self.WebView goBack];
        
        if (self.WebView.canGoBack) {
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backItemImage"] style:1 target:self action:@selector(popBack:)];
            UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:1 target:self action:@selector(closePage)];
            self.navigationItem.leftBarButtonItems = @[backItem,close];
        }else{
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backItemImage"] style:1 target:self action:@selector(popBack:)];
            self.navigationItem.leftBarButtonItems = @[backItem];
        }
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closePage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2.0);
        _progressView = [[UIProgressView alloc] initWithFrame:frame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
        _progressView.tintColor = self.ProgressColor;
        _progressView.trackTintColor = [UIColor clearColor];
    }
    
    return _progressView;
}
@end
