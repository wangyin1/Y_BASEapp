//
//  UIWebView+BLSize.h
//  yipingcang
//
//  Created by 王印 on 16/8/16.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (BLSize)
/**
 *  html加载完之后重新设置frame
 *
 *  @return 返回真实frame
 */
- (CGRect)BL_loadFinishReSetFrame;

/**
 *  加载html 
 *
 *  @param html
 */
- (void)BL_loadHTML:(NSString *)html;


/**

 
 @param html
 @param url
 */
- (void)BL_loadHTML:(NSString *)html BaseURL:(NSString *)url;
@end
