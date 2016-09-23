//
//  NSObject+Format.m
//  buyer
//
//  Created by 王印 on 16/6/3.
//  Copyright © 2016年 hz. All rights reserved.
//

#import "NSDictionary+Format.h"

@implementation NSDictionary (Format)

- (NSDictionary *)format{
    
        NSMutableDictionary *res=[[NSMutableDictionary alloc] init];
        for (NSString *key in self.allKeys) {
            if (![[self objectForKey:key] isEqual:[NSNull null]]) {
                [res setObject:self[key] forKey:[key mj_camelFromUnderline]];
            }
        }
        return res;
}


@end
