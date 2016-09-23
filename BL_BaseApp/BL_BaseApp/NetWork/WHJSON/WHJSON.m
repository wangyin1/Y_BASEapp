//
//  WHJSON.m
//  车信帮
//
//  Created by 王印 on 15/9/18.
//  Copyright © 2015年 王印. All rights reserved.
//

#import "WHJSON.h"

@implementation WHJSON

+ (NSString *)jsonStringWithObject:(id)object
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return jsonString;
}

+ ( id)objectFormJsonString:(NSString *)json
{

    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    id weatherDic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return weatherDic;
}


+ ( id)objectFormJsonData:(NSData *)jsondata
{

    id weatherDic = [NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:nil];
    return weatherDic;
}
@end

@implementation NSObject (Json)

- (NSString *)JSONString
{
   return  [WHJSON jsonStringWithObject:self];
}

@end


@implementation NSString (ObjectForJson)

- (id)objectFromJSONString
{
    return [WHJSON objectFormJsonString:self];
}
@end
