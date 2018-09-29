//
//  NSObject+YINMapping.h
//  BL_BaseApp
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 王印. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YINBindObj.h"

/**
 wangyin kvo响应链编程库
 */
@interface NSObject (YINMapping)


//------一旦某一个绑定数据源的属性发生变化的时候所有的mapping都会触发-------

//如果操作的数据源属性是可变数据 请用下面的方式：
    //[[_model mutableArrayValueForKey:@"modelArray"] addObject:str]

//####添加一个监听对象 并实现回调####
- (void)y_addBind:(YINBindObj *)obj Mapping:(YINMappingBlock)block;



//绑定 源
- (void)y_bindObjects:(NSArray <YINBindObj *> *)objs;
//添加绑定 源
- (void)y_addBindObject:(YINBindObj *)obj;
- (void)y_bindObject:(YINBindObj *)obj;

//移除监听 如果没有特殊需求 不用手动移除 ，因为在自己dealloc的时候会自动移除kvo
- (void)y_removeBinds:(NSArray <YINBindObj *> *)objs;
- (void)y_removeAllBind;
- (void)y_removeBind:(YINBindObj *)obj;

//当监听的源对象任何属性变化时 触发所有的有效mapping block
//添加mapping 一般情况 使用这个。
- (void)y_addMapping:(YINMappingBlock)block;
////清除block
//- (void)y_cleanMapping;

//移除监听 清除block
- (void)y_clear;
@end
