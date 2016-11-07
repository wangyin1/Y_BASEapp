//
//  WLayOut.h
//  WLayOut
//
//  Created by 王印 on 16/5/17.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WLayOut;

@protocol WVerticalLayOutDelegate <NSObject>


/**
 返回列数

 @param layout

 @return
 */
- (NSInteger)VerticalLayOutnumberOfMaxNumCols:(WLayOut *)layout;



/**
 返回每个元素的高度

 @param layout
 @param row    元素位置

 @return
 */
- (CGFloat)VerticalLayOut:(WLayOut *)layout HeightForRow:(NSInteger)row;



/**
 返回间距

 @param layout

 @return
 */
- (CGFloat)VerticalLayOutPixelSpacing:(WLayOut *)layout;

@end

@interface WLayOut : UICollectionViewFlowLayout


@property (nonatomic , weak) id<WVerticalLayOutDelegate> delegate;


- (CGSize)_collectionViewContentSize;

@end
