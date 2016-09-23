//
//  BLDrawView.m
//  BL_BaseApp
//
//  Created by 王印 on 16/8/31.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "BLDrawView.h"

@interface BLDrawView ()

@property(nonatomic,strong)NSMutableArray       *methods;

@end

@implementation BLDrawView

- (NSMutableArray *)methods{
    if (!_methods) {
        _methods = [NSMutableArray array];
    }
    return _methods;
}

- (void)addDrawMethod:(BLDrawViewMethod)method{
    if (method) {
        [self.methods addObject:method];
    }
}

- (void)drawWithMethod:(BLDrawViewMethod)method{
    [self.methods removeAllObjects];
    [self.methods addObject:method];
    [self draw];
}

- (void)clearDraw{
    [self.methods removeAllObjects];
    [self setNeedsDisplay];
}
- (void)draw{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
     [self.methods enumerateObjectsUsingBlock:^(BLDrawViewMethod obj, NSUInteger idx, BOOL * _Nonnull stop) {
         obj(self);
     }];
}

- (void)removeMenthodAtIndex:(NSInteger)index{

    if (index<self.methods.count) {
        [self.methods removeObjectAtIndex:index];
    [self draw];
    }
    
}
- (NSArray <BLDrawViewMethod> *)allDrawMenthods{
    return [self.methods copy];
}
@end
