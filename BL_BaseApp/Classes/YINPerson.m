//
//  YINPerson.m
//  BL_BaseApp
//
//  Created by apple on 2018/9/28.
//  Copyright © 2018年 王印. All rights reserved.
//

#import "YINPerson.h"

@interface YINPerson()

@end

@implementation YINPerson
- (void)dealloc
{
    
}
- (NSString *)name{
    if (!_name) {
        _name = @"wy";
    }
    return _name;
}

- (NSString *)sex{
    if (!_sex) {
        _sex = @"男";
    }
    return _sex;
}
@end
