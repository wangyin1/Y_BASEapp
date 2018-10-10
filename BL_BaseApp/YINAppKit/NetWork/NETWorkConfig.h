//
//  NETWorkConfig.h
//  BL_BaseApp
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018年 王印. All rights reserved.
//

#import <Foundation/Foundation.h>


@class NETWorkConfig;

@class YINNetCallBackData;


@protocol NETWorkConfigDelegate <NSObject>

@required

- (NSDictionary *)parmWithBaseParm:(NSDictionary *)base;

- (NSString *)netUrlWithMethodUrl:(NSString *)url;

- (YINNetCallBackData *)callBackWithData:(id)responseObject;

@optional

@end

@interface YINNetCallBackData:NSObject

@property (assign,nonatomic) BOOL   ok;
@property (strong,nonatomic) id      data;
@property (copy,nonatomic) NSString *message;
@end


@interface NETWorkConfig : NSObject<NETWorkConfigDelegate>

+ (instancetype)shareInstace;

@end


