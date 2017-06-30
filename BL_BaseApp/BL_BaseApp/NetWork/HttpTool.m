//
//  HttpTool.m
//  BL_BaseApp
//
//  Created by 王印 on 16/9/5.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "NSString+Password.h"
#import "NSDictionary+Category.h"
#import "TMCache.h"
NSString *const HttpCacheArrayKey = @"HttpCacheArrayKey";
NSString *const HttpPasswordKey = @"GUIDKey";
#define isbeforeIOS7 ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0?YES:NO)
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define NSStringIsNullOrEmpty(string) ({NSString *str=(string);(str==nil || [str isEqual:[NSNull null]] ||  str.length == 0 || [str isKindOfClass:[NSNull class]] || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])?YES:NO;})

/**
 *  用来封装文件数据的模型
 */
@interface HttpToolFormData : NSObject
/**
 *  文件数据
 */
@property (nonatomic, strong) NSData *data;

/**
 *  参数名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  文件名 必须加后缀
 */
@property (nonatomic, copy) NSString *filename;

/**
 *  文件类型
 */
@property (nonatomic, copy) NSString *mimeType;

@end



/**
 *  用来封装文件数据的模型
 */
@implementation HttpToolFormData

@end

@interface HttpTool ()
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;


/**
 *  发送一个POST请求(上传文件数据)
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param formData  文件参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;


/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
@end

@implementation HttpTool
+ (void)initialize{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark - 网络请求前处理，无网络不请求
+(BOOL)requestBeforeCheckNetWorkWithFailureBlock:(failureBlocks)errorBlock{
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        errorBlock([[NSError alloc] initWithDomain:@"http" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"请检查网络设置"}]);
    }
    return   [AFNetworkReachabilityManager sharedManager].reachable;
}

#pragma mark - 网络请求带缓存
+ (void)requestHttpWithCacheType:(HttpCacheType)cacheType requestType:(HttpRequestType)requestType url:(NSString *)url params:(NSDictionary *)params  OldDataBlock:(successBlock)oldData success:(successBlock)success failure:(void (^)(NSError *))failure
{
    switch (cacheType) {
        case HttpCacheTypeNormal:
            if (requestType == HttpRequestTypeGet) {
                [self getWithURL:url params:params success:success failure:failure];
            }else{
                [self postWithURL:url params:params success:success failure:failure];
            }
            break;
            
        case HttpCacheTypeRequest:{
            NSString *cacheKey = [self getHttpCacheKeyWithUrl:url param:params];
            
            id obj;
            obj = [self getCacheObj:cacheKey]; //[USER_DEFAULT objectForKey:cacheKey];
            if (obj&&oldData) {
                oldData(obj);//如果有历史数据，返回历史数据
            }
            
            if (requestType == HttpRequestTypeGet) {
                [self getWithURL:url params:params success:^(id json) {
                    if (json) {
                        [self saveHttpCacheObjectWith:url param:params obj:json];
                        success(json);
                    }
                } failure:failure];
            }else{
                [self postWithURL:url params:params success:^(id json) {
                    if (json) {
                        [self saveHttpCacheObjectWith:url param:params  obj:json];
                        success(json);
                    }
                } failure:failure];
            }
            break;
        }
        default:
            break;
    }
}


#pragma mark - post
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(void (^)(NSError *))failure
{    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(![self requestBeforeCheckNetWorkWithFailureBlock:failure]){
            return;
        }
        //为url编码
        NSString *urlStr = [self urlCoding:url];
       
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (success) {
                success(responseObject);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            
            if (failure) {
                DLog(@"网络请求日志\n请求URL：%@ \n信息：%@",url,[error.userInfo objectForKey:@"NSLocalizedDescription"]);
                failure(error);
            }
        }];
        
        
        
    });
    
}

#pragma mark  post 文件请求formData
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params formDataArray:(NSArray *)formDataArray success:(successBlock)success failure:(void (^)(NSError *))failure
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(![self requestBeforeCheckNetWorkWithFailureBlock:failure]){
            return;
        }
        //为url编码
        NSString *urlStr = [self urlCoding:url];
         AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull totalFormData) {
            for (HttpToolFormData *formData in formDataArray) {
                [totalFormData appendPartWithFileData:formData.data name:formData.name fileName:formData.filename mimeType:formData.mimeType];
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (failure) {
                DLog(@"网络请求日志\n请求URL：%@ \n信息：%@",url,[error.userInfo objectForKey:@"NSLocalizedDescription"]);
                failure(error);
            }
        }];
    });
    
}

#pragma mark  get请求
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(successBlock)success failure:(void (^)(NSError *))failure
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if(![self requestBeforeCheckNetWorkWithFailureBlock:failure]){
            return;
        }
        //为url编码
        NSString *urlStr = [self urlCoding:url];
        // 2.发送请求
        
        
        [[self getHttpSessionManager] GET:urlStr parameters:params  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            
            
            if (failure) {
                DLog(@"网络请求日志\n请求URL：%@ \n信息：%@",url,[error.userInfo objectForKey:@"NSLocalizedDescription"]);
                failure(error);
            }
            
        }];
        
    });
    
}

#pragma mark 创建请求管理对象
+ (AFHTTPSessionManager *)getHttpSessionManager{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",                                                                               @"text/plain",                                                                               @"application/json",nil];
    // 加上这行代码，https ssl 验证。
    if (SSLNAME.length>0) {
        [manager setSecurityPolicy:[self customSecurityPolicy]];
    }
    return manager;
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


#pragma mark url编码
+ (NSString *)urlCoding:(NSString *)url{
    NSString *encodePath ;
    if (isbeforeIOS7) {
        encodePath = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else{
        encodePath = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    }
    return encodePath;
}

#pragma mark - 加密/解密 缓存数据
#pragma mark 获取对象解密key
+ (NSString *) getObjectDecryptionKey{
    NSString *tmpStr = [[TMCache sharedCache] objectForKey:HttpPasswordKey];
    if (NSStringIsNullOrEmpty(tmpStr)) {
        NSString *guid = [NSString base64StringFromText:[NSString stringWithGUID]];
        tmpStr = guid;
        [[TMCache sharedCache] setObject:guid forKey:HttpPasswordKey];
        //        [USER_DEFAULT synchronize];
    }
    return tmpStr;
}

#pragma mark 加密保存缓存对象
+ (void)saveCacheObj:(id)obj key:(NSString *)key{
    NSString *objStr = [NSDictionary dictionaryToJson:obj];
    NSString *pwdKey = [NSString textFromBase64String:[self getObjectDecryptionKey]];
    NSString *desObjStr = [NSString DESEncryptSting:objStr key:pwdKey andDesiv:pwdKey];
    
    [[TMCache sharedCache] setObject:desObjStr forKey:key];
    //    [USER_DEFAULT synchronize];
}

#pragma mark 解密取出来的缓存对象
+ (id)getCacheObj:(NSString *)key{
    NSString *objStr = [[TMCache sharedCache] objectForKey:key];
    if (objStr) {
        NSString *pwdKey = [NSString textFromBase64String:[self getObjectDecryptionKey]];
        NSString *decryptPwd = [NSString DESDecryptWithDESString:objStr key:pwdKey andiV:pwdKey];
        NSDictionary *dicObj = [NSDictionary dictionaryWithJsonString:decryptPwd];
        return dicObj;
    }
    return nil;
}

#pragma mark - 缓存
#pragma mark 保存http缓存对象
+ (void)saveHttpCacheObjectWith:(NSString *)url param:(NSDictionary *)param  obj:(id)obj{
    NSString *md5CacheKey = [self getHttpCacheKeyWithUrl:url param:param];
    
    [self saveCacheObj:obj key:md5CacheKey];
    
    [self saveHttpCacheArrayWithKey:md5CacheKey];//保存cacheKey
   
}

#pragma mark 获取缓存key
+ (NSString *)getHttpCacheKeyWithUrl:(NSString *)url param:(NSDictionary *)param{
    NSString *paramStr = [param dictionaryToJson];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@%@",url,paramStr,@"cacheKey"];
    NSString *trimText = [cacheKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    NSString *md5CacheKey = [trimText MD5Digest];
    return md5CacheKey;
}


#pragma mark 保存http缓存对应的key 数组
+ (void)saveHttpCacheArrayWithKey:(NSString *)key{
    NSMutableDictionary *cacheDic = [[TMCache sharedCache] objectForKey:HttpCacheArrayKey];
    if (!cacheDic) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:key forKey:key];
        
        [[TMCache sharedCache] setObject:dic forKey:HttpCacheArrayKey];
        [USER_DEFAULT synchronize];
    }else{
        id obj = [cacheDic objectForKey:key];
        if (!obj) {
            [cacheDic setObject:key forKey:key];
            [[TMCache sharedCache] setObject:cacheDic forKey:HttpCacheArrayKey];
            [USER_DEFAULT synchronize];
        }
    }
}


#pragma mark 清除本地http缓存
+ (void)clearAllLocalHttpCache:(clearHttpCacheBlock)block{
    NSArray *arrs = (NSArray *)[[TMCache sharedCache] objectForKey:HttpCacheArrayKey];
    for (NSString *key in arrs) {
        [[TMCache sharedCache] removeObjectForKey:key];
    }
    [[TMCache sharedCache] removeObjectForKey:HttpCacheArrayKey];
    
    block();
}



#pragma mark - 日期对象获取
+ (NSDateFormatter *)getDateFormatter
{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        formatter  = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    });
    return formatter;
}


@end


