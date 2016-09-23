//
//  HttpTool.h
//  BL_BaseApp
//
//  Created by 王印 on 16/9/5.
//  Copyright © 2016年 王印. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface HttpTool : NSObject



typedef NS_ENUM(NSInteger, HttpCacheType) {
    HttpCacheTypeNormal=0,//普通请求不缓存数据
    HttpCacheTypeRequest//请求并使用缓存(有缓存就使用缓存不发起请求)
};



typedef NS_ENUM(NSInteger, HttpRequestType) {
    
    HttpRequestTypeGet=0,
    
    HttpRequestTypePost
};

typedef void (^successBlock)(id obj);


typedef void (^failureBlocks)(NSError *error);
typedef void (^clearHttpCacheBlock)();
typedef void (^clearHttpExpiredCacheBlock)();

/**
 *  总的请求，包含cache
 *
 *  @param cacheType   缓存的类型
 *  @param requestType  请求类型
 *  @param params 请求的参数
 *  @param oldData 返回历史数据的回调
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)requestHttpWithCacheType:(HttpCacheType)cacheType requestType:(HttpRequestType)requestType  url:(NSString *)url params:(NSDictionary *)params OldDataBlock:(successBlock)oldData success:(successBlock)success failure:(void (^)(NSError *))failure;


+ (void)clearAllLocalHttpCache:(clearHttpCacheBlock)block;/**<清除所有本地http缓存*/


@end

