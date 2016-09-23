//
//  BLJSPatchManager.m
//  BL_BaseApp
//
//  Created by 王印 on 16/8/24.
//  Copyright © 2016年 王印. All rights reserved.
//
#import "BLMacro.h"
#import "JPEngine.h"
#import "BLJSPatchManager.h"
#import "AFNetworking.h"
@interface BLJSPatchManager ()

DIYObj_(NSURLSessionDownloadTask, downloadTask);
String_(patchUrl);

@end

@implementation BLJSPatchManager

//单例
+ (instancetype)shareManager {
    //单 构造器
    SYNTH_SHARED_INSTANCE();

}

+ (void)setPatchUrl:(NSString *)url{
    [BLJSPatchManager shareManager].patchUrl = url;
}

+ (void)start{
    [JPEngine startEngine];
    [self checkPatch];
}

+ (void)checkPatch{
    [[BLJSPatchManager shareManager] check];
}

- (void)check{
    
    //为了优化效率先加载以前的补丁，下载完之后加载新补丁
    
    [JPEngine evaluateScriptWithPath:[BLJSPatchManager patchFileURL].path];
    
    //远程地址
    NSURL *URL = [NSURL URLWithString:self.patchUrl];
    //默认配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //下载Task操作
    [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        return [BLJSPatchManager patchFileURL];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
         [JPEngine evaluateScriptWithPath:[BLJSPatchManager patchFileURL].path];
    }];
}

+ (NSURL *)patchFileURL{
    //以 patch＋版本号作为文件名存储
    NSString *cachesPath = [NSString filePathAtCachesWithFileName:[@"patch" stringByAppendingString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    
    return [NSURL fileURLWithPath:cachesPath];

}
@end
