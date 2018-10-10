//
//  YINBindObj.h
//  BL_BaseApp
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 王印. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MJExtension.h"
#import <objc/runtime.h>

//回调 bind： 哪绑定源一个发生了变化。property：对应的什么属性变化了
typedef void(^YINMappingBlock)(NSObject *bind,NSString *property);


@interface YINBindObj : NSObject
@property (weak,nonatomic,readonly) NSObject  *obj;
@property (copy,nonatomic,readonly) NSMutableArray   *bindPs;
@property (copy,nonatomic) NSMutableArray<YINMappingBlock>  *mappings;

+ (instancetype)obj:(id)obj;
+ (instancetype)obj:(id)obj keyPaths:(NSArray <NSString *>*)keyPaths;
+ (instancetype)obj:(id)obj keyPath:(NSString *)keyPath;



@property (assign,nonatomic) BOOL           change;
- (void)didBinded;
- (void)removeBind;
@end
