//
//  HttpResult.h
//  BL_BaseApp
//
//  Created by apple on 2017/6/22.
//  Copyright © 2017年 王印. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpResult : NSObject

/**
 业务是否成功
 */
@property(nonatomic,assign)BOOL  isSucceed;

/**
 状态码   -1为链接错误
 */
@property(nonatomic,copy)NSString *code;

/**
 返回提示信息
 */
@property(nonatomic,copy)NSString *message;

/**
 报文体
 */
@property(nonatomic,strong)id     object;



- (instancetype)initWithData:(NSDictionary *)data;
@end
