//
//  BLLoginViewController.m
//  BL_BaseApp
//
//  Created by 王印 on 16/7/23.
//  Copyright © 2016年 王印. All rights reserved.

#import "UIViewController+HRAlertViewController.h"
#import "BLChoseImagesControl.h"
#import "BLLoginViewController.h"
#import "BLGroupPhotoControl.h"
#import <UIKit/UIKit.h>
#import "BLDrawView.h"
#import "BLWebViewController.h"
#import "UIView+ZQuartz.h"
#import "TMCache.h"
#import "runtimeKit.h"
#import "UIView+YinBorder.h"
#import "YINAccount.h"

@interface BLLoginViewController ()

@property(nonatomic,strong)UIView       *sub;
@property (nonatomic , strong) BLDrawView *gcontrol;
@property(nonatomic,strong)UILabel      *label;
@end

@implementation BLLoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navagationBarColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor greenColor];
    
    YINAccount *model = [YINAccount mj_objectWithKeyValues:@{@"name":@"wy",@"phone":@"15683701836"}];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 200, 50)];
    [self.view addSubview:self.label];
    
    __weak typeof(YINAccount *)weakmodel = model;
    [model addObserver:self.label ValueChangeBlock:^() {
        self.label.text = [weakmodel.name stringByAppendingString:weakmodel.phone];
    }];
    
    [model reload];
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
//        
//        [JGProgressHUD showWithStr:@"已安装qq" WithTime:2];
//    }else{
//        [JGProgressHUD showWithStr:@"请安装qq" WithTime:2];
//    }
//    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, 400, 200, 50)];
//    slider.maximumValue = 100;
//    slider.value = 100;
//    [slider y_makeBorderWithColor:[UIColor redColor] Radius:100 Inside:NO];
//    [slider addTarget:self action:@selector(changeSlider:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:slider];
//    
//    UIView *view = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 300, 200)];
//    view.backgroundColor = [UIColor blackColor];
//    
//    [view y_makeBorderWithColor:[UIColor blueColor] Width:20 Radius:50 Margin:0 Inside:NO];
//    [self.view addSubview:view];
//    self.sub = view;
//    
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
//    button.backgroundColor = [UIColor blackColor];
//    button.frame = CGRectMake(100, 300, 100, 50);
//    [button y_makeBorderWithColor:[UIColor orangeColor] Width:3 Radius:5 Margin:10 Inside:YES];
//    [button setTitle:@"点击" forState:0];
//    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
}

- (void)buttonPressed:(UIButton *)sender{
    //内外边框切换
    [self.sub y_makeBorderWithColor:self.sub.y_borderColor Width:self.sub.y_borderWidth Radius:self.sub.y_radius Margin:self.sub.y_borderMargin Inside:!self.sub.y_inside];
}

- (void)changeSlider:(UISlider *)sender{
    
    //改变边框圆角
     [sender y_makeBorderWithColor:[UIColor redColor] Radius:sender.value Inside:NO];
    
    //改变线条大小
    [self.sub y_makeBorderWithColor:[UIColor blueColor] Width:sender.value/5.f Radius:50 Margin:0 Inside:self.sub.y_inside];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.sub.frame = CGRectMake(100, 100, 200, 200);
}

- (void)viewDidLoadFinish
{
    [super viewDidLoadFinish];
    //九宫格控件
//    BLGroupPhotoControl *hopto = [[BLGroupPhotoControl alloc] initWithFrame:CGRectMake(0, 68, self.view.bounds.size.width, 10)];
//    hopto.images = @[@"http://scimg.jb51.net/allimg/160815/103-160Q509544OC.jpg",@"http://www.taopic.com/uploads/allimg/120421/107063-12042114025737.jpg"];//可传入本地图片和网络地址
//    hopto.canEdit = YES;//编辑状态，no为展示状态
//    [self.view addSubview:hopto];
//    
    
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
    
    NSString *html = @"/span>\r\n</p>\r\n<p style=\"line-height:150%\">\r\n    <span style=\"font-size:16px;line-height:150%;font-family:宋体\">　　呆账产生的原因是什么呢？一是时间较长或多次催讨无效，一是银行认为该笔欠款很难追回，将其上报给了上级相关部门。其中联系不上借款人是一个很常见的原因。</span>\r\n</p>\r\n<p style=\"line-height:150%\">\r\n    <span style=\"font-size:16px;line-height:150%;font-family:宋体\">　　呆账真的可以不用还吗？还有不少网友虽然看到“呆账”两个字有些受惊吓，但是另一方面又开始钻空子，觉得反正都形成呆账了，这笔欠款就不用还了。真的是这样吗？当然不是！呆账只是不再追加利息和罚息了，你的信报上显示呆账1000，你就只需要还款1000，没有新的滞纳金或是罚息，但该偿还的款项依然得还，否则它会跟着你一辈子，不受</span><a href=\"http://www.rong360.com/gl/2014/04/09/39952.html\" target=\"_blank\"><span style=\"font-size:16px;line-height:150%;font-family:宋体\">个人信用报告</span></a><span style=\"font-size:16px;line-height:150%;font-family:宋体\">5</span><span style=\"font-size:16px;line-height:150%;font-family:宋体\">年一更新的影响，永远成为你的不良印记，阻碍你未来的申贷、申卡之路。</span>\r\n</p>\r\n<p style=\"line-height:150%\">\r\n    <span style=\"font-size:16px;line-height:150%;font-family:宋体\">　　呆账的处理办法？和一般逾期不同，如果你是信用卡欠费产生的呆账，还清欠款以后，建议作信用卡销户处理，积极联系银行，呆账有可能变成“逾期”字眼。假设你是信用卡多还钱造成的溢缴款呆账，一般取现销户就行，这些呆账银行会积极处理。</span>\r\n</p>\r\n<p style=\"line-height:150%\">\r\n    <span style=\"font-size:16px;line-height:150%;font-family:宋体\">　　总之，呆账是一种非常糟糕的逾期情况，性质比一般逾期还要严重，小编建议大家还是按时还款，不要频繁更换手机和住址。</span>\r\n</p>\r\n<p>\r\n    <br/>\r\n</p>";
    //网页控制器的使用
       BLWebViewController *vc = [[BLWebViewController alloc]initWithHtml:html BaseUrl:nil];
    
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
