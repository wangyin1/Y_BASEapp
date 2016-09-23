//
//  WLayOut.m
//  WLayOut
//
//  Created by 王印 on 16/5/17.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "WLayOut.h"

@interface WLayOut ()

@property(nonatomic,strong)NSMutableDictionary      *heightDic;



@end


@implementation WLayOut



- (void)prepareLayout{
    [super prepareLayout];
}

- (NSMutableDictionary *)heightDic{
    if (!_heightDic) {
        _heightDic = [NSMutableDictionary dictionary];
    }
    return _heightDic;
}
- (CGSize)_collectionViewContentSize{
    
    if (!self.heights) {
        return CGSizeMake(self.collectionView.bounds.size.width, 1);
    }
    NSMutableDictionary *heightDic = [NSMutableDictionary dictionary];
    for (int i = 0; i<self.maxNumCols; i++) {
        [heightDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d",i]];
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<self.maxNumCols; i++) {
        
        for (int j = 0;j<self.heights.count;j++) {
            if ([arr indexOfObject:[NSString stringWithFormat:@"%d",j]]!=NSNotFound) {
                continue;
            }
            NSArray *keys = [heightDic keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 floatValue]>[obj2 floatValue];
            }];
            [heightDic setObject:@([self.heights[j] floatValue]+[heightDic[keys.firstObject]floatValue]+self.awidth) forKey:keys.firstObject];
            [arr addObject:[NSString stringWithFormat:@"%d",j]];;
        }
    }
    NSArray *keys = [heightDic keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 floatValue]>[obj2 floatValue];
    }];
    
    return CGSizeMake(self.collectionView.bounds.size.width, [heightDic[keys.lastObject] floatValue]);
}


//只需要遍历前面创建的存放列高的数组得到列最高的一个作为高度返回就可以了
- (CGSize)collectionViewContentSize{
    
    
    if (!self.heights) {
        return CGSizeMake(self.collectionView.bounds.size.width, 1);
    }
    NSMutableDictionary *heightDic = [NSMutableDictionary dictionary];
    for (int i = 0; i<self.maxNumCols; i++) {
        [heightDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d",i]];
    }
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<self.maxNumCols; i++) {
        
        for (int j = 0;j<self.heights.count;j++) {
            if ([arr indexOfObject:[NSString stringWithFormat:@"%d",j]]!=NSNotFound) {
                continue;
            }
            NSArray *keys = [heightDic keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 floatValue]>[obj2 floatValue];
            }];
            [heightDic setObject:@([self.heights[j] floatValue]+[heightDic[keys.firstObject]floatValue]+self.awidth) forKey:keys.firstObject];
            [arr addObject:[NSString stringWithFormat:@"%d",j]];;
        }
    }
    NSArray *keys = [heightDic keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 floatValue]>[obj2 floatValue];
    }];
    
    return CGSizeMake(self.collectionView.bounds.size.width, [heightDic[keys.lastObject] floatValue]);
}

- (NSArray *)getAttributes{
    
    NSMutableArray *attributes = [NSMutableArray array];
    CGFloat width = (self.collectionView.bounds.size.width-((self.maxNumCols+1)*self.awidth))/self.maxNumCols;
    for (int i = 0;i<_heights.count;i++) {
        
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (i>=self.maxNumCols) {
            
            NSArray *arr = [attributes sortedArrayUsingComparator:^NSComparisonResult(  UICollectionViewLayoutAttributes * obj1, UICollectionViewLayoutAttributes * obj2) {
                return CGRectGetMaxY(obj1.frame)<=CGRectGetMaxY(obj2.frame);
            }];
            
            UICollectionViewLayoutAttributes *topOne = arr[self.maxNumCols-1];
            
            attribute.frame = CGRectMake(topOne.frame.origin.x,CGRectGetMaxY(topOne.frame)+self.awidth,width, [self.heights[i] floatValue]);
        }else{
            attribute.frame = CGRectMake(_awidth+i*(width+_awidth),_awidth,width, [self.heights[i] floatValue]);
        }
        
        [attributes addObject:attribute];
    }
    return attributes;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    [super layoutAttributesForElementsInRect:rect];
    
    return  [self getAttributes];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return  [(id<UICollectionViewDataSource>)self.collectionView.delegate collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
}

@end
