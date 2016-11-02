//
//  CBCallDirectoryUtil.h
//  CallBlocker
//
//  Created by Aalen on 2016/10/31.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CBCallDirectoryType) {
	CBCallDirectoryType_Identification,
	CBCallDirectoryType_Block
};

@interface CBCallDirectoryUtil : NSObject

- (instancetype)initWithType: (CBCallDirectoryType)type;
- (void)isEnableCallDirectoryWithHandler: (void (^)(BOOL isEnable))handler;
- (void)synchronizeWithCompletion: (void (^)(NSError *error))completion;

@end
