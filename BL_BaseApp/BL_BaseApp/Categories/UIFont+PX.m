//
//  UIFont+PX.m
//  BL_BaseApp
//
//  Created by 王印 on 16/10/25.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "UIFont+PX.h"



@implementation UIFont (PX)

+ (NSDictionary *)pontSizeDic{
    
    NSDictionary *dic = @{
                          @"12":@"5.0",
                          @"14":@"5.5",
                          @"16":@"6.5",
                          @"20":@"7.5",
                          @"24":@"9.0",
                          @"28":@"10.5",
                          @"32":@"12.0",
                          @"36":@"14.0",
                          @"40":@"15.0",
                          @"42":@"16.0",
                          @"48":@"18.0",
                          @"58":@"22.0",
                          @"64":@"24.0",
                          @"68":@"26.0",
                           @"96":@"36.0",
                          };
    
    return dic;
}


+ (CGFloat)pxForPt:(CGFloat)pt{
    NSDictionary *dic = [UIFont pontSizeDic];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [newDic setObject:key forKey:obj];
    }];
    
   return  [newDic[[NSString stringWithFormat:@"%.1f",pt]]floatValue];
   
}


+ (CGFloat)ptForPx:(CGFloat)px{
   return [[[UIFont pontSizeDic] objectForKey:[NSString stringWithFormat:@"%.0f",px]] floatValue];
}

//返回px单位的字体大小
- (CGFloat)pxSize{
    
    return [UIFont pxForPt:self.pointSize];
    
}

+ (UIFont *)systemFontOfPXSize:(CGFloat)pxSize{
    
    return [UIFont systemFontOfSize:[UIFont ptForPx:pxSize]];
}

+ (UIFont *)boldSystemFontOfPXSize:(CGFloat)pxSize{
    return [UIFont boldSystemFontOfSize:[UIFont ptForPx:pxSize]];
}

@end
