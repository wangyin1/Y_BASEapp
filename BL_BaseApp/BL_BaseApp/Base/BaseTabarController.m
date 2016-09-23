//
//  BaseTabarController.m
//  BL_BaseApp
//
//  Created by 王印 on 16/9/3.
//  Copyright © 2016年 王印. All rights reserved.
//
#import "BaseTabarController.h"

@interface BaseTabarController ()

@property(nonatomic,strong)NSArray<NSString *>      *titles;

@property(nonatomic,strong)NSArray<NSString *>      *imageNames;

@property(nonatomic,strong)NSArray<NSString *>      *selectImages;

/**
 *  被选中时文字颜色
 */
@property(nonatomic,strong)UIColor      *selectedColor;

/**
 *  取消选中时文字颜色
 */
@property(nonatomic,strong)UIColor      *desSelectColor;

@end

@implementation BaseTabarController

- (instancetype)initWithtabBarItemTitles:(NSArray <NSString *>*)titles ImageNames:(NSArray<NSString *> *)imageNames SelectImages:(NSArray<NSString *> *)selectImages SelectedColor:(UIColor *)selectedColor DesSelectColor:(UIColor *)desSelectColor ViewControllers:(NSArray <UIViewController *> *)viewControllers{
    self = [super init];
    if (self) {
        self.showLine = YES;
        self.selectedColor = selectedColor;
        self.desSelectColor = desSelectColor;
        self.barBackgroundColor = [UIColor whiteColor];
        [self setTextColor];
        self.imageNames = imageNames;
        self.titles = titles;
        self.selectImages = selectImages;
        self.viewControllers = viewControllers;
        [self initTabBarItems];
    }
    return self;
}
- (void)initTabBarItems{
    for (int i = 0 ; i<self.viewControllers.count ; i++) {
        UIViewController  *na = self.viewControllers[i];
        na.tabBarItem = [[UITabBarItem alloc]initWithTitle:self.titles[i] image:[[UIImage imageNamed:self.imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:self.selectImages[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
}

- (void)setTextColor{
    
    NSDictionary *attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.desSelectColor, NSForegroundColorAttributeName,
     
     
     [UIFont fontWithName:@"Helvetica" size:10], NSFontAttributeName,
     nil];
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      self.selectedColor, NSForegroundColorAttributeName,
      
      [UIFont fontWithName:@"Helvetica" size:10], NSFontAttributeName,
      nil]
                                             forState:UIControlStateSelected];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tabBar.clipsToBounds = NO;
    
    self.tabBar.barTintColor = self.barBackgroundColor;
}
- (void)setBarBackgroundColor:(UIColor *)barBackgroundColor{
    _barBackgroundColor = barBackgroundColor;
    self.tabBar.barTintColor = self.barBackgroundColor;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
        for (UIView *view in self.tabBar.subviews) {
            if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
                UIImageView *ima = (UIImageView *)view;
                ima.hidden = !self.showLine;
            }
        }
    
}
@end
