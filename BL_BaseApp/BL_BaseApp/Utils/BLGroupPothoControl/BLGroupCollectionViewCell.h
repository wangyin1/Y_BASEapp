//
//  BLGroupCollectionViewCell.h
//  BL_BaseApp
//
//  Created by 王印 on 16/8/26.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^deletPhotoBlock)();

@interface BLGroupCollectionViewCell : UICollectionViewCell
@property(nonatomic,copy)deletPhotoBlock  block;
@property (weak, nonatomic) IBOutlet UIButton *deletButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (void)setBlock:(deletPhotoBlock)block;
@end
