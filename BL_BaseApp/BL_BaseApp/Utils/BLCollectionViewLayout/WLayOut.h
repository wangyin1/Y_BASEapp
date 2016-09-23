//
//  WLayOut.h
//  WLayOut
//
//  Created by 王印 on 16/5/17.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLayOut : UICollectionViewFlowLayout

@property (nonatomic,assign) NSInteger maxNumCols;//几列
@property(nonatomic,strong)NSArray      *heights;//每个cell的高度；每个cell的高度必须大于10
@property(nonatomic,assign)CGFloat      awidth;//间距
- (CGSize)_collectionViewContentSize;
@end
