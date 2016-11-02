//
//  CBAddBlockNumberViewController.m
//  CallBlocker
//
//  Created by Aalen on 2016/11/2.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBAddBlockNumberViewController.h"

#import "CBBlockNumber.h"
#import "CBBlockService.h"

#import "UIColor+Hex.h"

@interface CBAddBlockNumberViewController ()

@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UITextField *numberTextField;

@end

@implementation CBAddBlockNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self initUI];
	[self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - data

- (void)initData
{
	
}

#pragma mark - UI handle

- (void)onTapView: (UITapGestureRecognizer *)gesture
{
	[_numberTextField resignFirstResponder];
}

- (void)onDoneButtonPressed
{
	NSScanner *scanner = [NSScanner scannerWithString: _numberTextField.text];
	int output;
	if(!([scanner scanInt: &output] && [scanner isAtEnd]))
	{
		UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Warning" message: @"Please Input a Valid Number" preferredStyle: UIAlertControllerStyleAlert];
		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle: @"Confirm" style: UIAlertActionStyleDefault handler: nil];
		[alert addAction: confirmAction];
		[self presentViewController: alert animated: YES completion: nil];
		return;
	}
	CBBlockNumber *blockNumber = [[CBBlockNumber alloc] initWithNumber: _numberTextField.text];
	__weak __typeof__(self) weakSelf = self;
	[[CBBlockService shareInstance] addBlockNumber: blockNumber completion: ^{
		[weakSelf.navigationController popViewControllerAnimated: YES];
	}];
}

#pragma mark - UI

- (void)initUI
{
	[self initNavigationBar];
	self.view.backgroundColor = [UIColor colorWithHexValue: 0xefeff4 alpha: 1.0];
	[self.view addSubview: self.numberLabel];
	[self.view addSubview: self.numberTextField];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onTapView:)];
	[self.view addGestureRecognizer: tapGesture];
}

- (void)initNavigationBar
{
	self.title = @"Add Block Number";
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(onDoneButtonPressed)];
	self.navigationItem.rightBarButtonItem = doneButton;
}

- (UILabel *)numberLabel
{
	if(nil == _numberLabel)
	{
		CGFloat originY = 64.0;
		if(nil == self.navigationController)
		{
			originY = 0;
		}
		_numberLabel = [[UILabel alloc] initWithFrame: CGRectMake(8.0, originY + 16.0, 0, 0)];
		_numberLabel.font = [UIFont boldSystemFontOfSize: 16.0];
		_numberLabel.text = @"Number:";
		[_numberLabel sizeToFit];
	}
	return _numberLabel;
}

- (UITextField *)numberTextField
{
	if(nil == _numberTextField)
	{
		_numberTextField = [[UITextField alloc] initWithFrame: CGRectMake(0, CGRectGetMaxY(self.numberLabel.frame) + 8.0, self.view.bounds.size.width, 50.0)];
		_numberTextField.placeholder = @"Number";
		_numberTextField.keyboardType = UIKeyboardTypeNumberPad;
		_numberTextField.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 16.0, 16.0)];
		_numberTextField.leftViewMode = UITextFieldViewModeAlways;
		_numberTextField.backgroundColor = [UIColor whiteColor];
	}
	return _numberTextField;
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
