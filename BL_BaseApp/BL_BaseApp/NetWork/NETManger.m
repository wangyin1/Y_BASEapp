//
//  NETManger.m
//  yipingcang
//
//  Created by xgh on 16/1/20.
//  Copyright © 2016年 王印. All rights reserved.
//
#import "AppDelegate.h"
#import "NETManger.h"
#import "HttpTool.h"
#import "AFNetworking.h"
@implementation NETManger

+ (void)requstUrl:(NSString *)url WithParm:(NSDictionary *)parm OldDataBlock:(NETsucess)oldDataBlock SucessBlock:(NETsucess)sucessBlock FalierBlock:(NETfalier)falierBolck{
    NSMutableDictionary *params = [parm mutableCopy];
    //根据情况增加全局参数
    NSString *postUrl = [NSString stringWithFormat:@"%@%@/api.php?%@",URLTYPE,BASEURL,url];
    
    [HttpTool requestHttpWithCacheType:HttpCacheTypeRequest requestType:HttpRequestTypePost url:postUrl params:parm OldDataBlock:oldDataBlock success:^(id obj) {
        if (sucessBlock) {
            sucessBlock(obj);
        }
    } failure:^(NSError *error) {
        [JGProgressHUD showWithStr:error.localizedDescription WithTime:2];
    }];
}




+ (void)postUrl:(NSString *)url WithImageParm:(NSDictionary *)imageParm BasePram:(NSDictionary *)basePram SucessBlock:(NETsucess)sucessBlock FalierBlock:(NETfalier)falierBolck{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",                                                                               @"text/plain",                                                                               @"application/json",nil];
    // 显示进度
    NSMutableDictionary *params = [basePram mutableCopy];
    //根据情况增加全局参数
//    [params setObject:TOKEN forKey:@"token"];
    NSString *postUrl =[NSString stringWithFormat:@"%@%@",BASEURL,url];
    [manager POST:postUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         for (NSString *key  in imageParm) {
             NSData * imageData =  [imageParm[key] isKindOfClass:[NSData class]]?imageParm[key]:UIImageJPEGRepresentation(imageParm[key], 0.6);
             
             NSData *newData = UIImagePNGRepresentation([UIImage imageWithData:imageData]);
             // 上传filename
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             // 设置时间格式
             formatter.dateFormat = @"yyyyMMddHHmmss";
             NSString *str = [formatter stringFromDate:[NSDate date]];
             NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
             [formData appendPartWithFileData:newData name:key fileName:fileName mimeType:@"image/jpeg"];
         }
         
     }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         
         if (sucessBlock) {
             id object = [operation.responseString objectFromJSONString];
             if ([object[@"status"] integerValue]!=1) {
                 [JGProgressHUD showWithStr:object[@"info"]WithTime:2];
             }
             sucessBlock(object);
         }
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         [JGProgressHUD showWithStr: error.localizedDescription WithTime:2];
         if (falierBolck) {
             falierBolck(error);
         }
     }];
    
}





+ (void)uploadImage:(NSDictionary *)imageParm Sucess:(NETsucess)sucessBlock Failer:(NETfalier)failerBlock{
    
    for (NSString *key in imageParm) {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:[NSString stringWithFormat:@"%@%@/api.php?%@",URLTYPE,BASEURL,@"api=system&method=upload_media_item"] parameters:@{@"module":@"customer"}  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

                NSData * imageData =  [imageParm[key] isKindOfClass:[NSData class]]?imageParm[key]:[imageParm[key] compressToSize:1024];
                NSData *newData = imageData;
                // 上传filename
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                [formData appendPartWithFileData:newData name:@"module" fileName:fileName mimeType:@"image/jpeg"];

        } success:^(NSURLSessionDataTask *task, id responseObject) {
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            if (failerBlock) {
                failerBlock(error.localizedDescription);
            }

        }];
    }
}

@end
