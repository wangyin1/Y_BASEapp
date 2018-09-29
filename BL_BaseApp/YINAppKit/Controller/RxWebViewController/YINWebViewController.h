//
//  YINWebViewController.h
//  BL_BaseApp
//
//  Created by 王印 on 16/9/20.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "IMYWebView.h"
#import <WebKit/WebKit.h>
#import "BLBaseViewController.h"

typedef void(^WEBLoadFinishBlock)(WKWebView *webView);

@interface YINWebViewController : BLBaseViewController<IMYWebViewDelegate>

/**
 IMYWebView 实体类，包含wkwebview  里面很多控制方法
 */
@property (nonatomic , strong) IMYWebView *WebView;

/**
 进度条颜色
 */
@property (nonatomic , strong) UIColor *ProgressColor;;

/**
 网络地址或者本地资源地址
 */
@property (nonatomic)NSURL* url;

/**
 用url初始化

 @param url url地址

 @return
 */
-(instancetype)initWithUrl:(NSString *)url;

/**
 用html字符串初始化

 @param html html字符串
 @param url  baseurl

 @return
 */
-(instancetype)initWithHtml:(NSString *)html BaseUrl:(NSString *)url;

/**
 用本地资源初始化

 @param fileURL 资源路径

 @return
 */

- (instancetype)initWithSoruceFile:(NSURL *)fileURL;

/**
 加载url

 @param url url
 */
- (void)loadUrl:(NSString *)url;

/**
 加载一段html

 @param hString html字符串
 @param url     baseurl
 */
-(void)LoadH5String:(NSString *)hString BaseUrl:(NSString *)url;


@property(nonatomic,copy)WEBLoadFinishBlock     loadFinsh;

/**
 加载完成

 @param loadFinsh
 */
- (void)setLoadFinsh:(WEBLoadFinishBlock)loadFinsh;


@end
