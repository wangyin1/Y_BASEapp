//
//  NETManger.h
//  yipingcang
//
//  Created by xgh on 16/1/20.
//  Copyright © 2016年 王印. All rights reserved.
//


typedef enum : NSUInteger {
    NETApiSucess,//成功
    NETApiOld,//历史数据
    NETApiFalied,//失败
    NETApiProgress,//进度 下载上传文件时会有这个状态
} NETApiStatus;


//网络回调 object数据类型根据具体而定 一般是服务端响应字典中的data 在以下方法内自定义
//- (id)callBackWithData: Url: Block:
//下载上传文件时object为进度字典 格式为{@"current":@"10",@"total":@"200"}
typedef void(^NETsucess)(NETApiStatus status,NSString *message,id object);

@class NETManger;
#import "AFNetworking.h"
#import <Foundation/Foundation.h>

@protocol  NETMangerReslutDelegate<NSObject>

@required


@optional

//后台业务逻辑成功
- (void)nETManger:(NETManger *)Api Url:(NSString *)url SucessWithData:(NSDictionary *)data;

//后台业务逻辑失败
- (void)nETManger:(NETManger *)Api Url:(NSString *)url FalierWithData:(NSDictionary *)data Reason:(NSString *)reasonString;


//返回接口历史缓存数据
- (void)nETManger:(NETManger *)Api Url:(NSString *)url GetOldRequestData:(NSDictionary *)data;

//通常指网络连接失败 或者服务器没有此方法等
- (void)nETManger:(NETManger *)Api ConnectFaileWithReason:(NSString *)reason;

//返回是否当网络情况不可用时 记录当前网络访问 当网络情况良好时 重新发起 
- (BOOL)nETManger:(NETManger *)Api NetStatusChange:(AFNetworkReachabilityStatus)status;

@end



//网络api尽量在model访问 避免跨层访问 如果使用协议接受回调则有断网后重新连接并重新获取未完成接口的功能
@interface NETManger : NSObject


@property(nonatomic,weak)id<NETMangerReslutDelegate> delegate;

+ (instancetype)shareInstance;//具体子类如果要使用单利模式必须重写这个方法

@property(nonatomic,readonly) AFHTTPRequestOperationManager *httpRequestManager;


//------------------------------------自定义start-------------------
//这里根据项目需要做相应改动
//拼接地址
- (NSString *)netUrlWithMethodUrl:(NSString *)url;
//在这里平接全局参数
- (NSDictionary *)parmWithBaseParm:(NSDictionary *)base;
//实现回调
- (id)callBackWithData:(id)responseObject Url:(NSString *)url Block:(NETsucess)block;
//------------------------------------自定义end-------------------


//如果不传block 则走delegate方法回调
+ (void)requstUrl:(NSString *)url WithParm:(NSDictionary *)parm Block:(NETsucess)block;

+ (void)postUrl:(NSString *)url WithImageParm:(NSDictionary *)imageParm BasePram:(NSDictionary *)basePram Block:(NETsucess)block;

- (void)requstUrl:(NSString *)url WithParm:(NSDictionary *)parm Block:(NETsucess)block;

- (void)postUrl:(NSString *)url WithImageParm:(NSDictionary *)imageParm BasePram:(NSDictionary *)basePram Block:(NETsucess)block;




/**
 
 *  请求接口
 *
 *  @param url          接口地址
 *  @param parm         参数
 */
- (void)requstUrl:(NSString *)url WithParm:(NSDictionary *)parm;

- (void)postUrl:(NSString *)url WithImageParm:(NSDictionary *)imageParm BasePram:(NSDictionary *)basePram;

- (AFNetworkReachabilityStatus)netStatus;

//取消请求
- (void)cancelHTTPOperationsWithUrl:(NSString *)url;

- (void)cancelAllOperation;

- (void)downLoadUrl:(NSString *)url ToFile:(NSString *)file  Block:(NETsucess)block;

- (void)stopDownLoadUrl:(NSString *)url;
@end
