//
//  YINBindObj.m
//  BL_BaseApp
//
//  Created by apple on 2018/9/29.
//  Copyright © 2018年 王印. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "YINBindObj.h"

@interface YINBindObj()
@property (weak,nonatomic) NSObject  *obj;
@property (copy,nonatomic) NSMutableArray   *bindPs;
@end

@implementation YINBindObj

- (void)didBinded{
    __weak typeof(self)weakSelf = self;
    if (self.bindPs.count>0) {
        
        [self.bindPs enumerateObjectsUsingBlock:^(id  _Nonnull aobj, NSUInteger idx, BOOL * _Nonnull stop) {
            @try {
                [weakSelf.obj addObserver:weakSelf forKeyPath:aobj options:NSKeyValueObservingOptionOld context:nil];
                if (([weakSelf.obj isKindOfClass:[UIControl class]])&&[aobj isEqualToString:@"text"]) {
                    [(UIControl *)weakSelf.obj addTarget:weakSelf action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
                }
                if (([weakSelf.obj isKindOfClass:[UIControl class]])&&[aobj isEqualToString:@"value"]) {
                    [(UIControl *)weakSelf.obj addTarget:weakSelf action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
                }
                
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }];
    }else{
        
        if ([self.obj isKindOfClass:[UIControl class]]) {
            [(UIControl *)self.obj addTarget:weakSelf action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
            [(UIControl *)self.obj addTarget:weakSelf action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        }
        [self.obj.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
            
            @try {
                [weakSelf.obj addObserver:weakSelf forKeyPath:property.name options:NSKeyValueObservingOptionOld context:nil];
                
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }];
    }
}

- (void)valueChange:(UIControl *)sender{
    [self.mappings enumerateObjectsUsingBlock:^(YINMappingBlock  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj(self.obj,@"value");
    }];
}

- (void)textChange:(UIControl *)sender{
    
    [self.mappings enumerateObjectsUsingBlock:^(YINMappingBlock  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj(self.obj,@"text");
    }];
}

+ (instancetype)obj:(id)obj;{
    YINBindObj *binobj =  [[YINBindObj alloc] init];
    binobj.obj = obj;
    return  binobj;
}

- (NSMutableArray<YINMappingBlock> *)mappings{
    if (!_mappings) {
        _mappings = @[].mutableCopy;
    }
    return _mappings;
}

- (NSMutableArray *)bindPs{
    if (!_bindPs) {
        _bindPs = @[].mutableCopy;
    }
    return _bindPs;
}
+ (instancetype)obj:(id)obj keyPaths:(NSArray <NSString *>*)keyPaths;{
    YINBindObj *binobj = [YINBindObj obj:obj];
    [binobj.bindPs removeAllObjects];
    [binobj.bindPs addObjectsFromArray:keyPaths];
    return binobj;
}

+ (instancetype)obj:(id)obj keyPath:(NSString *)keyPath;{
    return [YINBindObj obj:obj keyPaths:[NSArray arrayWithObject:keyPath]];
}

- (void)removeBind;{
    __weak typeof(self)weakSelf = self;
    if (self.bindPs.count>0) {
        [self.bindPs enumerateObjectsUsingBlock:^(id  _Nonnull aobj, NSUInteger idx, BOOL * _Nonnull stop) {
            @try {
                [weakSelf.obj removeObserver:weakSelf forKeyPath:aobj];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }];
    }else{
        [self.obj.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
            @try {
                [weakSelf.obj removeObserver:weakSelf forKeyPath:property.name];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    [self.mappings enumerateObjectsUsingBlock:^(YINMappingBlock  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj(object,keyPath);
    }];
    
}

@end
