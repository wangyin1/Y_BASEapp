//
//  UserModel.h
//  BL_BaseApp
//
//  Created by bolaa on 17/8/18.
//  Copyright © 2017年 王印. All rights reserved.
//

#import "YINModel.h"
#import "TMCache.h"


@interface UserModel : YINModel

@property(nonatomic,assign)BOOL     login;//是否登录

@property(nonatomic,copy)NSString   *nickname;

+ (instancetype)currentUser;//获取当前登录用户 带缓存

//登录
+ (void)loginWithPhone:(NSString *)phone PassWord:(NSString *)passWord Compelete:(YINModelApiCompelet)block;

//改变昵称
- (void)changeNikName:(NSString *)nikname Compelete:(YINModelApiCompelet)block;

    



@end
