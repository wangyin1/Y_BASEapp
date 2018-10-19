//
//  UIFont+PX.h
//  BL_BaseApp
//
//  Created by 王印 on 16/10/25.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 当美工给的字体大小是px单位时，可通过此扩展来初始化font
 */

@interface UIFont (PX)

@property (nonatomic , assign,readonly) CGFloat pxSize;

/**
 粗体的字体

 @param pxSize px单位的字体大小

 @return
 */
+ (UIFont *)boldSystemFontOfPXSize:(CGFloat)pxSize;


/**
 默认字体

 @param pxSize px单位的字体大小

 @return
 */
+ (UIFont *)systemFontOfPXSize:(CGFloat)pxSize;



/**
 根据px大小获取pt大小

 @param px

 @return
 */
+ (CGFloat)ptForPx:(CGFloat)px;


/**
根据pt大小获取px大小

 @param pt

 @return
 */
+ (CGFloat)pxForPt:(CGFloat)pt;
@end
