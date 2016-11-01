//
//  BLLoginViewController.m
//  BL_BaseApp
//
//  Created by 王印 on 16/7/23.
//  Copyright © 2016年 王印. All rights reserved.
//
#import "UIViewController+HRAlertViewController.h"
#import "BLChoseImagesControl.h"
#import "BLLoginViewController.h"
#import "BLGroupPhotoControl.h"
#import <UIKit/UIKit.h>
#import "BLDrawView.h"
#import "BLWebViewController.h"
#import "UIView+ZQuartz.h"
#import "TMCache.h"

@interface BLLoginViewController ()


@property (nonatomic , strong) BLDrawView *gcontrol;

@end

@implementation BLLoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"登录";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        
        [JGProgressHUD showWithStr:@"已安装qq" WithTime:2];
    }else{
        [JGProgressHUD showWithStr:@"请安装qq" WithTime:2];
    }
}



- (void)viewDidLoadFinish
{
    [super viewDidLoadFinish];
    //九宫格控件
    BLGroupPhotoControl *hopto = [[BLGroupPhotoControl alloc] initWithFrame:CGRectMake(0, 68, self.view.bounds.size.width, 10)];
    hopto.images = @[@"http://scimg.jb51.net/allimg/160815/103-160Q509544OC.jpg",@"http://www.taopic.com/uploads/allimg/120421/107063-12042114025737.jpg"];//可传入本地图片和网络地址
    hopto.canEdit = YES;//编辑状态，no为展示状态
    [self.view addSubview:hopto];
    
    
//    //选择图片方法，自带弹出底部选择器
//    [BLChoseImagesControl showChoseImagesAlertWithMaxCount:3 GetImagesBlock:^(NSArray *images) {
//       
//        //这里返回选择的图片数组
//        
//    } DissmissBlock:^{
//        //这个block无效
//    }];
//    
//    //网页控制器的使用
//    BLWebViewController *vc = [[BLWebViewController alloc]initWithUrl:@"http://www.baidu.com"];
//    vc.ProgressColor = [UIColor redColor];//设置进度条颜色
//    vc.navigationController.hidesBarsOnSwipe = YES;
//    vc.navagationBarColor = [UIColor yellowColor];//设置顶部颜色
//    [self pushPage:vc Animated:YES];
//    
    
    //绘图
//    BLDrawView *aview = [[BLDrawView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
//    [aview addDrawMethod:^(BLDrawView *drawView) {
//        
//        [drawView drawRectangle:CGRectMake(20, 10, 30, 30)];
//    }];
//    [aview addDrawMethod:^(BLDrawView *drawView) {
//          [drawView drawText:drawView.bounds text:@"nihaohndsjhluscjnaskcnkjxnksajfdslkjncsjksndfjkncsancks\nnjkfdsnadlkjnf" fontSize:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
//    }];
//    aview.backgroundColor = [UIColor orangeColor];
//    [aview draw];
//    [self.view addSubview:aview];
//    self.gcontrol = aview;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"<=>" style:1 target:self action:@selector(changeStyle)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)changeStyle{
    
    //网页控制器的使用
       BLWebViewController *vc = [[BLWebViewController alloc]initWithUrl:@"http://www.baidu.com"];
        vc.ProgressColor = [UIColor redColor];//设置进度条颜色
        vc.navigationController.hidesBarsOnSwipe = YES;
        vc.navagationBarColor = [UIColor yellowColor];//设置顶部颜色
        [self pushPage:vc Animated:YES];
//缓存
//    NSDictionary *data = @{@"xxx":@"yy"};
//    [[TMCache sharedCache] setObject:data forKey:@"myData"];
//    


}

@end
