//
//  LHDemoViewController.m
//  BL_BaseApp
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 王印. All rights reserved.
//

#import "LHDemoViewController.h"
#import "iCarousel.h"
#import "UIView+Canvas.h"
#import "YINUI.h"
#import "YINLoadingButton.h"
//#import "NSObject+YINMapping.h"
#import "YINPerson.h"
#import "ReactiveObjC.h"
@interface LHDemoViewController ()<iCarouselDelegate,iCarouselDataSource>
@property (strong, nonatomic) IBOutlet UIView *alert;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet iCarousel *carousel;
@property (strong,nonatomic) NSMutableArray  *dataSource;
@property (strong,nonatomic) YINPerson *person;
@end

@implementation LHDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navLargeTitleMode = YES;
    self.title = @"test";
    _carousel.dataSource = self;
    _carousel.delegate = self;
    _carousel.bounces = NO;
    _carousel.pagingEnabled = YES;
    _carousel.type = iCarouselTypeCustom;
    self.dataSource = @[@{@"title":@"aaaddd"},@{@"title":@"bbbbbb"},@{@"title":@"cccccc"},@{@"title":@"dddddd"},@{@"title":@"eeeeee"}].mutableCopy;
    [_carousel reloadData];
    self.label.canvasType = CSAnimationTypeMorph;
    self.label.canvasDuration = 1;
    self.label.canvasDelay= 2;
    [self.label startCanvasAnimation];
    self.alert.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds)-200)/2.f, (CGRectGetHeight([UIScreen mainScreen].bounds)-200)/2.f, 200, 200);

//    [self.carousel y_addBind:[YINBindObj obj:self keyPath:@"dataSource"] Mapping:^(NSObject *bind,NSString *property) {
//         [_carousel reloadData];
//    }];
    
        __weak typeof(self)weakSelf = self;
    
    
    
    
    [[RACObserve(self, dataSource) filter:^BOOL(id  _Nullable value) {
        return  YES;
    }]subscribeNext:^(id  _Nullable x) {
         [_carousel reloadData];
    }];
    
//    [self.label y_addBind:[YINBindObj obj:self.person] Mapping:^(NSObject *bind,NSString *property) {
//        weakSelf.label.text = [_person.name stringByAppendingString:_person.sex];
//    }];
//
//    [self.label y_addBind:[YINBindObj obj:self.person keyPath:@"name"] Mapping:^(NSObject *bind, NSString *property) {
//         weakSelf.label.backgroundColor = arc4random()%2==1?[UIColor redColor]:[UIColor orangeColor];
//    }];
}

- (YINPerson *)person{
    if (!_person) {
        _person = [[YINPerson alloc] init];
    }
    return _person;
}

#pragma mark - iCarouselDataSource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.dataSource.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    if (view == nil) {
        CGFloat viewWidth = carousel.frame.size.width - 50*2;
        view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
        view.backgroundColor = [UIColor redColor];
    }
//    ((UILabel *)view).text = self.dataSource[index][@"title"];
    
    return view;
}

#pragma mark - iCarouselDelegate

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform {
    
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.6f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    return CATransform3DTranslate(transform, offset*self.carousel.itemWidth * 1.4, 0.0, 0.0);
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option==iCarouselOptionWrap) {
        return  YES;
    }
    return value;
}


- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
   
}

- (IBAction)click:(YINLoadingButton *)sender {
    [YINAlert showYinAlertWithContent:self.alert InSuperView:self.view AnimationType:YINAlertShowAnimationFromRight];
    [YINPhtoPicker choseWithMaxCount:8 controller:self getImagesBlock:^(NSArray<UIImage *> *images) {
        
    }];
    if (sender.isLoading) {
        [sender stopLoading];
    }else{
        [sender startLoading];
    }
    if (self.dataSource.count==0) {
        [[self mutableArrayValueForKeyPath:@"dataSource"] addObject:@""];
    }else{
        [[self mutableArrayValueForKeyPath:@"dataSource"] removeLastObject];
    }
    self.person.name = ({
        NSString *name = @"";
        if ([_person.name isEqualToString:@"wy"]) {
           name = @"xgh";
        }else{
             name =  @"wy";
        }
        name;
    });
    self.person.sex = @"女";
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
