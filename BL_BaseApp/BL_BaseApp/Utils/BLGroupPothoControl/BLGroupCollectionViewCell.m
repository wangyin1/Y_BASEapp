//
//  BLGroupCollectionViewCell.m
//  BL_BaseApp
//
//  Created by 王印 on 16/8/26.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "BLGroupCollectionViewCell.h"

@interface BLGroupCollectionViewCell ()


@end

@implementation BLGroupCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deletButton.layer.cornerRadius = 12.5;
    // Initialization code
    [self.contentView bringSubviewToFront:self.deletButton];
}

- (IBAction)delet:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}
@end
