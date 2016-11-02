//
//  CBSplashViewController.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/27.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBSplashViewController.h"

#import "CBMediator+MainView.h"
#import "AppDelegate.h"

@interface CBSplashViewController ()

@end

@implementation CBSplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	UIViewController *viewController = [[CBMediator shareInstance] mainViewController];
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.window.rootViewController = viewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
