//
//  YINModel.m
//  BL_BaseApp
//
//  Created by bolaa on 17/5/18.
//  Copyright © 2017年 王印. All rights reserved.
//
#import "Aspects.h"
#import "YINModel.h"
#import "TMCache.h"

@interface YINModel ()
@property(nonatomic,assign)BOOL  valueChangetag;

@end

@implementation YINModel
- (void)dealloc
{
    
}




+(NSArray<NSDictionary *> *)getField{
    return [runtimeKit fetchIvarClass:self];
}

#pragma mark 实现copying协议
- (id)copyWithZone:(nullable NSZone *)zone{
    id object = [super init];
    for (NSDictionary *dic in [runtimeKit fetchIvarClass:self.class]) {
        [object setObject:[self valueForKey:dic[@"ivarName"]] forKey:dic[@"ivarName"]];
    }
    return object;
}

#pragma mark runtime实现归档解档  便于用tmcache直接缓存对象
- (void)encodeWithCoder:(NSCoder *)aCoder{
    for (NSDictionary *dic in [runtimeKit fetchIvarClass:self.class]) {
        [aCoder encodeObject:[self valueForKey:dic[@"ivarName"]] forKey:dic[@"ivarName"]];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        for (NSDictionary *dic in [runtimeKit fetchIvarClass:self.class]) {
            [self setValue:[coder decodeObjectForKey:dic[@"ivarName"]] forKey:dic[@"ivarName"]];
        }
    }
    return self;
}

#pragma mark mjkeyvalue

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 从字典中取值用的key
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)mj_objectClassInArray{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [self mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
        if (property.type.typeClass) {
            [dic setObject:property.type.typeClass forKey:property.name];
        }
    }];
    return dic;
}
@end
