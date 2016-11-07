//
//  WKWebView+BLSize.h
//  BL_BaseApp
//
//  Created by BL_xinYin on 2016/11/1.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <WebKit/WebKit.h>

typedef void(^loadFinish)(CGRect rect);

@interface WKWebView (BLSize)

/**
 在完成协议中调用获取真实大小

 @param block
 */
- (void)BL_loadFinishReSetFrame:(loadFinish)block;


/**
 加载html

 @param html
 @param url
 */
- (void)BL_loadHTML:(NSString *)html withBaseUrl:(NSString *)url;

@end
