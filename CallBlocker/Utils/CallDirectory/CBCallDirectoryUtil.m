//
//  CBCallDirectoryUtil.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/31.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBCallDirectoryUtil.h"

#import <CallKit/CallKit.h>

NSString * const kCBIdentificationIdentifier = @"com.aalen.callblocker.identification";
NSString * const kCBBlockIdentifier = @"com.aalen.callblocker.block";

@interface CBCallDirectoryUtil ()

@property (copy, nonatomic) NSString *identifier;

@end

@implementation CBCallDirectoryUtil

- (instancetype)initWithType:(CBCallDirectoryType)type
{
	if(self = [super init])
	{
		if(CBCallDirectoryType_Identification == type)
		{
			_identifier = kCBIdentificationIdentifier;
		}
		else if(CBCallDirectoryType_Block == type)
		{
			_identifier = kCBBlockIdentifier;
		}
	}
	return self;
}

- (void)dealloc
{
	NSLog(@"CallDirectory dealloc...");
}

- (void)isEnableCallDirectoryWithHandler:(void (^)(BOOL))handler
{
	if(!handler)
	{
		return;
	}
	CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
	[manager getEnabledStatusForExtensionWithIdentifier: _identifier completionHandler: ^(CXCallDirectoryEnabledStatus enabledStatus, NSError * _Nullable error) {
		if(CXCallDirectoryEnabledStatusEnabled == enabledStatus)
		{
			handler(YES);
		}
//		else if(CXCallDirectoryEnabledStatusDisabled == enabledStatus)
//		{
//			
//		}
		else
		{
			handler(NO);
		}
	}];
}

- (void)synchronizeWithCompletion: (void (^)(NSError *error))completion
{
	CXCallDirectoryManager *manager = [CXCallDirectoryManager sharedInstance];
	[manager reloadExtensionWithIdentifier: _identifier completionHandler: completion];
}

@end
