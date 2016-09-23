//
//  BLJSPatchManager.h
//  BL_BaseApp
//
//  Created by 王印 on 16/8/24.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLJSPatchManager : NSObject

+ (instancetype)shareManager;

/**
 *  设置补丁远程下载地址 每个版本url不同
 *
 *  @param url
 */
+ (void)setPatchUrl:(NSString *)url;

//下载补丁并使用 需要后台支持
+ (void)start;

//当前app版本的补丁文件地址url
+ (NSURL *)patchFileURL;
@end
