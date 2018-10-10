//
//  NETWorkConfig.m
//  BL_BaseApp
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018年 王印. All rights reserved.
//

#import "NETWorkConfig.h"

@implementation YINNetCallBackData

@end

@implementation NETWorkConfig

+ (instancetype)shareInstace;{
    static NETWorkConfig *config = nil;
    if(!config){
        config = [[NETWorkConfig alloc] init];
    }
    return config;
}

//---------配置--------

- (YINNetCallBackData *)callBackWithData:(id)responseObject{
    // your code
    BOOL  sucees = YES;//逻辑判断 是否成功  此处根据后端接口协议做全局状态逻辑处理 比如弹出登陆页面 等
    if ([responseObject[@"code"] integerValue]==300) {
        //登录失效
        sucees = NO;
    }else if ([responseObject[@"code"] integerValue]==100){
        sucees = YES;
    }else if([responseObject[@"code"] integerValue]==400){
        sucees = NO;
    }else if ([responseObject[@"code"] integerValue]==200){//成功
        sucees = YES;
    }
    YINNetCallBackData *data = [[YINNetCallBackData alloc] init];
    data.ok = sucees;
    data.message = responseObject[@"msg"];
    data.data = responseObject[@"data"];
    return  data;
}

// 全局参数拼接逻辑
- (NSDictionary *)parmWithBaseParm:(NSDictionary *)base;{
    // your code
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:base];
    return muDic;
}

//拼接全接口路径
- (NSString *)netUrlWithMethodUrl:(NSString *)url;{
    // your code 
    return  url;
}
@end


