//
//  runtimeKit.m
//  runtimeKit
//
//  Created by 58 on 17/2/25.
//  Copyright © 2017年 yuanmenglong. All rights reserved.
//

#import "runtimeKit.h"

@implementation runtimeKit
static char  key;
+ (NSString *)fetchClassName:(id )object
{
      //  NSStringFromClass([object class]);
      
    Class class = object_getClass(object);
    const char *className = object_getClassName(class);
    return  [NSString stringWithUTF8String:className];
}
+ (NSArray *)fetchIvarList:(id)object
{
     Class class = object_getClass(object);
     return  [runtimeKit fetchIvarClass:class];

}
+ (NSArray *)fetchIvarClass:(Class)class
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
+ (NSArray *)fetchPropertyList:(Class)class
{
     unsigned int outCount;
    objc_property_t *propertyList = class_copyPropertyList(class, &outCount);
    NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:outCount];
    for(int i = 0; i < outCount;i++)
    {
        NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithCapacity:2];
        const char *attributeName = property_getAttributes(propertyList[i]);
        const char *propertyName = property_getName(propertyList[i]);
        [mutableDict setObject:[NSString stringWithUTF8String:attributeName] forKey:@"attributeName"];

        [mutableDict setObject:[runtimeKit fetchAttitebutesList:propertyList[i]] forKey:@"attributeList"];
        [mutableDict setObject:[NSString stringWithUTF8String:propertyName] forKey:@"propertyName"];
        [mutableList addObject:mutableDict];
    }
    free(propertyList);
    return  [NSArray arrayWithArray:mutableList];
}
+ (NSDictionary *)fetchAttitebutesList:(objc_property_t )property
{
        unsigned int countArr = 0;
        objc_property_attribute_t *attributes = property_copyAttributeList(property, &countArr);
           NSMutableDictionary *attributeDict = [NSMutableDictionary dictionaryWithCapacity:countArr];
            for (unsigned int j = 0; j < countArr; ++j)
            {
                  objc_property_attribute_t attribute = attributes[j];
                 [attributeDict setObject:[NSString stringWithUTF8String:attribute.value] forKey:[NSString stringWithUTF8String:attribute.name]];
            }
            free(attributes);
        return [NSMutableDictionary dictionaryWithDictionary:attributeDict];
}
+ (NSArray *)fetchMethodList:(Class)class
{
        unsigned int outCount =0;
        Method *methodList = class_copyMethodList(class, &outCount);
        NSMutableArray *mutabelList = [NSMutableArray arrayWithCapacity:outCount];
        for(unsigned int i = 0; i < outCount;i++)
        {
             NSMutableDictionary *dict = [NSMutableDictionary dictionary];
             Method method = methodList[i];
             SEL methodName = method_getName(method);
             const char *typeEncoding = method_getTypeEncoding(method);
            
            
             struct objc_method_description *descrition =  method_getDescription(method);
             NSDictionary *descDict = @{@"name":NSStringFromSelector(descrition->name),@"types":[NSString stringWithUTF8String:descrition->types]};
            
              char *dst = malloc(1000*sizeof(char));
             method_getReturnType(method, dst, 1000);
            
            
//            method_ge
            
             [dict setObject:[NSString stringWithUTF8String:dst] forKey:@"returnType"];
             free(dst);
    
             [dict setObject:descDict forKey:@"descrition"];
             [dict setObject:NSStringFromSelector(methodName) forKey:@"methodName"];
             [dict setObject:[NSString stringWithUTF8String:typeEncoding] forKey:@"typeEncoding"];
             [mutabelList addObject:dict];
        }
        free(methodList);
        return [NSArray arrayWithArray:mutabelList];
}
+ (NSArray *)fetchProtocolList:(Class )class
{
     unsigned int outCount = 0;
   Protocol * __unsafe_unretained *protocolList = class_copyProtocolList(class, &outCount);
   NSMutableArray *mutableList = [NSMutableArray arrayWithCapacity:outCount];
   for(unsigned int i = 0; i < outCount;i++)
   {
      Protocol *protocol = protocolList[i];
      const char *protocolName = protocol_getName(protocol);
      [mutableList addObject:[NSString stringWithUTF8String:protocolName]];
   }
   free(protocolList);
   return [NSArray arrayWithArray:mutableList];
}

+ (void)registerProtocol
{
   NSString *prtocol = @"NSMying";
    Protocol *protocol = objc_allocateProtocol([prtocol cStringUsingEncoding:NSUTF8StringEncoding]);
     objc_registerProtocol(protocol);
 
}
/**
 *   向系统的表中添加 协议
 */
+ (void)registerProtocol:(const char *)protocolName
{
    Protocol *protocol = objc_allocateProtocol(protocolName);
    objc_registerProtocol(protocol);
    
}

+ (void)addPrtocol:(NSString *)protocolString toClass:(Class )class
{
    NSAssert(protocolString != nil, @"protocolString 为遵守的协议不能为空,例如：<NSCoding> 协议传进来的字符串应该为 NSCoding");
    if([protocolString hasPrefix:@"<"])
    {
        protocolString = [protocolString substringWithRange:NSMakeRange(1, protocolString.length-2)];
    }
   if(protocolString != nil)
   {
     Protocol *protocoName = NSProtocolFromString(protocolString);
     class_addProtocol(class, protocoName);
   }
}

+ (void)addProperty:(id)property ToObject:(id)object
{
//    static char  key;
//      const char *key = [NSStringFromClass([object class]) cStringUsingEncoding:NSUTF8StringEncoding];
      objc_setAssociatedObject(object,&key,property, OBJC_ASSOCIATION_RETAIN);
}
+ (id)getValueFromProperty:(id )property withObject:(id) object
{
   return  objc_getAssociatedObject(object,&key);
}
/**
 *   向某一个类添加另一个类某一个方法的实现
 */



+ (BOOL)addInstanceTargetClass:(Class)targetClass originClass:(Class)originClass method:(SEL)methodSel
{
    Method method = class_getInstanceMethod(originClass,methodSel);
    IMP methodIMp = method_getImplementation(method);
    const char *types = method_getTypeEncoding(method);
    
   return class_addMethod(targetClass,methodSel, methodIMp, types);
}
/**
 *   用该类的一个方法替换另一个方法： 某一个类的俩哥方法交换
 */
+ (void)methodReplace:(Class)class  originMethod:(SEL)originMethod replaceMethod:(SEL)replaceMethod
{
    Method origin = class_getInstanceMethod(class,originMethod);
    Method replace = class_getInstanceMethod(class, replaceMethod);
    method_exchangeImplementations(origin, replace);
}
/**
 *   用A类的 实例a方法  来和B类的 实例b方法进行交换
 */
+ (void)instanceMethodExchangeOriginClass:(Class)originClass originMethod:(SEL)originMethod exchangeClass:(Class)class exchangeMethod:(SEL)replaceMethod
{
    Method origin = class_getInstanceMethod(originClass,originMethod);
    Method replace = class_getInstanceMethod(class, replaceMethod);
    method_exchangeImplementations(origin, replace);
}
/**
 *   用A类的 类c方法  和B类的 类d 方法交换
 */
+ (void)classMethodExchangeOriginClass:(Class)originClass originMethod:(SEL)originMethod exchangeClass:(Class)class exchangeMethod:(SEL)replaceMethod
{
    Method origin = class_getClassMethod(originClass, originMethod);
    Method replace = class_getClassMethod(class, replaceMethod);
    method_exchangeImplementations(origin, replace);
}

+ (void)print
{
   NSLog(@"print %d %@ %@,",__LINE__,self,NSStringFromSelector(_cmd));
}
- (void)test
{
 NSLog(@"hello %d %@ %@,",__LINE__,self,NSStringFromSelector(_cmd));
}
@end
