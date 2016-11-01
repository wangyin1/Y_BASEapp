//
//  BLGroupPhotoControl.h
//  BL_BaseApp
//
//  Created by 王印 on 16/8/25.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BLGroupPhotoControlSizeChange)(CGSize size);

@interface BLGroupPhotoControl : UIView


/**
    展示图片的承载器是一个collectionview
    可做基本属性自定义
 */
@property (nonatomic , strong) UICollectionView *collectionView;


/**
 //设置item的大小
 */
@property (nonatomic , assign) CGSize itemSize;


/**
 //是否可以编辑 不可编辑状态用于展示图片 可点击看大图
 */
@property (nonatomic , assign) BOOL canEdit;


/**
 //图片数组用来展示 本地图片和网络图片地址都可以
 */
@property (nonatomic , strong) NSArray *images;


- (NSArray *)realImages;//用来获取可用的图片数组 把加号除外

@property(nonatomic,copy)BLGroupPhotoControlSizeChange      changeSize;

- (void)setChangeSize:(BLGroupPhotoControlSizeChange)changeSize;//编辑状态 增加删除图片 视图的高度可能发生变化，这里控制其父视图的大小



@end
