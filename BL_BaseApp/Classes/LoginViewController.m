//
//  LoginViewController.m
//  BL_BaseApp
//
//  Created by apple on 2017/7/3.
//  Copyright © 2017年 王印. All rights reserved.
//
#import "YINScrollView.h"

#import "LoginViewController.h"
#import "UserModel.h"

#import "YINAlert.h"
@interface LoginViewController ()<YINScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *passw;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@property (weak, nonatomic) IBOutlet YINScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIView *footer;

@property (nonatomic,strong)YINScrollView *notifyScrollView;
@property (nonatomic,strong)NSArray *datas;

@end

@implementation LoginViewController




- (void)viewDidLoad {
    [super viewDidLoad];
   

    
//    [[ChatHandler shareInstance] connectServerHost];
    self.navLargeTitleMode = NO;
    self.navagationBarColor = [UIColor redColor];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:1 target:self action:@selector(loginPressed:)];
    self.navigationItem.leftBarButtonItem = left;
    self.title = @"登录";
    self.navagationBarTextColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    if (ScreenHight<600) {
        self.topHeight.constant = 70;
    }
    self.headerView.frame = CGRectMake(0, 0, ScreenWith, ScreenHight<600?580:600);
//    self.tableView.tableHeaderView = self.headerView;
    self.scroll.autoLoop = YES;
    self.scroll.delegate = self;
    self.scroll.pageControlPostion = YINScrollPageControlPostionBottomRight;
    
//    self.notifyScrollView = [[YINScrollView alloc]initWithFrame:CGRectMake(0, 200, ScreenWith, 50)];
//    self.notifyScrollView.backgroundColor = [UIColor whiteColor];
//    self.notifyScrollView.autoLoop = YES;
//    self.notifyScrollView.delegate = self;
//    self.notifyScrollView.orientation = YINScrollOrientationVertical;
    self.datas = @[@{@"title":@"aaaddd"},@{@"title":@"bbbbbb"},@{@"title":@"cccccc"},@{@"title":@"dddddd"},@{@"title":@"eeeeee"}];
//    [self.view addSubview:self.notifyScrollView];
    self.tableView.tableFooterView = self.footer;

}




- (NSInteger)numberOfItemsForYINScrollView:(YINScrollView *)scrollView{
  
    return self.datas.count;
}

- (UIView *)yINScrollView:(YINScrollView *)scrollView itemForIndex:(NSInteger)index{
    if (scrollView == self.notifyScrollView) {
        UIView *view = [[UIView alloc]init];
        UIImageView *aImage = [[UIImageView alloc]init];
        aImage.backgroundColor = [UIColor redColor];
        [view addSubview:aImage];
        [aImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(view.mas_centerY);
            make.width.height.equalTo(@50);
        }];
        UILabel *label = [[UILabel alloc]init];
        label.text = self.datas[index][@"title"];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(aImage.mas_right).offset(5);
            make.centerY.equalTo(view.mas_centerY);
        }];
        return view;
    }
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:@"http://pic4.nipic.com/20091217/3885730_124701000519_2.jpg"] placeholderImage:nil];
    imageV.userInteractionEnabled = YES;
    return imageV;
}

- (void)yINScrollView:(YINScrollView *)scrollView didClickItem:(UIView *)item index:(NSInteger)index{
    
//    [YINPhtoPicker choseWithMaxCount:3 controller:self getImagesBlock:^(NSArray<UIImage *> *images) {
//        
//    }];
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:@"http://pic4.nipic.com/20091217/3885730_124701000519_2.jpg"] placeholderImage:nil];
    imageV.frame = CGRectMake((self.view.frame.size.width-100)/2.f, (self.view.frame.size.height-100)/2.f, 100, 100);
    imageV.userInteractionEnabled = YES;
  YINAlert *alert =  [YINAlert showYinAlertWithContent:imageV InSuperView:self.view AnimationType:YINAlertShowAnimationFromLeft];

}

- (IBAction)cleanText:(UIButton *)sender {
    [(UITextField *)[self.headerView viewWithTag:sender.tag-100] setText:@""];
}

- (IBAction)regesterPressed:(id)sender {
    BLBaseViewController *vc = [[BLBaseViewController alloc] init];
    vc.title  =@"2";
    vc.navagationBarColor = [UIColor blueColor];
    vc.navagationBarShadowLineHiden = NO;
    vc.navagationBarLucency = YES;
    vc.navagationBarTextColor = [UIColor blackColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)loginPressed:(id)sender {
    BLBaseViewController *vc = [[BLBaseViewController alloc] init];
    vc.title  =@"2";
    vc.navagationBarColor = [UIColor blueColor];
    vc.navagationBarShadowLineHiden = NO;
//    vc.navagationBarLucency = YES;
//    vc.navLargeTitleMode = YES;
    vc.navagationBarTextColor = [UIColor redColor];
    [self.navigationController pushViewController:vc animated:YES];
//    if (self.phone.text.length!=11) {
//        [MBProgressHUD showError:@"请输入11位数手机号"  ];
//        return;
//    }
//    if (self.passw.text.length==0) {
//        [MBProgressHUD showError:@"请输入密码"  ];
//        return;
//    }
//    [MBProgressHUD showMessage:@"登录" toView:self.view];
//
//    weakify(self);
//    [UserModel loginWithPhone:@"15683701836" PassWord:@"123456" Compelete:^(NETApiStatus status, NSString *message, UserModel *user ) {
//
//        [MBProgressHUD hideHUDForView:weak_self.view];
//    }];
//
//    [[ChatHandler shareInstance] sendText:@"2401" timeOut:<#(NSUInteger)#> tag:<#(long)#>]
}

- (IBAction)forgetPass:(id)sender {
   
}
- (IBAction)qqLogin:(id)sender {
    
    
    
}
- (IBAction)wxLogin:(id)sender {
    
 
}



- (void)closePage{

    if (self.parentViewController.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{

    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
