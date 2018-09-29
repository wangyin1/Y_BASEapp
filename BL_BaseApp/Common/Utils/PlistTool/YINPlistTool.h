//
//  YINPlistTool.h
//  BL_BaseApp
//
//  Created by apple on 2018/1/8.
//  Copyright © 2018年 王印. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^YINPlistToolBlock)(BOOL ok,id object);



//默认的plist文件名
static NSString *YINDefaltPlistName = @"yindefaltPlistName";

//如果key为nil 则value必须是数组， 整个plist文件就是一个数组文件。如果key有值 则plist文件为一个字典文件

@interface YINPlistTool : NSObject

//读写方法
+ (void)getDataFromPlist:(NSString *)plistName Key:(NSString *)key Block:(YINPlistToolBlock)block;

+ (void)writeDataToPlist:(NSString *)plistName Key:(NSString *)key Value:(id)value Block:(YINPlistToolBlock)block;


//使用默认的plist文件  进行读写
+ (void)writeDataToPlistKey:(NSString *)key Value:(id)value Block:(YINPlistToolBlock)block;

+ (void)getDataFromPlistKey:(NSString *)key Block:(YINPlistToolBlock)block;

@end
