//
//  CBMediator.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/27.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBMediator.h"

@implementation CBMediator

ARCSingletonImplement(CBMediator)

- (id)performAction:(NSString *)actionName target:(NSString *)targetName params:(NSDictionary *)params
{
	NSString *convertTargetName = [[NSString alloc] initWithFormat: @"%@Target", targetName];
	Class target = NSClassFromString(convertTargetName);
	NSObject *object = [[target alloc] init];
	SEL selector = NSSelectorFromString(actionName);
	if([object respondsToSelector: selector])
	{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		return [object performSelector: selector withObject: params];
#pragma clang diagnostic pop
	}
	return nil;
}

@end
