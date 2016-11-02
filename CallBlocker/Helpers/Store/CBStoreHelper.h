//
//  CBStoreHelper.h
//  CallBlocker
//
//  Created by Aalen on 2016/10/27.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SingletonMacro.h"

@interface CBStoreHelper : NSObject

SingletonDeclaration

- (void)sharedDataExecuteWithSql: (NSString *)sql params: (NSArray *)params completion: (void (^)())completion;
- (void)sharedDataQueryWithSql: (NSString *)sql params: (NSArray *)params completion: (void (^)(NSArray *record))completion;
- (void)sharedDataExecuteTransactionWithSqls: (NSArray<NSString *> *)sqls params: (NSArray<NSArray *> *)params completion: (void (^)())completion;

- (void)unsharedDataExecuteWithSql: (NSString *)sql params: (NSArray *)params completion: (void (^)())completion;
- (void)unsharedDataQueryWithSql: (NSString *)sql params: (NSArray *)params completion: (void (^)(NSArray *record))completion;
- (void)unsharedDataExecuteTransactionWithSqls: (NSArray<NSString *> *)sqls params: (NSArray<NSArray *> *)params completion: (void (^)())completion;

@end
