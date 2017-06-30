//
//  NETManger.m
//  yipingcang
//
//  Created by xgh on 16/1/20.
//  Copyright © 2016年 王印. All rights reserved.
//
#import "MJExtension.h"
#import "AppDelegate.h"
#import "NETManger.h"
#import "HttpTool.h"
#import "AFNetworking.h"

@implementation NETManger

+ (void)requstUrl:(NSString *)url WithParm:(NSDictionary *)parm OldDataBlock:(NETsucess)oldDataBlock SucessBlock:(NETsucess)sucessBlock FalierBlock:(NETfalier)falierBolck{
    NSMutableDictionary *params = [parm mutableCopy];
    //根据情况增加全局参数
    NSString *postUrl = [NSString stringWithFormat:@"%@%@",BASEURL,url];
    
    [HttpTool requestHttpWithCacheType:HttpCacheTypeRequest requestType:HttpRequestTypePost url:postUrl params:parm OldDataBlock:^(id obj) {
        
        if (oldDataBlock) {
            HttpResult *res = [[HttpResult alloc] initWithData:obj];
            if (res.isSucceed) {
                oldDataBlock(res);
            }
        }
    }success:^(id obj) {
        if (sucessBlock) {
            HttpResult *res = [[HttpResult alloc] initWithData:obj];
            if (res.isSucceed) {
                sucessBlock(res);
            }else{
                if (falierBolck) {
                    falierBolck(res);
                }
                [MBProgressHUD showError:res.message];
            }
        }
    } failure:^(NSError *error) {
        if (falierBolck) {
            HttpResult *res = [[HttpResult alloc] init];
            res.isSucceed = NO;
            res.message = error.localizedDescription;
            res.code = @"-1";
            falierBolck(res);
        }
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}




+ (void)postUrl:(NSString *)url WithImageParm:(NSDictionary *)imageParm BasePram:(NSDictionary *)basePram SucessBlock:(NETsucess)sucessBlock FalierBlock:(NETfalier)falierBolck{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",                                                                               @"text/plain",                                                                               @"application/json",nil];
    if (SSLNAME.length>0) {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    // 显示进度
    
    NSMutableDictionary *params = [basePram mutableCopy];
    //根据情况增加全局参数
    //    [params setObject:TOKEN forKey:@"token"];
    NSString *postUrl =[NSString stringWithFormat:@"%@%@",BASEURL,url];
    [manager POST:postUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         for (NSString *key  in imageParm) {
             NSData * imageData =  [imageParm[key] isKindOfClass:[NSData class]]?imageParm[key]:[(UIImage *)imageParm[key] compressToSize:1024];
             
             // 上传filename
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             // 设置时间格式
             formatter.dateFormat = @"yyyyMMddHHmmss";
             NSString *str = [formatter stringFromDate:[NSDate date]];
             NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
             [formData appendPartWithFileData:imageData name:key fileName:fileName mimeType:@"image/jpeg"];
         }
     }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
             id object = [operation.responseString mj_JSONObject];
                 if (sucessBlock) {
             HttpResult *res = [[HttpResult alloc] initWithData:object];
             if (res.isSucceed) {
                 sucessBlock(res);
             }else{
                 if (falierBolck) {
                     falierBolck(res);
                 }
                 [MBProgressHUD showError:res.message];
             }
         }
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         if (falierBolck) {
             HttpResult *res = [[HttpResult alloc] init];
             res.isSucceed = NO;
             res.message = error.localizedDescription;
             res.code = @"-1";
             falierBolck(res);
         }
         [MBProgressHUD showError:error.localizedDescription];
     }];
    
}


+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:SSLNAME ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}



@end
