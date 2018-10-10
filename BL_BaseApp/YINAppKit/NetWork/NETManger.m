//
//  NETManger.m
//  yipingcang
//
//  Created by xgh on 16/1/20.
//  Copyright © 2016年 王印. All rights reserved.
//
#import "TMCache.h"
#import "MJExtension.h"
#import "AppDelegate.h"
#import "NETManger.h"
#import "NSString+Password.h"
#import "AFNetworkReachabilityManager+IPV6.h"
#import "YINPlistTool.h"
#import "NETWorkConfig.h"

NSString *const HttpCacheArrayKey = @"HttpCacheArrayKey_wy";
NSString *const HttpPasswordKey = @"GUIDKey_wy";

@interface NETManger ()

@property(nonatomic,strong)NSMutableArray       *waitoperationQueues;//网络中断后等待重新发起的请求

@property(nonatomic,strong) AFHTTPRequestOperationManager *httpRequestManager;
@property(nonatomic,strong) AFURLSessionManager *downloadManager;
@property(nonatomic,strong)NSFileHandle  *fileHandle;

@end

@implementation NETManger

//这里根据项目需要做相应改动
- (NSString *)netUrlWithMethodUrl:(NSString *)url{
    return [[NETWorkConfig shareInstace] netUrlWithMethodUrl:url];
//    return [NSString stringWithFormat:@"%@/%@",BASEURL,url];
}

//在这里平接全局参数
- (NSDictionary *)parmWithBaseParm:(NSDictionary *)base{
//    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:base];
//    [muDic setObject:@"testvalue" forKey:@"testkey"];
    return [[NETWorkConfig shareInstace] parmWithBaseParm:base];
//    return muDic;
}

//这里根据项目需要做相应改动
- (id)callBackWithData:(id)responseObject Url:(NSString *)url Block:(NETsucess)block{
    NSLog(@"%@",responseObject);
    YINNetCallBackData  *callBackData  = [[NETWorkConfig shareInstace] callBackWithData:responseObject];
    
    if (callBackData.ok) {
        if (block) {
            block(NETApiSucess,@"成功",callBackData.data);
        }else if (self.delegate&&[self.delegate respondsToSelector:@selector(nETManger:Url:SucessWithData:)]){
            [self.delegate nETManger:self Url:url SucessWithData:callBackData.data];
        }
        return callBackData.data;
    }else{
        if (block) {
            block(NETApiFalied,@"失败",callBackData.data);
        }else{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(nETManger:Url:FalierWithData:Reason:)]) {
                [self.delegate nETManger:self  Url:url FalierWithData:callBackData.data Reason:callBackData.message];
            }
        }
    }
    return nil;
}


- (void)dealloc
{
    [self cancelAllOperation];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
}


- (void)cancelAllOperation{
    [self.downloadManager.operationQueue cancelAllOperations];
    [self.httpRequestManager.operationQueue cancelAllOperations];
}

- (void)stopDownLoadUrl:(NSString *)url{

     NSString *pathToBeMatched = [self netUrlWithMethodUrl:url];
    
    for (NSOperation *operation in [self.downloadManager.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
        
        BOOL hasMatchingPath = [[[[(AFHTTPRequestOperation *)operation request] URL] path] isEqual:pathToBeMatched];
        
        if (hasMatchingPath) {
            [operation cancel];
        }
    }
}

- (void)cancelHTTPOperationsWithUrl:(NSString *)url{
    
    NSString *pathToBeMatched = [self netUrlWithMethodUrl:url];
    
    for (NSOperation *operation in [self.httpRequestManager.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
        BOOL hasMatchingPath = [[[[(AFHTTPRequestOperation *)operation request] URL] path] isEqual:pathToBeMatched];
        if (hasMatchingPath) {
            [operation cancel];
        }
    }
    for (NSOperation *operation in [self.downloadManager.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
        BOOL hasMatchingPath = [[[[(AFHTTPRequestOperation *)operation request] URL] path] isEqual:pathToBeMatched];
        if (hasMatchingPath) {
            [operation cancel];
        }
    }
}

- (AFNetworkReachabilityStatus)netStatus{
    return [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
}

+ (instancetype)shareInstance{
    SYNTH_SHARED_INSTANCE();
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifiactionNetStatusChange) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        
    }
    return self;
}


- (void)notifiactionNetStatusChange{
    weakify(self);
    AFNetworkReachabilityStatus status = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
    if (weak_self.delegate&&[weak_self.delegate respondsToSelector:@selector(nETManger:NetStatusChange:)]) {
        
        if ([weak_self.delegate nETManger:weak_self NetStatusChange:status]) {
            if (status==AFNetworkReachabilityStatusNotReachable) {
                
                for (NSOperation *operation in [weak_self.httpRequestManager.operationQueue operations]) {
                    if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
                        continue;
                    }
                    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[[(AFHTTPRequestOperation *)operation request] URL]];
                    req.HTTPMethod = [[(AFHTTPRequestOperation *)operation request] HTTPMethod];
                    req.HTTPBody = [[(AFHTTPRequestOperation *)operation request] HTTPBody];
                    req.allHTTPHeaderFields = [[(AFHTTPRequestOperation *)operation request] allHTTPHeaderFields];
                    [weak_self.waitoperationQueues addObject:req];
                }
                
            }else{
                NSArray *arr = [NSArray arrayWithArray:weak_self.waitoperationQueues];
                [weak_self.waitoperationQueues removeAllObjects];
                [arr enumerateObjectsUsingBlock:^(NSURLRequest   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [weak_self requst:obj Block:nil];
                }];
            }
        }
    }
}

- (void)requst:(NSURLRequest *)request Block:(NETsucess)block{
    
    NSString *url = [request.URL.absoluteString substringFromIndex:[request.URL.absoluteString rangeOfString:BASEURL].location+[request.URL.absoluteString rangeOfString:BASEURL].length+1];
    
    [self.httpRequestManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        id object = [operation.responseString mj_JSONObject];
  
        [self callBackWithData:object Url:url Block:block];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (block) {
            block(NETApiFalied,error.localizedDescription,nil);
        }else{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(nETManger: ConnectFaileWithReason:)]) {
                [self.delegate nETManger:self  ConnectFaileWithReason:error.localizedDescription];
            }
        }
    }];
}


+ (void)requstUrl:(NSString *)url WithParm:(NSDictionary *)parm Block:(NETsucess)block{
    [[self shareInstance] requstUrl:url
                           WithParm:parm Block:block];
}

+ (void)postUrl:(NSString *)url WithImageParm:(NSDictionary *)imageParm BasePram:(NSDictionary *)basePram Block:(NETsucess)block{
    [[self shareInstance] postUrl:url WithImageParm:imageParm BasePram:basePram Block:block];
}

- (void)postUrl:(NSString *)url WithImageParm:(NSDictionary *)imageParm BasePram:(NSDictionary *)basePram{
    [self postUrl:url WithImageParm:imageParm BasePram:basePram Block:nil];
}

- (void)postUrl:(NSString *)url WithImageParm:(NSDictionary *)imageParm BasePram:(NSDictionary *)basePram Block:(NETsucess)block{
    

    if (!imageParm||imageParm.allKeys.count==0) {
        
        NSString *cacheKey = [self getHttpCacheKeyWithUrl:url param:basePram];
        id obj = [self getCacheObj:cacheKey];
        if(obj){
            if (block) {
                block(NETApiOld,@"成功",obj);
            }else if (self.delegate&&[self.delegate respondsToSelector:@selector(nETManger:Url:SucessWithData:)]){
                [self.delegate nETManger:self Url:url GetOldRequestData:obj];
            }
        }
    }
    
    NSDictionary *params =[ self parmWithBaseParm:basePram];
    //根据情况增加全局参数
    //    [params setObject:TOKEN forKey:@"token"];
    NSString *postUrl = [self netUrlWithMethodUrl:url];
    [self.httpRequestManager POST:postUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
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
         
         
         id callBackValue = [self callBackWithData:object Url:url Block:block];
         
         if ( callBackValue) {
             if (!imageParm||imageParm.allKeys.count==0) {
                  [self saveHttpCacheObjectWith:url param:params obj:callBackValue];
             }
         }
        
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (block) {
             block(NETApiFalied,error.localizedDescription,nil);
         }else{
             if (self.delegate&&[self.delegate respondsToSelector:@selector(nETManger: ConnectFaileWithReason:)]) {
                 [self.delegate nETManger:self  ConnectFaileWithReason:error.localizedDescription];
             }
         }    }];
    
}


//下载文件，支持断点继续下载
- (void)downLoadUrl:(NSString *)url ToFile:(NSString *)file Block:(NETsucess)block{
    
    NSString *key = [[self netUrlWithMethodUrl:url] stringByAppendingString:file];
    NSString *currentKey = [key stringByAppendingString:@"current"];
    NSString *totalKey = [key stringByAppendingString:@"total"];
    
    __block  CGFloat currentLength = [[[TMCache sharedCache] objectForKey:currentKey] floatValue];
    __block CGFloat fileLength =  [[[TMCache sharedCache] objectForKey:totalKey] floatValue];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self netUrlWithMethodUrl:url]]];
    
    NSURLSessionDataTask *_downloadTask;
    
    if (currentLength>0) {
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
    }
        
    __weak typeof(self) weakSelf = self;
    _downloadTask = [self.downloadManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"dataTaskWithRequest");
        //下载完成
        if (error&&block) {
            block(NETApiFalied,error.localizedDescription,@{@"current":@(currentLength),@"total":@(fileLength)});
        }else if(block){
            block(NETApiSucess,@"下载完成",@{@"current":@(fileLength),@"total":@(fileLength)});
        }
        // 清空长度
        currentLength = 0;
        fileLength = 0;
        // 关闭fileHandle
        [weakSelf.fileHandle closeFile];
        weakSelf.fileHandle = nil;
    }];
    
    [self.downloadManager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
        NSLog(@"NSURLSessionResponseDisposition");
        // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
        
        fileLength = response.expectedContentLength + currentLength;
        [[TMCache sharedCache] setObject:@(fileLength) forKey:totalKey];
        // 沙盒文件路径
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:file];
        NSLog(@"File downloaded to: %@",path);
        // 创建一个空的文件到沙盒中
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if (![manager fileExistsAtPath:path]||currentLength==0) {
            // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
            [manager createFileAtPath:path contents:nil attributes:nil];
        }
        // 创建文件句柄
        weakSelf.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        
        // 允许处理服务器的响应，才会继续接收服务器返回的数据
        return NSURLSessionResponseAllow;
    }];
    
    [self.downloadManager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
        NSLog(@"setDataTaskDidReceiveDataBlock");
        // 指定数据的写入位置 -- 文件内容的最后面
        [weakSelf.fileHandle seekToEndOfFile];
        // 向沙盒写入数据
        [weakSelf.fileHandle writeData:data];
        // 拼接文件总长度
        currentLength += data.length;
        [[TMCache sharedCache] setObject:@(currentLength) forKey:currentKey];
        if (block) {
             block(NETApiProgress,@"正在下载",@{@"current":@(currentLength),@"total":@(fileLength)});
        }
    }];
    
    //执行Task
    [_downloadTask resume];
   
}


- (void)requstUrl:(NSString *)url WithParm:(NSDictionary *)parm{
    [self requstUrl:url
           WithParm:parm Block:nil];
}

- (void)requstUrl:(NSString *)url WithParm:(NSDictionary *)parm  Block:(NETsucess)block{
    NSDictionary *params = [self parmWithBaseParm:parm];
    NSString *postUrl = [self netUrlWithMethodUrl:url];
    NSString *cacheKey = [self getHttpCacheKeyWithUrl:url param:params];
    id obj = [self getCacheObj:cacheKey];
    if(obj){
        if (block) {
            block(NETApiOld,@"成功",obj);
        }else if (self.delegate&&[self.delegate respondsToSelector:@selector(nETManger:Url:SucessWithData:)]){
            [self.delegate nETManger:self Url:url GetOldRequestData:obj];
        }
    }
    [self.httpRequestManager POST:postUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id object = [operation.responseString mj_JSONObject];
        id callBackValue = [self callBackWithData:object Url:url Block:block];
        if ( callBackValue) {
            [self saveHttpCacheObjectWith:url param:params obj:callBackValue];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(NETApiFalied,error.localizedDescription,nil);
        }else{
            if (self.delegate&&[self.delegate respondsToSelector:@selector(nETManger: ConnectFaileWithReason:)]) {
                [self.delegate nETManger:self  ConnectFaileWithReason:error.localizedDescription];
            }
        }    }];
    
}



- (id)getCacheObj:(NSString *)key{
    NSString *objStr = [[TMCache sharedCache] objectForKey:key];
    if (objStr) {
        NSString *pwdKey = [NSString textFromBase64String:[self getObjectDecryptionKey]];
        NSString *decryptPwd = [NSString DESDecryptWithDESString:objStr key:pwdKey andiV:pwdKey];
        NSDictionary *dicObj = [decryptPwd mj_JSONObject];
        if ([dicObj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *mudic = [dicObj mutableCopy];
            [dicObj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull akey, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSString class]]&&[obj isEqualToString:@"yinNetCache.plist"]) {
                     dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                    [YINPlistTool getDataFromPlist:[NSString stringWithFormat:@"%@%@",key,akey] Key:nil Block:^(BOOL ok, id object) {
                        if (object) {
                              [mudic setObject:object forKey:akey];
                        }
                          dispatch_semaphore_signal(semaphore);
                    }];
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
#if !OS_OBJECT_USE_OBJC
                    dispatch_release(semaphore);
#endif
                }else{
                    
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *bmudic = @{}.mutableCopy;
                        [(NSDictionary *)obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull bkey, id  _Nonnull bobj, BOOL * _Nonnull stop) {
                            
                            if ([bobj isKindOfClass:[NSString class]]&&[bobj isEqualToString:@"yinNetCache.plist"]) {
                                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                                [YINPlistTool getDataFromPlist:[NSString stringWithFormat:@"%@%@%@",key,akey,bkey] Key:nil Block:^(BOOL ok, id object) {
                                    if (object) {
                                        [bmudic setObject:object forKey:bkey];
                                    }
                                    dispatch_semaphore_signal(semaphore);
                                }];
                                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
#if !OS_OBJECT_USE_OBJC
                                dispatch_release(semaphore);
#endif
                            }
                            [bmudic setObject:bobj forKey:bkey];
                        }];
                        [mudic setObject:bmudic forKey:akey];
                    }else{
                        
                    }
                }
            }];
            return mudic;
        }
        return dicObj;
    }else{
       __block id value = nil;
          dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [YINPlistTool getDataFromPlist:key Key:nil Block:^(BOOL ok, id object) {
            if (object) {
                value = object;
            }
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
#if !OS_OBJECT_USE_OBJC
        dispatch_release(semaphore);
#endif
        return value;
      
    }
}

- (void)saveHttpCacheObjectWith:(NSString *)url param:(NSDictionary *)param  obj:(id)obj{
    NSString *md5CacheKey = [self getHttpCacheKeyWithUrl:url param:param];
    [self saveCacheObj:obj key:md5CacheKey];
    [self saveHttpCacheArrayWithKey:md5CacheKey];//保存cacheKey
}

#pragma mark 加密保存缓存对象
- (void)saveCacheObj:(id)obj key:(NSString *)key{
    NSMutableDictionary *muDic = @{}.mutableCopy;
    if ([obj isKindOfClass:[NSDictionary class]]) {
        [(NSDictionary *)obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull akey, id  _Nonnull aobj, BOOL * _Nonnull stop) {
            if ([aobj isKindOfClass:[NSArray class]]) {
                [YINPlistTool writeDataToPlist:[key stringByAppendingString:akey] Key:nil Value:aobj Block:^(BOOL ok, id object) {
                }];
                [muDic setObject:@"yinNetCache.plist" forKey:akey];
            }else{
                if ([aobj isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *bmudic = @{}.mutableCopy;
                    [(NSDictionary *)aobj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull bkey, id  _Nonnull bobj, BOOL * _Nonnull stop) {
                        if ([bobj isKindOfClass:[NSArray class]]) {
                            [YINPlistTool writeDataToPlist:[[key stringByAppendingString:akey]stringByAppendingString:bkey] Key:nil Value:bobj Block:^(BOOL ok, id object) {
                            }];
                            [bmudic setObject:@"yinNetCache.plist" forKey:bkey];
                            
                        }else{
                            
                            [bmudic setObject:bobj forKey:bkey];
                        }
                    }];
                    [muDic setObject:bmudic forKey:akey];
                }else{
                    [muDic setObject:aobj forKey:akey];
                }
            }
        }];
    }else if ([obj isKindOfClass:[NSArray class]]){
        [YINPlistTool writeDataToPlist:key Key:nil Value:obj Block:^(BOOL ok, id object) {
        }];
        return;
    }
    NSString *objStr = [muDic mj_JSONString];
    NSString *pwdKey = [NSString textFromBase64String:[self getObjectDecryptionKey]];
    NSString *desObjStr = [NSString DESEncryptSting:objStr key:pwdKey andDesiv:pwdKey];
    
    [[TMCache sharedCache] setObject:desObjStr forKey:key];
}

#pragma mark 保存http缓存对应的key 数组
- (void)saveHttpCacheArrayWithKey:(NSString *)key{
    NSMutableDictionary *cacheDic = [[TMCache sharedCache] objectForKey:HttpCacheArrayKey];
    if (!cacheDic) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:key forKey:key];
        
        [[TMCache sharedCache] setObject:dic forKey:HttpCacheArrayKey];
        
    }else{
        id obj = [cacheDic objectForKey:key];
        if (!obj) {
            [cacheDic setObject:key forKey:key];
            [[TMCache sharedCache] setObject:cacheDic forKey:HttpCacheArrayKey];
            
        }
    }
}
- (NSString *) getObjectDecryptionKey{
    NSString *tmpStr = [[TMCache sharedCache] objectForKey:HttpPasswordKey];
    if (NSStringIsNullOrEmpty(tmpStr)) {
        NSString *guid = [NSString base64StringFromText:[NSString stringWithGUID]];
        tmpStr = guid;
        [[TMCache sharedCache] setObject:guid forKey:HttpPasswordKey];
    }
    return tmpStr;
}
#pragma mark 获取缓存key
- (NSString *)getHttpCacheKeyWithUrl:(NSString *)url param:(NSDictionary *)param{
    NSString *paramStr = [param mj_JSONString];
    NSString *cacheKey = [NSString stringWithFormat:@"%@%@%@",url,paramStr,@"cacheKey"];
    NSString *trimText = [cacheKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    NSString *md5CacheKey = [trimText MD5Digest];
    return md5CacheKey;
}



- (NSMutableArray *)waitoperationQueues{
    
    if (!_waitoperationQueues) {
        _waitoperationQueues = @[].mutableCopy;
    }
    return _waitoperationQueues;
}


- (AFHTTPRequestOperationManager *)httpRequestManager{
    if (!_httpRequestManager) {
         AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",                                                                               @"text/plain",                                                                               @"application/json",nil];
        _httpRequestManager = manager;
        manager.securityPolicy = [NETManger customSecurityPolicy];
    }
    return _httpRequestManager;
}


- (AFURLSessionManager *)downloadManager{
    if (!_downloadManager) {
        //创建传话管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        _downloadManager = manager;
        manager.securityPolicy = [NETManger customSecurityPolicy];
    }
    return _downloadManager;
}

+ (AFSecurityPolicy*)customSecurityPolicy
{
    if (!SSLNAME||SSLNAME.length<1) {
        
        
        return [AFSecurityPolicy defaultPolicy];
    }
    
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
