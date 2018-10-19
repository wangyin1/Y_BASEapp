//
//  YINPlistTool.m
//  BL_BaseApp
//
//  Created by apple on 2018/1/8.
//  Copyright © 2018年 王印. All rights reserved.
//

#import "YINPlistTool.h"

@implementation YINPlistTool

+ (void)getDataFromPlist:(NSString *)plistName Key:(NSString *)key Block:(YINPlistToolBlock)block{
   
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //沙盒获取路径
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [pathArray objectAtIndex:0];
        //获取文件的完整路径
        NSString *filePatch = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistName]];//没有会自动创建
        
        if (!key) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:filePatch];
            if (arr) {
                if (block) {
                    block(YES,arr);
                }
            }else{
                if (block) {
                    block(NO,nil);
                }
            }
        }else{
        
        NSMutableDictionary *sandBoxDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePatch];
        if (sandBoxDataDic==nil) {
            if (block) {
                block(NO,nil);
            }
        }else{
            if (block) {
                block(YES,[sandBoxDataDic objectForKey:key]);
            }
        }
        }
    });
}

+ (void)writeDataToPlist:(NSString *)plistName Key:(NSString *)key Value:(id)value Block:(YINPlistToolBlock)block{
    if (!value) {
        if (block) {
            block(NO,nil);
        }
        return;
    }
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        //这里使用位于沙盒的plist（程序会自动新建的那一个）
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [pathArray objectAtIndex:0];
        //获取文件的完整路径
        NSString *filePatch = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",plistName]];//没有会自动创
        if (!key&&[value isKindOfClass:[NSArray class]]) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
         
            [arr addObjectsFromArray:value];
            BOOL ok =  [arr writeToFile:filePatch atomically:YES];
            if (block) {
                block(ok,value);
            }
        }else{
        NSMutableDictionary *sandBoxDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:filePatch];
        if (!sandBoxDataDic) {
            sandBoxDataDic = @{}.mutableCopy;
        }
        sandBoxDataDic[key] = value;
        BOOL ok =  [sandBoxDataDic writeToFile:filePatch atomically:YES];
        if (block) {
            block(ok,value);
        }
        }
    });
}

//使用默认的plist文件  进行读写
+ (void)writeDataToPlistKey:(NSString *)key Value:(id)value Block:(YINPlistToolBlock)block{
      [self writeDataToPlist:YINDefaltPlistName Key:key Value:value Block:block];
}

+ (void)getDataFromPlistKey:(NSString *)key  Block:(YINPlistToolBlock)block{
     [self getDataFromPlist:YINDefaltPlistName Key:key Block:block];
}

@end
