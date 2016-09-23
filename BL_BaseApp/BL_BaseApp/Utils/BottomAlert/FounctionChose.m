//
//  FounctionChose.m
//  seller
//
//  Created by 王印 on 16/4/27.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "FounctionChose.h"

@interface FounctionChose ()
@property(nonatomic,strong)NSArray      *dataList;
@property(nonatomic,copy)FounctionChoseBlock     block;
@property(nonatomic,strong)UIView       *founctionView;
@end

@implementation FounctionChose

- (instancetype)initWithDataList:(NSArray *)dataList choseBlock:(FounctionChoseBlock)block
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.5];
        self.dataList = dataList;
        self.block = block;
        self.founctionView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHight, ScreenWith, 45*dataList.count+6)];
        self.founctionView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.founctionView];
        for (int i = 0 ; i<dataList.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0,[dataList[i] isEqualToString:@"取消"]?i*45+6:i*45, ScreenWith, 45);
            [button setTitle:dataList[i] forState:0];
            button.tintColor = [UIColor blackColor];
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.backgroundColor = [UIColor whiteColor];
            button.tag = 100+i;
            [self.founctionView addSubview:button];
            [button addTarget:self action:@selector(choseOne:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self show];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
+ (void)showWithDataList:(NSArray *)dataList choseBlock:(FounctionChoseBlock)block{
    FounctionChose *chose = [[FounctionChose alloc]initWithDataList:dataList choseBlock:block];
    [[MYAPP window]addSubview:chose];
}
- (void)show{
    [UIView animateWithDuration:.3 animations:^{
        self.founctionView.frame = CGRectMake(0, ScreenHight-45*self.dataList.count, ScreenWith, 45*self.dataList.count+6);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)dismiss{
    [UIView animateWithDuration:.3 animations:^{
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0];
        self.founctionView.frame = CGRectMake(0, ScreenHight, ScreenWith, 45*self.dataList.count+6);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)choseOne:(UIButton *)sender{
    
    if (self.block&&![sender.titleLabel.text isEqualToString:@"取消"]) {
        self.block(sender.titleLabel.text,sender.tag-100);
    }
    [self dismiss];
}


@end
