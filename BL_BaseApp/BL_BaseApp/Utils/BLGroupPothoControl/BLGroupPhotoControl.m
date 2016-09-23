//
//  BLGroupPhotoControl.m
//  BL_BaseApp
//
//  Created by 王印 on 16/8/25.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "BLGroupPhotoControl.h"
#import "WLayOut.h"
#import "HUPhotoBrowser.h"
#import "BLChoseImagesControl.h"
#import "BLGroupCollectionViewCell.h"

#define _screenWidth [UIScreen mainScreen].bounds.size.width


@interface BLGroupPhotoControl ()<UICollectionViewDelegate,UICollectionViewDataSource>


DIYObj_(WLayOut, layout);
Image_(addIconImage);

@end

@implementation BLGroupPhotoControl


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.addIconImage = [UIImage imageNamed:@"添加图片"];
        self.images = @[];
        self.canEdit = YES;
        self.itemSize = CGSizeMake((_screenWidth-8)/3.f, (_screenWidth-8)/3.f);
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    }
    return self;
}

- (void)setCanEdit:(BOOL)canEdit{
    
    _canEdit = canEdit;
     NSMutableArray *arr = [self.images mutableCopy];
    if (canEdit) {
        if (self.images.count<9&&![self.images.lastObject isEqual:self.addIconImage]) {
           
            [arr addObject:self.addIconImage];
            self.images = arr;
        }
    }else{
        if ([self.images.lastObject isEqual:self.addIconImage]) {
            [arr removeLastObject];
            self.images = arr;
        }
    }
    [self.collectionView reloadData];
}
- (void)setItemSize:(CGSize)itemSize{
    _itemSize = itemSize;
    NSMutableArray *heights = [NSMutableArray array];
    for (id object in self.images) {
        [heights addObject:@(self.itemSize.height)];
    }
    self.layout.awidth = (_screenWidth-itemSize.width*3)/4.f;
    self.layout.heights = heights;
    self.bounds = CGRectMake(0, 0, _screenWidth, [self.layout _collectionViewContentSize].height);
    if (self.changeSize) {
        self.changeSize(self.bounds.size);
    }
    [self.collectionView reloadData];
}
- (NSArray *)realImages{
    NSMutableArray *arr = [self.images mutableCopy];
    if ([self.images.lastObject isEqual:self.addIconImage]){
        [arr removeLastObject];
    }
    return arr;
}

- (void)setImages:(NSArray *)images{
    if (_images!=images) {
        _images = images;
        NSMutableArray *heights = [NSMutableArray array];
        for (id object in images) {
            [heights addObject:@(self.itemSize.height)];
        }
        self.layout.heights = heights;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _screenWidth, [self.layout _collectionViewContentSize].height);
        if (self.changeSize) {
            self.changeSize(self.bounds.size);
        }
        [self.collectionView reloadData];
    }
}

- (WLayOut *)layout
{
    if (!_layout) {
        WLayOut *layout = [[WLayOut alloc] init];
        layout.maxNumCols = 3;
        layout.awidth = 2;
        _layout = layout;
    }
    return _layout;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        _collectionView =  [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor =[UIColor whiteColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:@"BLGroupCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BLGroupCollectionViewCell"];
    }
    return _collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BLGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BLGroupCollectionViewCell" forIndexPath:indexPath];
    if ([self.images[indexPath.row] isKindOfClass:[UIImage class]]) {
        cell.imageView.image = self.images[indexPath.row];
    }else{
        [cell.imageView sd_setImageWithURL:self.images[indexPath.row] placeholderImage:nil];
    }
    weakify(self);
    [cell setBlock:^{//删除
         NSMutableArray *muImages = [[weak_self images] mutableCopy];
        [muImages removeObjectAtIndex:indexPath.row];
        if (muImages.count==8&&![muImages.lastObject isEqual:self.addIconImage]) {
            [muImages addObject:self.addIconImage];
        }
        weak_self.images = muImages;
    }];
    cell.deletButton.hidden = !(self.canEdit&&![cell.imageView.image isEqual:self.addIconImage]);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.canEdit&&[self.images.lastObject isEqual:self.addIconImage]) {//未选择满
        if (indexPath.row==self.images.count-1) {//点击加号
            [BLChoseImagesControl showChoseImagesAlertWithMaxCount:9-self.images.count+1 GetImagesBlock:^(NSArray *images) {
                NSMutableArray *muImages = [[self images] mutableCopy];
                [muImages removeLastObject];
                [muImages addObjectsFromArray:images];
                if (muImages.count<9) {
                    [muImages addObject:self.addIconImage];
                }
                self.images = muImages;
            } DissmissBlock:^{
                
            }];
            return;
        }
    }
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
     NSMutableArray *muImages = [[self images] mutableCopy];
    if ([muImages.lastObject isEqual:self.addIconImage]) {
        [muImages removeLastObject];
    }
    if ([self.images.firstObject isKindOfClass:[NSString class]]) {
        
        [HUPhotoBrowser showFromImageView:cell.contentView.subviews.firstObject withURLStrings:muImages placeholderImage:nil atIndex:indexPath.row dismiss:^(UIImage *image, NSInteger index) {
            
        }];
    }else{
    [HUPhotoBrowser showFromImageView:cell.contentView.subviews.firstObject withImages:muImages placeholderImage:nil atIndex:indexPath.row dismiss:^(UIImage *image, NSInteger index) {
        
    }];
    }
}

@end
