//
//  NETManger.h
//  yipingcang
//
//  Created by xgh on 16/1/20.
//  Copyright © 2016年 王印. All rights reserved.
//
#import "HttpResult.h"


typedef void(^NETsucess)(HttpResult *reslut);
typedef void(^NETfalier)(HttpResult *reslut);

#import <Foundation/Foundation.h>


@interface NETManger : NSObject
/**
 *  请求接口
 *
 *  @param url          接口地址
 *  @param parm         参数
 *  @param oldDataBlock 缓存数据回调
 *  @param sucessBlock  请求成功回调
 *  @param falierBolck  失败回调
 */
+ (void)requstUrl:(NSString *)url WithParm:(NSDictionary *)parm OldDataBlock:(NETsucess)oldDataBlock SucessBlock:(NETsucess)sucessBlock FalierBlock:(NETfalier)falierBolck;


+ (void)postUrl:(NSString *)url WithImageParm:(NSDictionary *)imageParm BasePram:(NSDictionary *)basePram SucessBlock:(NETsucess)sucessBlock FalierBlock:(NETfalier)falierBolck;
@end
