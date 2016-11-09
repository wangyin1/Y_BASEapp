//
//  BLWebViewController.m
//  BL_BaseApp
//
//  Created by 王印 on 16/8/24.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import "BLWebViewController.h"
#import <WebKit/WebKit.h>

@interface BLWebViewController ()<WKScriptMessageHandler>

//DIYObj_(JSContext, context);

@end

@implementation BLWebViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [[(WKWebView *)self.WebView.realWebView configuration].userContentController addScriptMessageHandler:self name:@"showAblueView"];//添加方法，js调原生的方法协议必须在这里注册
    weakify(self);
    [self setLoadFinsh:^(WKWebView *webView) {
        [webView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
        // 禁用 长按弹出ActionSheet
        [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
        
        
        

    }];
}


/**
 js代码  window.webkit.messageHandlers.<#name>.postMessage(<#body>);
 接受到js调用命令
 @param userContentController
 @param message
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //UI方法必须在主线程中使用
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //判断是什么命令
        if ([message.name isEqualToString:@""]) {//注册过的方法名
            //获取js 参数
            //        message.body;
        }
        
    });
}

@end
