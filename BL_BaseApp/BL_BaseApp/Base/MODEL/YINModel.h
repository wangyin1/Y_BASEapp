//
//  YINModel.h
//  BL_BaseApp
//
//  Created by bolaa on 17/5/18.
//  Copyright © 2017年 王印. All rights reserved.
//
#import "runtimeKit.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MJExtension.h"

@class YINModel;

typedef void(^ModelMapingBlock)();



//模型基类
@interface YINModel : NSObject<NSCoding>





//获取属性列表 返回 ｛ivarName ivarType｝
+ (NSArray <NSDictionary *> *)getField;


@end
