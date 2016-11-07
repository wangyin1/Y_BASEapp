//
//  UIFont+PX.h
//  BL_BaseApp
//
//  Created by 王印 on 16/10/25.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 当美工给的字体大小是px单位时，可通过此扩展来初始化font
 */

@interface UIFont (PX)

@property (nonatomic , assign,readonly) CGFloat pxSize;

/**
 粗体的字体

 @param pxSize px单位的字体大小

 @return
 */
+ (UIFont *)boldSystemFontOfPXSize:(CGFloat)pxSize;


/**
 默认字体

 @param pxSize px单位的字体大小

 @return
 */
+ (UIFont *)systemFontOfPXSize:(CGFloat)pxSize;
- (void)setHotData:(NSArray *)hotData
{
    if (_hotData!=hotData) {
        _hotData = hotData;
        NSInteger line = 0;//第几行
        NSInteger index = 0;//每行第几个
        for (int i = 0;i<hotData.count;i++) {
            NSString *title = [NSString stringWithFormat:@"  %@  ",hotData[i]];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:title forState:0];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTintColor:[UIColor blackColor]];
            button.backgroundColor = [UIColor whiteColor];
            button.tag = i+100;
            [button addTarget:self action:@selector(hotButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            CGFloat x = 0;
            if (index==0) {
                x = 0;
            }else{
                UIButton *button = [self.contentView viewWithTag:99+i];
                x = CGRectGetMaxX(button.frame)+1;
            }
            CGSize size = CGSizeMake((YHGetScreenWidth-22)/3.f, 35);
            if (size.width+x+10>self.view.bounds.size.width) {
                line+=1;
                index = 0;
                x = 0;
            }
            button.frame = CGRectMake(x, line*36, size.width, 35);
            [self.contentView addSubview:button];
            index+=1;
        }
        UIButton *button = [self.contentView viewWithTag:99+hotData.count];
        self.hight.constant = CGRectGetMaxY(button.frame);
        self.headerView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, self.hight.constant+(self.oldDataList.count>0?80:40));
        self.tableView.tableHeaderView = self.headerView;
    }
}



/**
 根据px大小获取pt大小

 @param px

 @return
 */
+ (CGFloat)ptForPx:(CGFloat)px;


/**
根据pt大小获取px大小

 @param pt

 @return
 */
+ (CGFloat)pxForPt:(CGFloat)pt;
@end
