//
//  UserModel.m
//  BL_BaseApp
//
//  Created by bolaa on 17/8/18.
//  Copyright © 2017年 王印. All rights reserved.
//

#import "UserModel.h"

@interface UserModel ()
- (void)updateCache;//当有用户信息属性变化的时候更新缓存
@end

@implementation UserModel

+(instancetype)currentUser{
    static UserModel *current = nil;
    if (!current) {
        if ([[TMCache sharedCache] objectForKey:@"user"]) {
            current = [[TMCache sharedCache] objectForKey:@"user"];
            
        }else{
            current = [[self alloc] init];
        }
    }
    return current;
}

+ (void)loginWithPhone:(NSString *)phone PassWord:(NSString *)passWord Compelete:(YINModelApiCompelet)block{
    //
    [[UserModel shareInstance] requstUrl:@"Member/login" WithParm:@{@"account":phone,@"password":passWord} Block:^(NETApiStatus status, NSString *message, id object) {
        UserModel *user = nil;
        if (status==NETApiSucess) {
//            user = [UserModel mj_objectWithKeyValues:object];
//            [[UserModel currentUser] clean];
//            [[UserModel currentUser] setNickname:user.nickname];
//            [[UserModel currentUser]setLogin:YES];
//            [[UserModel currentUser] updateCache];
        }
        if (block) {
            block(status,message,[UserModel currentUser]);
        }
    }];
}

- (void)loginOut{
    
    [self clean];
    // 移除所有用户信息。包括token
    [self updateCache];
}




- (void)clean{

    self.login = NO;
    self.nickname = @"";
}

- (void)updateCache{
    
    if (self.login) {
        [[TMCache sharedCache] setObject:self forKey:@"user"];
    }else{
        [[TMCache sharedCache] removeObjectForKey:@"user"];
    }
}




- (void)changeNikName:(NSString *)nikname Compelete:(YINModelApiCompelet)block{
    weakify(self);
    [self requstUrl:@"Member/modifyBaseData" WithParm:@{@"nickname":nikname} Block:^(NETApiStatus status, NSString *message, id object) {
        if (status==NETApiSucess) {
            weak_self.nickname = nikname;
            [weak_self updateCache];
        }
        if (block) {
            block(status,message,weak_self);
        }
    }];
}



+ (instancetype)shareInstance{
    static UserModel *instance = nil;
    if (!instance) {
        instance = [[UserModel alloc] init];
    }
    return instance;
}




@end
