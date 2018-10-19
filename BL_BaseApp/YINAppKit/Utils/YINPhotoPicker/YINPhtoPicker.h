//
//  YINPhtoPicker.h
//  BL_BaseApp
//
//  Created by bolaa on 2018/3/13.
//  Copyright © 2018年 王印. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^YINPhtoPickerBlock)(NSArray<UIImage *> *images);
typedef void(^YINPhtoDeletBlock)(id image,NSInteger index);
@interface YINPhtoPicker : NSObject

/**
 *  选择图片带选择器
 *
 *  @param maxCount 最多几张
 *  @param block    回调图片数组
 *  @param dismiss
 */
+ (void)choseWithMaxCount:(NSInteger)maxCount controller:(UIViewController *)vc getImagesBlock:(YINPhtoPickerBlock)block;



+ (void)showBrowserWithImage:(NSArray *)images  fromImageView:(UIImageView *)imageView currentIndex:(NSInteger)index deletBlock:(YINPhtoDeletBlock)delet;
@end
