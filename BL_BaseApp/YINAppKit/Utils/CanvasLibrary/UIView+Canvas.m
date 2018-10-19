//
//  UIView+Canvas.m
//  BL_BaseApp
//
//  Created by bolaa on 16/12/9.
//  Copyright © 2016年 王印. All rights reserved.
//


#import "UIView+Canvas.h"



@implementation UIView (Canvas)


- (void)startSubviewCamvasAnimation{
    [[self subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj startCanvasAnimation];
    }];
}

- (void)startCanvasAnimation{
    
    Class <CSAnimation> class = [CSAnimation classForAnimationType:self.canvasType];
    [class performAnimationOnView:self duration:self.canvasDuration delay:self.canvasDelay];
}

+ (void)registerAnimationType:(CSAnimationType)animationType{
    [CSAnimation registerClass:self forAnimationType:animationType];
}

#pragma mark getter setter
- (void)setCanvasType:(CSAnimationType)canvasType{
     objc_setAssociatedObject(self, @selector(canvasType), canvasType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setInitStart:(BOOL)initStart{
    objc_setAssociatedObject(self, @selector(initStart), @(initStart), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (initStart) {
        [self aspect_hookSelector:@selector(awakeFromNib) withOptions:AspectPositionAfter usingBlock:^(){
            [self startCanvasAnimation];
        }error:nil];
    }
}

- (BOOL)initStart{
    return [objc_getAssociatedObject(self, @selector(initStart)) boolValue];
}

- (CSAnimationType)canvasType{
  return objc_getAssociatedObject(self, @selector(canvasType));
}

- (void)setCanvasDelay:(CGFloat)canvasDelay{
    objc_setAssociatedObject(self, @selector(canvasDelay), @(canvasDelay), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
- (CGFloat)canvasDelay{
    return [objc_getAssociatedObject(self, @selector(canvasDelay)) floatValue];
}

- (void)setCanvasDuration:(CGFloat)canvasDuration{
    objc_setAssociatedObject(self, @selector(canvasDuration), @(canvasDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (CGFloat)canvasDuration{
    return [objc_getAssociatedObject(self, @selector(canvasDuration)) floatValue];
}
@end
