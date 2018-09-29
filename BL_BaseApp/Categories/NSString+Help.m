//
//  NSString+Help.m
//  seller
//
//  Created by huazhe on 16/6/8.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "NSString+Help.h"

@implementation NSString (Help)

-(NSAttributedString *)underLineAttributeString{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self];
    [str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, str.length)];
    return str;
}


#pragma mark time
-(NSString *)timeStringWithFormat:(TimeStrType)type{
    
    
    NSMutableString *newStr = [self mutableCopy];
    NSString *temp = nil;
    for(int i =0; i < [newStr length]; i++)
    {
        temp = [newStr substringWithRange:NSMakeRange(i, 1)];
        
        if (![temp validatePureInt]) {
            [newStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@":"];
        }
    }
    
    NSDateFormatter *formatter =  [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:newStr];
 
    
    switch (type) {
            
        case TimeStrTypeDefalt:{
            [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
        }
            
            break;
            
            
        case TimeStrTypeChinese:{
            [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
        }
            break;
        default:
            break;
    }
    
    
    return [formatter stringFromDate:date];
}

- (NSString *)timeStringFromFormat:(NSString *)from ToFormat:(NSString *)to{
    NSDateFormatter *formatter =  [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:from];
    NSDate *date = [formatter dateFromString:self];
    [formatter setDateFormat:to];
    return [formatter stringFromDate:date];
}

- (BOOL)validatePureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


-(NSString *)timeIntervalWithFormat:(TimeStrType)type{
    NSDateFormatter *formatter =  [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
    
    NSUInteger dateInterval=[self integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateInterval];
    
    
    switch (type) {
            
        case TimeStrTypeDefalt:{
            [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
        }
            
            break;
            
            
        case TimeStrTypeChinese:{
            [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
        }
            break;
        default:
            break;
    }
    
    
    return [formatter stringFromDate:date];
}


@end



@implementation NSString (decimal)
#define DecimalCount 2
//小数点 控制 两位
-(BOOL)decimalControl{
    NSInteger count=0; //小数点位数
    count = [self decimalCount]; //小数点位数判断
    
    if (count == 0) {
        return YES;
    }else if(count == 1){
        NSInteger c=[self decimalAfterCount];
        if (c>DecimalCount) {
            return NO;
        }else{
            return YES;
        }
    }else if(count>1){
        return NO;
    }
    return YES;
}

//判断小数点
-(NSInteger)decimalCount{
    int count=0;
    for (int i=0; i<self.length; i++) {
        NSString *tmp=[self substringWithRange:NSMakeRange(i, 1)];
        if ([tmp isEqualToString:@"."]) {
            count++;
        }
    }
    return count;
}
//小数点位数后面
-(NSInteger)decimalAfterCount{
    NSRange decimal=[self rangeOfString:@"."];
    
    return self.length-decimal.length-decimal.location;
}

@end
