//
//  BaseTabarController.m
//  BL_BaseApp
//
//  Created by 王印 on 16/9/3.
//  Copyright © 2016年 王印. All rights reserved.
//
#import "SDWebImageDownloader.h"
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

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize

{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
    
}
- (void)initTabBarItems{
    for (int i = 0 ; i<self.viewControllers.count ; i++) {
        UIViewController  *na = self.viewControllers[i];
        if ([self.imageNames[i] containsString:@"http"]&&[self.selectImages[i] containsString:@"http"]) {
            __block  UIImage *aimage = nil;
            __block  UIImage *seimage = nil;
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_enter(group);
            dispatch_async(dispatch_get_global_queue(0,0),^{
                
            

                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.imageNames[i]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    aimage = [self reSizeImage:image toSize:CGSizeMake(25, 25)];
                    
                    dispatch_group_leave(group);
                }];
                
            });
            
            dispatch_group_enter(group);
            dispatch_async(dispatch_get_global_queue(0,0),^{
              
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.selectImages[i]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    seimage = [self reSizeImage:image toSize:CGSizeMake(25, 25)];
                    
                    dispatch_group_leave(group);
                }];
                
            });
            dispatch_group_notify(group,dispatch_get_main_queue(),^{
                 na.tabBarItem = [[UITabBarItem alloc]initWithTitle:self.titles[i] image:[aimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[seimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            });
            
        }else{
            
            na.tabBarItem = [[UITabBarItem alloc]initWithTitle:self.titles[i] image:[[self reSizeImage:[UIImage imageNamed:self.imageNames[i]] toSize:CGSizeMake(25, 25)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[self reSizeImage:[UIImage imageNamed:self.selectImages[i]] toSize:CGSizeMake(25, 25)]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        }
     
    }
}


- (void)initTabBarItemsWithTitle:(NSArray <NSString *>*)titles AndImages:(NSArray <NSString *>*)images SelectImages:(NSArray <NSString *>*)selectImages{
    self.titles = titles;
    self.imageNames = images;
    self.selectImages = selectImages;
    [self initTabBarItems];
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
