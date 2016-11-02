//
//  CBMediator+SplashView.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/27.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBMediator+SplashView.h"

NSString * const kCBMediatorTargetSplashViewController = @"CBSplashViewController";

NSString * const kCBMediatorActionSplashViewController = @"viewController";

@implementation CBMediator (SplashView)

- (UIViewController *)splashViewController
{
	UIViewController *viewController = [self performAction: kCBMediatorActionSplashViewController target: kCBMediatorTargetSplashViewController params: nil];
	if([viewController isKindOfClass: [UIViewController class]])
	{
		return viewController;
	}
	return nil;
}

@end
