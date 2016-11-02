//
//  CBBlockService.h
//  CallBlocker
//
//  Created by Aalen on 2016/11/2.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SingletonMacro.h"

extern NSString * const kCBBlockNumberDidChangedNotification;

@class CBBlockNumber;

@interface CBBlockService : NSObject

SingletonDeclaration

- (void)addBlockNumber: (CBBlockNumber *)blockNumber completion: (void (^)())completion;
- (void)queryBlockNumbersWithCompletion: (void (^)(NSArray<CBBlockNumber *> *record))completion;
- (void)removeBlockNumber: (NSString *)number completion: (void (^)())completion;

- (NSUInteger)queryBlockNumberCount;
- (void)queryBlockNumbersAtPage: (NSUInteger)page size: (NSUInteger)size completion: (void (^)(NSArray<CBBlockNumber *> *record))completion;

@end
