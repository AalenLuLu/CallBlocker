//
//  CBMainViewControllerTarget.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/27.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBMainViewControllerTarget.h"

#import "CBTabBarController.h"
#import "CBNavigationController.h"
#import "CBBlockListTableViewController.h"
#import "CBIdentificationListTableViewController.h"
#import "CBContactListTableViewController.h"
#import "CBSettingTableViewController.h"

@implementation CBMainViewControllerTarget

- (UIViewController *)viewController
{
	CBBlockListTableViewController *blockViewController = [[CBBlockListTableViewController alloc] initWithStyle: UITableViewStyleGrouped];
	CBNavigationController *blockNavigation = [[CBNavigationController alloc] initWithRootViewController: blockViewController];
	
	CBIdentificationListTableViewController *identificationViewController = [[CBIdentificationListTableViewController alloc] initWithStyle: UITableViewStyleGrouped];
	CBNavigationController *identificationNavigation = [[CBNavigationController alloc] initWithRootViewController: identificationViewController];
	
	CBContactListTableViewController *contactViewController = [[CBContactListTableViewController alloc] initWithStyle: UITableViewStylePlain];
	CBNavigationController *contactNavigation = [[CBNavigationController alloc] initWithRootViewController: contactViewController];
	
	CBSettingTableViewController *settingViewController = [[CBSettingTableViewController alloc] initWithStyle: UITableViewStyleGrouped];
	CBNavigationController *settingNavigation = [[CBNavigationController alloc] initWithRootViewController: settingViewController];
	
	CBTabBarController *tabBarController = [[CBTabBarController alloc] init];
	tabBarController.viewControllers = @[blockNavigation, identificationNavigation, contactNavigation, settingNavigation];
	return tabBarController;
}

@end
