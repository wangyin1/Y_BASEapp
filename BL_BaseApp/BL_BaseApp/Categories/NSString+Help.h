//
//  NSString+Help.h
//  seller
//
//  Created by huazhe on 16/6/8.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TimeStrTypeDefalt,
    TimeStrTypeChinese,
} TimeStrType;

@interface NSString (Help)

-(NSAttributedString *)underLineAttributeString; //带下划线的属性字符串

-(NSString *)timeStringWithFormat:(TimeStrType)type; //时间转换
-(NSString *)timeIntervalWithFormat:(TimeStrType)type; //时间戳转换
- (NSString *)timeStringFromFormat:(NSString *)from ToFormat:(NSString *)to;
@end



@interface NSString (decimal) //小数点输入控制
//小数点 控制 两位
-(BOOL)decimalControl;
@end