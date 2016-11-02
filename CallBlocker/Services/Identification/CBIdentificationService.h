//
//  CBIdentificationService.h
//  CallBlocker
//
//  Created by Aalen on 2016/10/28.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SingletonMacro.h"

extern NSString * const kCBIdentificationDidChangedNotification;

@class CBIdentification;

@interface CBIdentificationService : NSObject

SingletonDeclaration

- (void)reloadIdentificationWithCompletion: (void (^)(BOOL isSuccess))completion;

- (void)addIdentification: (CBIdentification *)identification completion: (void (^)())completion;
- (void)queryIdentificationWithCompletion: (void (^)(NSArray<CBIdentification *> *record))completion;
- (void)updateIdentification: (CBIdentification *)identification completion: (void (^)())completion;
- (void)removeIdentificationWithNumber: (NSString *)number completion: (void (^)())completion;
//- (void)removeIdentificationWithNumbers: (NSArray<NSString *> *)numbers completion: (void (^)())completion;

- (NSUInteger)queryIdentificationCount;
- (void)queryIdentificationAtPage: (NSUInteger)page size: (NSUInteger)size completion: (void (^)(NSArray<CBIdentification *> *record))completion;

@end
