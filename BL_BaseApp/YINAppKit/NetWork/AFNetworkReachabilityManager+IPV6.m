//
//  AFNetworkReachabilityManager+IPV6.m
//  BL_BaseApp
//
//  Created by apple on 2018/9/20.
//  Copyright © 2018年 王印. All rights reserved.
//

#import "AFNetworkReachabilityManager+IPV6.h"
#import<objc/runtime.h>
@implementation AFNetworkReachabilityManager (IPV6)

+ (instancetype)ipv6_sharedManager {
    static AFNetworkReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct sockaddr_in address;
        bzero(&address, sizeof(address));
        address.sin_len = sizeof(address);
        address.sin_family = AF_INET6;
        
        _sharedManager = [self managerForAddress:&address];
    });
    return _sharedManager;
}

+(void)load{
    NSString*className=NSStringFromClass(self.class);
    NSLog(@"classname%@",className);
    static dispatch_once_t ipv6onceToken;
    dispatch_once(&ipv6onceToken,^{
        Class class=[self class];
        
        //Whenswizzlingaclassmethod,usethefollowing:
        //Classclass=object_getClass((id)self);
        
        SEL originalSelector=@selector(sharedManager);
        SEL swizzledSelector=@selector(ipv6_sharedManager);
        
        Method originalMethod=class_getClassMethod(class,originalSelector);
        Method swizzledMethod=class_getClassMethod(class,swizzledSelector);
        
        BOOL didAddMethod=
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if(didAddMethod){
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod,swizzledMethod);
        }
    });
}


@end
