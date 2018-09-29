//
//  YINManage.m
//  BL_BaseApp
//
//  Created by apple on 2017/6/29.
//  Copyright © 2017年 王印. All rights reserved.
//

#import "YINManage.h"

@implementation YINManage

+ (instancetype)instance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance  = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (void)openWithData:(id)data{

    NSLog(@"请实现openWithData方法，用于打开此模块");
    
}

- (void)callMessage:(NSString *)message AndData:(id) data{
    NSLog(@"请实现callMessage AndData方法，用于模块间通信");
}

- (void)openPage:(UIViewController *)vc Animation:(OPENTYPE)animationtype{
    if (![UIApplication sharedApplication].delegate.window.rootViewController) {
        NSLog(@"请先添加root");
        return;
    }
    
    switch (animationtype) {
        case OPENTYPEPUSH:
        {
            if ([[UIApplication sharedApplication].delegate.window.topMostController navigationController]) {
                [[UIApplication sharedApplication].delegate.window.topMostController.navigationController pushViewController:vc animated:YES];
            }else{
                NSLog(@"当前控制器不支持push");
            }
        }
            break;
        case OPENTYPEPRESENT:
        {
            [[UIApplication sharedApplication].delegate.window.topMostController presentViewController:vc animated:YES completion:^{
                
            }];
        }
            break;
            
        case OPENTYPENULL:{
            if ([[UIApplication sharedApplication].delegate.window.topMostController navigationController]) {
                [[UIApplication sharedApplication].delegate.window.topMostController.navigationController pushViewController:vc animated:NO];
            }else{
                [[UIApplication sharedApplication].delegate.window.topMostController presentViewController:vc animated:NO completion:^{
                    
                }];
            }
        }
            break;
            
        default:
            break;
    }
}
@end
