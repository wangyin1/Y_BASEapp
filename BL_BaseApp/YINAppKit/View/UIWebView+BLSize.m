//
//  UIWebView+BLSize.m
//  yipingcang
//
//  Created by 王印 on 16/8/16.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "UIWebView+BLSize.h"

@implementation UIWebView (BLSize)

- (CGRect)BL_loadFinishReSetFrame{

//  定义JS字符串
    NSString *script = [NSString stringWithFormat: @"var script = document.createElement('script');"
                        "script.type = 'text/javascript';"
                        "script.text = \"function ResizeImages() { "
                        "var myimg,oldwidth;"
                        "var maxwidth =%.2f;" // UIWebView中显示的图片宽度
                        "for(i=0;i <document.images.length;i++){"
                        "myimg = document.images[i];"
                        "if(myimg.width > maxwidth){"
                        "oldwidth = myimg.width;"
                        "myimg.width = maxwidth;"
                        "}"
                        "}"
                        "}\";"
                        "document.getElementsByTagName('header')[0].appendChild(script);",self.frame.size.width];
    //添加JS
    [self stringByEvaluatingJavaScriptFromString:script];
    //添加调用JS执行的语句
    [self stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    //获取页面高度（像素）
    NSString * clientheight_str = [self stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    //设置到WebView上
    self.frame = CGRectMake(self.frame.origin.x,self.frame.origin.y, self.frame.size.width, clientheight);
    //获取WebView最佳尺寸（点）
//    [self sizeToFit];
    CGSize frame = [self sizeThatFits:self.frame.size];
    
    //获取内容实际高度（像素）
    NSString * height_str= [self stringByEvaluatingJavaScriptFromString: @"document.getElementById('webview_content_wrapper').offsetHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))"];
    float height = [height_str floatValue];
    //内容实际高度（像素）* 点和像素的比
    height = height * frame.height / clientheight;
    //再次设置WebView高度（点）
    if (self.frame.size.height==height) {
        return self.frame;
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
    self.scrollView.contentMode = self.contentMode;
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.scrollView.layer.frame = self.scrollView.bounds;
    self.scrollView.clipsToBounds = YES;
    return self.frame;
}

- (void)BL_loadHTML:(NSString *)html BaseURL:(NSString *)url{
    
    self.scalesPageToFit = NO;
    self.scrollView.scrollEnabled = NO;
    self.contentMode = UIViewContentModeCenter;
    NSString * htmlcontent = [NSString stringWithFormat:@"<header></header><meta content=\"width=%.2f initial-scale=1.0, maximum-scale=1.2, user-scalable=1;\" name=\"viewport\" /><style type=\"text/css\">body{margin:auto;width:%.2f;}</style><body ><div  style=\"width:%.2fpx\" id=\"webview_content_wrapper\">%@</div></body>",self.bounds.size.width,self.bounds.size.width, self.bounds.size.width,html];
    [self loadHTMLString:htmlcontent baseURL:[NSURL URLWithString:url]];
    
}
- (void)BL_loadHTML:(NSString *)html
{
    self.scalesPageToFit = NO;
    self.scrollView.scrollEnabled = NO;
    self.contentMode = UIViewContentModeCenter;
    NSString * htmlcontent = [NSString stringWithFormat:@"<header></header><meta content=\"width=%.2f initial-scale=1.0, maximum-scale=1.2, user-scalable=1;\" name=\"viewport\" /><style type=\"text/css\">body{margin:auto;width:%.2f;}</style><body ><div  style=\"width:%.2fpx\" id=\"webview_content_wrapper\">%@</div></body>",self.bounds.size.width,self.bounds.size.width, self.bounds.size.width,html];
    [self loadHTMLString:htmlcontent baseURL:nil];
}

@end
