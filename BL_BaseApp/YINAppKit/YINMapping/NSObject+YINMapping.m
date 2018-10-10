//
//  NSObject+YINMapping.m
//  BL_BaseApp
//
//  Created by apple on 2018/9/27.
//  Copyright © 2018年 王印. All rights reserved.
//

#import "NSObject+YINMapping.h"

@interface NSObject ()

@property (strong,nonatomic) NSMutableArray<YINBindObj *>  *bindArr;

//@property (weak,nonatomic) YINBindObj  *yinbinDelegate;

@end


@implementation NSObject (YINMapping)


+(void)load{
//    NSString*className=NSStringFromClass(self.class);
    static dispatch_once_t yinmappingOneceToken;
    
    dispatch_once(&yinmappingOneceToken,^{
        Class class=[self class];
                
        Method originalMethod=class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method swizzledMethod=class_getInstanceMethod(self, NSSelectorFromString(@"yinMappingDealloc"));
        
        BOOL didAddMethod=
        class_addMethod(class,
                        NSSelectorFromString(@"dealloc"),
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if(didAddMethod){
            class_replaceMethod(class,
                                NSSelectorFromString(@"yinMappingDealloc"),
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        }else{
            method_exchangeImplementations(originalMethod,swizzledMethod);
        }
    });
}

- (void)yinMappingDealloc
{
    @try {
        if (self.bindArr.count>0) {
            [self y_clear];
        }
        [self yinMappingDealloc];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}



- (NSMutableArray<YINBindObj *> *)bindArr
{
    NSMutableArray *arr = objc_getAssociatedObject(self, @selector(bindArr));
    return arr;
}
- (void)setBindArr:(NSMutableArray<YINBindObj *> *)bindArr{
    
    objc_setAssociatedObject(self, @selector(bindArr), bindArr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YINMappingBlock)mappingBlock{
    return  objc_getAssociatedObject(self, @selector(mappingBlock));
}

- (void)setMappingBlock:(YINMappingBlock)mappingBlock{
    objc_setAssociatedObject(self, @selector(mappingBlock), mappingBlock, OBJC_ASSOCIATION_COPY);
}

//- (NSMutableArray *)mappingBlocks
//{
//    NSMutableArray *arr = objc_getAssociatedObject(self, @selector(mappingBlocks));
//
//    return arr;
//}
//- (void)setMappingBlocks:(NSMutableArray *)mappingBlocks{
//
//    objc_setAssociatedObject(self, @selector(mappingBlocks), mappingBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

- (void)y_bindObjects:(NSArray <YINBindObj *> *)objs;{
    [self y_removeAllBind];
    [objs enumerateObjectsUsingBlock:^(YINBindObj * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self y_addBindObject:obj];
    }];
}

- (void)y_addBindObject:(YINBindObj *)obj;{
    if (!self.bindArr) {
        @try {
            self.bindArr = @[].mutableCopy;
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    [[self bindArr] addObject:obj];
    [obj addObserver:self forKeyPath:@"obj" options:NSKeyValueObservingOptionOld context:nil];
    [obj didBinded];
    
}
- (void)y_bindObject:(YINBindObj *)obj{
    [[self bindArr] removeAllObjects];
    [self y_addBindObject:obj];
}
- (void)y_removeBinds:(NSArray <YINBindObj *> *)objs;{
    __weak typeof (self)weakSelf = self;
    [objs enumerateObjectsUsingBlock:^(YINBindObj * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @try {
            [weakSelf y_removeBind:obj];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
  
    }];
   
}

- (void)y_removeAllBind;{
    @try {
        if (self.bindArr.count>0) {
            __weak typeof (self)weakSelf = self;
            [self.bindArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [weakSelf y_removeBind:obj];
            }];
        }
       
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
- (void)y_removeBind:(YINBindObj *)obj;{
    if ([[self bindArr] containsObject:obj]) {
        @try {
            [obj removeObserver:self forKeyPath:@"obj"];
            [obj removeBind];
            [[self bindArr] removeObject:obj];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
}
- (void)y_addBind:(YINBindObj *)obj Mapping:(YINMappingBlock)block{
    [obj.mappings addObject:block];
    [self y_addBindObject:obj];
}


- (void)y_addMapping:(YINMappingBlock)block;{
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [self.bindArr enumerateObjectsUsingBlock:^(YINBindObj * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.mappings addObject:block];
    }];
 });
   
}

- (void)y_cleanMapping;{
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [self.bindArr enumerateObjectsUsingBlock:^(YINBindObj * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.mappings removeAllObjects];
    }];
     });
}



- (void)y_clear;{
    [self y_cleanMapping];
    [self y_removeAllBind];

    [self setMappingBlock:nil];
    [self setBindArr:nil];
//    [self setYinbinDelegate:nil];
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    [[(YINBindObj *)object mappings] enumerateObjectsUsingBlock:^(YINMappingBlock  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj(object,@"obj");
    }];
    
}


@end
