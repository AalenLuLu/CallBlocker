//
//  CBTabBarController.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/27.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBTabBarController.h"

@interface CBTabBarController () <UITabBarControllerDelegate>

@end

@implementation CBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	if(viewController == tabBarController.selectedViewController)
	{
		return NO;
	}
	return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
