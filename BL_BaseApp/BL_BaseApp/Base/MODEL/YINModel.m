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


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
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

@end
