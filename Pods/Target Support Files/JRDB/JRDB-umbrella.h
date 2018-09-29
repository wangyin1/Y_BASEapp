#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FMDatabase+JRPersistentHandler.h"
#import "JRActivatedProperty.h"
#import "JRDB.h"
#import "JRDBChain.h"
#import "JRDBChainCondition.h"
#import "JRDBMgr.h"
#import "JRDBResult.h"
#import "JRFMDBResultSetHandler.h"
#import "JRMiddleTable.h"
#import "JRPersistent.h"
#import "JRPersistentHandler.h"
#import "JRPersistentUtil.h"
#import "JRReflectable.h"
#import "JRSqlGenerator.h"
#import "NSObject+JRDB.h"
#import "NSObject+Reflect.h"
#import "OBJCProperty.h"

FOUNDATION_EXPORT double JRDBVersionNumber;
FOUNDATION_EXPORT const unsigned char JRDBVersionString[];

