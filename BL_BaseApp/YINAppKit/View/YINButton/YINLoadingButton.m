//
//  YINButton.m
//  BL_BaseApp
//
//  Created by apple on 2018/9/26.
//  Copyright © 2018年 王印. All rights reserved.
//

#import "YINLoadingButton.h"

@interface YINLoadingButton()

@property (strong,nonatomic) UIView *circleView;

@end

@implementation YINLoadingButton

- (void)startLoading{
    self.circleView.hidden = NO;
    [self.circleView.layer.sublayers.lastObject removeFromSuperlayer];
    [self.circleView.layer addSublayer:[self circlelayer]];
    [self setupAnimationForLayer:self.circleView.layer.sublayers.lastObject];

}

- (BOOL)isLoading{
    return  !self.circleView.hidden;
}

- (void)stopLoading{
    self.circleView.hidden = YES;
    [self.circleView.layer.sublayers.lastObject removeAllAnimations];
}

- (void)setTintColor:(UIColor *)tintColor{
    [super setTintColor:tintColor];
    if (self.circleView.layer.sublayers.count>0) {
        [(CAShapeLayer *)self.circleView.layer.sublayers.lastObject setStrokeColor:tintColor.CGColor];
    }
}

- (void)setupAnimationForLayer:(CALayer *)layer{
    CGFloat beginTime = 0.5;
    CGFloat strokeStartDuration = 1.2;
    CGFloat strokeEndDuration = 0.7;
    
    CABasicAnimation *rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.byValue = @(M_PI * 2);
//    rotationAnimation.timingFunction = kCAMediaTimingFunctionLinear;
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = strokeEndDuration;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.3 :1.0];

    strokeEndAnimation.fromValue = @0;
    strokeEndAnimation.toValue = @1;
    
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.duration = strokeStartDuration;
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0];
    strokeStartAnimation.fromValue = @0;
    strokeStartAnimation.toValue = @1;
    strokeStartAnimation.beginTime = beginTime;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[rotationAnimation, strokeEndAnimation, strokeStartAnimation];
    groupAnimation.duration = strokeStartDuration + beginTime;
    groupAnimation.repeatCount = MAXFLOAT;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    [layer addAnimation:groupAnimation forKey:@"animation"];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUpview];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpview];
    }
    return self;
}

- (void)setUpview{
    
    [self addSubview:self.circleView];
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.mas_left).offset(-8);
        make.centerY.equalTo(self.titleLabel.mas_centerY).offset(0);
        make.height.equalTo(@(MIN(25, self.bounds.size.height-6)));
        make.width.equalTo(@(MIN(25, self.bounds.size.height-6)));
    }];
  
}

- (UIView *)circleView{
    if (!_circleView) {
        UIView *view=  [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        view.hidden = YES;
        _circleView = view;
    }
    return _circleView;
}
- (CALayer *)circlelayer{
    
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.circleView.bounds;
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path addArcWithCenter:CGPointMake(layer.bounds.size.width/2.0, layer.bounds.size.width/2.0) radius:layer.bounds.size.width/2.0 startAngle:-(M_PI / 2) endAngle:M_PI + M_PI / 2 clockwise:YES];
        layer.fillColor = nil;
        layer.strokeColor = self.tintColor.CGColor;
        layer.lineWidth = 2;
        layer.backgroundColor = nil;
        layer.path = path.CGPath;
    
    return layer;
}

@end
