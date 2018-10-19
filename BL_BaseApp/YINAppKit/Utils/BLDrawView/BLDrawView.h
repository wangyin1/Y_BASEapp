//
//  BLDrawView.h
//  BL_BaseApp
//
//  Created by 王印 on 16/8/31.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>


/*-----------------------------------------------------*/
/**
 *  注意：！！！！ 绘图的所有方法可参考UIView+ZQuartz文件！！！！
 
 BLDrawView *aview = [[BLDrawView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
 [aview addDrawMethod:^(BLDrawView *drawView) {
 
 [drawView drawRectangle:CGRectMake(20, 10, 30, 30)];
 
 }];
 
 [aview addDrawMethod:^(BLDrawView *drawView) {
 
 [drawView drawText:drawView.bounds text:@"文字" fontSize:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
 }];
 *
 */
/*-----------------------------------------------------*/

@class BLDrawView;

typedef void(^BLDrawViewMethod)(BLDrawView *drawView);

@interface BLDrawView : UIView

/**
 *
 *  添加绘图方法，调用draw的时候会根据所有的方法一起画出
 *  @param method
 */
- (void)addDrawMethod:(BLDrawViewMethod)method;

/**
 *  根据方法绘图（会先清除画布上的内容）
 *
 *  @return
 */
- (void)drawWithMethod:(BLDrawViewMethod)method;

/**
 *  //清除画布内容
 */
- (void)clearDraw;

/**
 *  //重新绘图
 */
- (void)draw;

/**
 *  返回已经保存的所有绘画方法
 *
 *  @return
 */
- (NSArray <BLDrawViewMethod> *)allDrawMenthods;

/**
 *  移除绘画方法,（会同时移除画布上对应的内容）
 *
 *  @param method
 */
- (void)removeMenthodAtIndex:(NSInteger)index;

@end
