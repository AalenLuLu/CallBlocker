//
//  CBEditIdentificationViewController.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/31.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBEditIdentificationViewController.h"

#import "CBIdentification.h"
#import "CBIdentificationService.h"

#import "UIColor+Hex.h"

@interface CBEditIdentificationViewController ()

@property (strong, nonatomic) CBIdentification *identification;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *numberTextField;

@end

@implementation CBEditIdentificationViewController

- (instancetype)initWithIdentification:(CBIdentification *)identification
{
	if(self = [super init])
	{
		_identification = identification;
	}
	return self;
}

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
	if(nil != _identification)
	{
		_numberTextField.text = _identification.number;
		_numberTextField.enabled = NO;
		_numberTextField.textColor = [UIColor grayColor];
		
		_nameTextField.text = _identification.name;
	}
}

#pragma mark - UI handle

- (void)onTapView: (UITapGestureRecognizer *)gesture
{
	[_nameTextField resignFirstResponder];
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
	CBIdentification *identification = [[CBIdentification alloc] initWithNumber: _numberTextField.text name: _nameTextField.text];
	__weak __typeof__(self) weakSelf = self;
	if(nil != _identification)
	{
		[[CBIdentificationService shareInstance] updateIdentification: identification completion: ^{
			[weakSelf.navigationController popViewControllerAnimated: YES];
		}];
	}
	else
	{
		[[CBIdentificationService shareInstance] addIdentification: identification completion: ^{
			[weakSelf.navigationController popViewControllerAnimated: YES];
		}];
	}
}

#pragma mark - UI

- (void)initUI
{
	[self initNavigationBar];
	self.view.backgroundColor = [UIColor colorWithHexValue: 0xefeff4 alpha: 1.0];
	[self.view addSubview: self.nameLabel];
	[self.view addSubview: self.nameTextField];
	[self.view addSubview: self.numberLabel];
	[self.view addSubview: self.numberTextField];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onTapView:)];
	[self.view addGestureRecognizer: tapGesture];
}

- (void)initNavigationBar
{
	if(nil == _identification)
	{
		self.title = @"Add Identification";
	}
	else
	{
		self.title = @"Edit Identification";
	}
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(onDoneButtonPressed)];
	self.navigationItem.rightBarButtonItem = doneButton;
}

- (UILabel *)nameLabel
{
	if(nil == _nameLabel)
	{
		CGFloat originY = 64.0;
		if(nil == self.navigationController)
		{
			originY = 0;
		}
		_nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(8.0, originY + 16.0, 0, 0)];
		_nameLabel.font = [UIFont boldSystemFontOfSize: 16.0];
		_nameLabel.text = @"Identification Name:";
		[_nameLabel sizeToFit];
	}
	return _nameLabel;
}

- (UILabel *)numberLabel
{
	if(nil == _numberLabel)
	{
		_numberLabel = [[UILabel alloc] initWithFrame: CGRectMake(8.0, CGRectGetMaxY(self.nameLabel.frame) + 80.0, 0, 0)];
		_numberLabel.font = [UIFont boldSystemFontOfSize: 16.0];
		_numberLabel.text = @"Number:";
		[_numberLabel sizeToFit];
	}
	return _numberLabel;
}

- (UITextField *)nameTextField
{
	if(nil == _nameTextField)
	{
		_nameTextField = [[UITextField alloc] initWithFrame: CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame) + 8.0, self.view.bounds.size.width, 50.0)];
		_nameTextField.placeholder = @"Identification";
		_nameTextField.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 16.0, 16.0)];
		_nameTextField.leftViewMode = UITextFieldViewModeAlways;
		_nameTextField.backgroundColor = [UIColor whiteColor];
	}
	return _nameTextField;
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

@end
