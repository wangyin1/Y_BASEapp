//
//  BLChoseImagesControl.h
//  BL_BaseApp
//
//  Created by 王印 on 16/7/24.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLGetImagesBlock)(NSArray *images);

@interface BLChoseImagesControl : NSObject
@property(nonatomic,assign)NSInteger        maxAllow;
/**
 *  选择图片带选择器
 *
 *  @param maxCount 最多几张
 *  @param block    回调图片数组
 *  @param dismiss
 */
+ (void)showChoseImagesAlertWithMaxCount:(NSInteger)maxCount GetImagesBlock:(BLGetImagesBlock)block DissmissBlock:(void (^)())dismiss;
@end
