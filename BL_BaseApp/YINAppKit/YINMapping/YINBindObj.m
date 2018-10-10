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
- (NSArray *)fetchIvarClass:(Class)class
    {
        unsigned int outCount = 0;
        Ivar *ivarList =  class_copyIvarList(class, &outCount);
        NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:outCount];
        for(int i = 0; i < outCount;i++)
        {
            NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithCapacity:2];
            const char *ivarName = ivar_getName(ivarList[i]);
            const char *ivarType = ivar_getTypeEncoding(ivarList[i]);
            //        NSString *dataType;
            //        if(strcmp(ivarType, @encode(int)) == 0)
            //        {
            //           dataType = @"int";
            //        }else if(strcmp(ivarType,@encode(double)) == 0)
            //        {
            //           dataType = @"double";
            //        }
            //        else if(strcmp(ivarType, @encode(unsigned int)) == 0)
            //        {
            //            dataType = @"unsigned int";
            //        }else if(strcmp(ivarType, @encode(BOOL)) == 0)
            //        {
            //           dataType = @"BOOL";
            //        }
            //        if(dataType != nil)
            //        {
            //        [muDict setObject:dataType forKey:@"dataType"];
            //        }
            [muDict setObject:[NSString stringWithUTF8String:ivarName] forKey:@"ivarName"];
            [muDict setObject:[NSString stringWithUTF8String:ivarType] forKey:@"ivarType"];
            [muArr addObject:muDict];
        }
        free(ivarList);
        return [NSArray arrayWithArray:muArr];
}

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
        
        [[self fetchIvarClass:self.obj.class] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @try {
                if([(NSString *)obj[@"ivarName"] hasPrefix:@"_"]&&[obj[@"ivarName"] length]>1){
                     [weakSelf.obj addObserver:weakSelf forKeyPath:[obj[@"ivarName"] substringFromIndex:1] options:NSKeyValueObservingOptionOld context:nil];
                }
                [weakSelf.obj addObserver:weakSelf forKeyPath:obj[@"ivarName"] options:NSKeyValueObservingOptionOld context:nil];
                
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
        }];
//        [self.obj.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
//
//            @try {
//                [weakSelf.obj addObserver:weakSelf forKeyPath:property.name options:NSKeyValueObservingOptionOld context:nil];
//
//            } @catch (NSException *exception) {
//
//            } @finally {
//
//            }
//        }];
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
        [[self fetchIvarClass:self.obj.class] enumerateObjectsUsingBlock:^(NSDictionary* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @try {
                if([(NSString *)obj[@"ivarName"] hasPrefix:@"_"]&&[obj[@"ivarName"] length]>1){
                    [weakSelf.obj removeObserver:weakSelf forKeyPath: [obj[@"ivarName"] substringFromIndex:1]];
                }
                [weakSelf.obj removeObserver:weakSelf forKeyPath:obj[@"ivarName"]];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }];
//        [self.obj.class mj_enumerateProperties:^(MJProperty *property, BOOL *stop) {
//            @try {
//                [weakSelf.obj removeObserver:weakSelf forKeyPath:property.name];
//            } @catch (NSException *exception) {
//                
//            } @finally {
//                
//            }
//        }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    [self.mappings enumerateObjectsUsingBlock:^(YINMappingBlock  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj(object,keyPath);
    }];
    
}

@end
