//
//  UIView+YinBorder.m
//  BL_BaseApp
//
//  Created by bolaa on 17/3/16.
//  Copyright © 2017年 王印. All rights reserved.
//
#import "Aspects.h"
#import "UIView+YinBorder.h"

@interface UIView ()<AspectToken>

@property(nonatomic,strong)CAShapeLayer     *y_shape;
//边框可以直接设置属性


@property(nonatomic,assign)NSInteger  y_borderWidth;//默认为1

@property(nonatomic,assign)NSInteger  y_borderMargin;//0或正数为内边距 负数为外边距 （默认为0内边距）

@property(nonatomic,strong)UIColor     *y_borderColor;//默认为黑色

@property(nonatomic,assign)NSInteger      y_radius;//圆角范围 默认为0

@property(nonatomic,assign)BOOL     y_inside;



@end



@implementation UIView (YinBorder)

//@dynamic y_borderColor;
//@dynamic y_borderWidth;
//@dynamic y_borderMargin;

- (BOOL)remove{
    return YES;
}

- (void)y_makeBorderWithColor:(UIColor *)color Radius:(NSInteger)radius Inside:(BOOL)inside{
    
    self.y_borderColor = color;
    self.y_radius = radius;
    self.y_inside = inside;
    [self y_makeBorder];
}



- (void)y_makeBorderWithColor:(UIColor *)color Width:(NSInteger)width  Radius:(NSInteger)radius Margin:(NSInteger)margin Inside:(BOOL)inside{
    self.y_borderColor = color;
    self.y_borderWidth = width;
    self.y_radius = radius;
    self.y_borderMargin = margin;
    self.y_inside = inside;
    [self y_makeBorder];
}


- (void)y_redraw{
    
    [self.y_shape removeFromSuperlayer];
    [self.layer addSublayer:self.y_shape];
    self.y_shape.opaque = NO;
    self.y_shape.path = nil;
    
    self.layer.cornerRadius= self.y_radius;
    
    CAShapeLayer *shape = self.y_shape;
   
    if (self.y_inside) {
         shape.frame = CGRectMake(self.y_borderMargin, self.y_borderMargin, self.bounds.size.width-2*self.y_borderMargin, self.bounds.size.height-2*self.y_borderMargin);
    }else{
         shape.frame = CGRectMake(self.y_borderMargin-self.y_borderWidth, self.y_borderMargin-self.y_borderWidth, self.bounds.size.width-2*(self.y_borderMargin-self.y_borderWidth), self.bounds.size.height-2*(self.y_borderMargin-self.y_borderWidth));
    }
    
    CGFloat radiu = shape.frame.size.height*self.y_radius/self.frame.size.height;

    shape.borderColor = self.y_borderColor.CGColor;
    shape.borderWidth = self.y_borderWidth;
    shape.cornerRadius = radiu;


}


- (void)y_makeBorder{
    
    __weak typeof(self)weakSelf = self;
    [self aspect_hookSelector:@selector(didMoveToSuperview) withOptions:AspectPositionAfter usingBlock:^(){
        [weakSelf y_redraw];
    }error:nil];
    [self aspect_hookSelector:@selector(setFrame:) withOptions:AspectPositionAfter usingBlock:^(){
        [weakSelf y_redraw];
    }error:nil];
    [self y_redraw];
}



- (CAShapeLayer *)y_shape{
    
    CAShapeLayer *layer = objc_getAssociatedObject(self, @selector(y_shape));
    if (!layer) {
        layer = [CAShapeLayer layer];
        self.y_shape = layer;
        layer.zPosition = 1;
    }
    return layer;
}

- (void)setY_inside:(BOOL)y_inside{
    objc_setAssociatedObject(self, @selector(y_inside),@(y_inside), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)y_inside{
    return [objc_getAssociatedObject(self, @selector(y_inside)) boolValue];
}

- (void)setY_shape:(CAShapeLayer *)y_shape{
    
    objc_setAssociatedObject(self, @selector(y_shape), y_shape, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)y_borderWidth{
    return [objc_getAssociatedObject(self, @selector(y_borderWidth)) integerValue]!=0?[objc_getAssociatedObject(self, @selector(y_borderWidth)) integerValue]:1;
}

- (void)setY_borderWidth:(NSInteger)y_borderWidth{
    objc_setAssociatedObject(self, @selector(y_borderWidth), @(y_borderWidth), OBJC_ASSOCIATION_ASSIGN);
    
}

- (NSInteger)y_radius{
    return [objc_getAssociatedObject(self, @selector(y_radius)) integerValue];
}

- (void)setY_radius:(NSInteger)y_radius{
    objc_setAssociatedObject(self, @selector(y_radius), @(y_radius), OBJC_ASSOCIATION_ASSIGN);
    
}

- (NSInteger)y_borderMargin{
    return [objc_getAssociatedObject(self, @selector(y_borderMargin)) integerValue];
}

- (void)setY_borderMargin:(NSInteger)y_borderMargin{
    objc_setAssociatedObject(self, @selector(y_borderMargin), @(y_borderMargin), OBJC_ASSOCIATION_ASSIGN);
    
}

- (UIColor *)y_borderColor
{
    return objc_getAssociatedObject(self, @selector(y_borderColor))?:[UIColor blackColor];
    
}
- (void)setY_borderColor:(UIColor *)y_borderColor{
    
    objc_setAssociatedObject(self, @selector(y_borderColor), y_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


@end
