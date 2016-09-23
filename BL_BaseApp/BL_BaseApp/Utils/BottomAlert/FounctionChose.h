//
//  FounctionChose.h
//  seller
//
//  Created by 王印 on 16/4/27.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FounctionChoseBlock)(NSString *buttonTitle,NSInteger index);

@interface FounctionChose : UIView

/**
 *  弹出底部选择器，仿微信 当传入“取消" 时，点击取消无回调
 *
 *  @param dataList 显示的选项卡名称数组
 *  @param block    回调名称和下标
 */
+ (void)showWithDataList:(NSArray *)dataList choseBlock:(FounctionChoseBlock)block;

@end
