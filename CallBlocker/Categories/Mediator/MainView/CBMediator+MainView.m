//
//  CBMediator+MainView.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/27.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBMediator+MainView.h"

NSString * const kCBMediatorTargetMainViewController = @"CBMainViewController";

NSString * const kCBMediatorActionMainViewController = @"viewController";

@implementation CBMediator (MainView)

- (UIViewController *)mainViewController
{
	UIViewController *viewController = [self performAction: kCBMediatorActionMainViewController target: kCBMediatorTargetMainViewController params: nil];
	if([viewController isKindOfClass: [UIViewController class]])
	{
		return viewController;
	}
	return nil;
}

@end
