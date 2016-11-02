//
//  CBSettingTableViewController.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/27.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBSettingTableViewController.h"

#import "CBSettingSwitchTableViewCell.h"
#import "CBCallDirectoryUtil.h"

static NSString * const kSettingNormalCellIdentifier = @"cell";
static NSString * const kSettingSwitchCellIdentifier = @"switchcell";

NSString * const kEnableIdentificationSetting = @"Enable Identification";
NSString * const kEnableBlockSetting = @"Enable Block";
NSString * const kAutoReloadIdentificationSetting = @"Auto Reload Identification";
NSString * const kAutoReloadBlockSetting = @"Auto Reload Block";
NSString * const kReloadIdentificationSetting = @"Reload Identification";
NSString * const kReloadBlockSetting = @"Reload Block";

@interface CBSettingTableViewController () <CBSettingSwitchTableViewCellDelegate>

@property (strong, nonatomic) NSArray *data;

@end

@implementation CBSettingTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
	if(self = [super initWithStyle: style])
	{
		self.title = @"Setting";
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self initUI];
	[self initData];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear: animated];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *title = _data[indexPath.section][indexPath.row][@"title"];
	
	if([title isEqualToString: kReloadIdentificationSetting] || [title isEqualToString: kReloadBlockSetting])
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kSettingNormalCellIdentifier forIndexPath: indexPath];
		cell.textLabel.text = title;
		return cell;
	}
	
	CBSettingSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kSettingSwitchCellIdentifier forIndexPath: indexPath];
	cell.delegate = self;
	cell.indexPath = indexPath;
	
	[cell setTitle: title];
	CBCallDirectoryUtil *callDirectoryUtil = nil;
	if([title isEqualToString: kEnableIdentificationSetting])
	{
		callDirectoryUtil = [[CBCallDirectoryUtil alloc] initWithType: CBCallDirectoryType_Identification];
		[callDirectoryUtil isEnableCallDirectoryWithHandler: ^(BOOL isEnable) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[cell setEnable: isEnable];
			});
		}];
	}
	else if([title isEqualToString: kEnableBlockSetting])
	{
		callDirectoryUtil = [[CBCallDirectoryUtil alloc] initWithType: CBCallDirectoryType_Block];
		[callDirectoryUtil isEnableCallDirectoryWithHandler: ^(BOOL isEnable) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[cell setEnable: isEnable];
			});
		}];
	}
	else if([title isEqualToString: kAutoReloadIdentificationSetting])
	{
		BOOL isAuto = [[NSUserDefaults standardUserDefaults] boolForKey: @"autoreloadidentification"];
		[cell setEnable: isAuto];
	}
	else if([title isEqualToString: kAutoReloadBlockSetting])
	{
		BOOL isAuto = [[NSUserDefaults standardUserDefaults] boolForKey: @"autoreloadblock"];
		[cell setEnable: isAuto];
	}
	
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *title = _data[indexPath.section][indexPath.row][@"title"];
	CBCallDirectoryUtil *callDirectoryUtil = nil;
	if([title isEqualToString: kReloadIdentificationSetting])
	{
		[tableView deselectRowAtIndexPath: indexPath animated: YES];
		callDirectoryUtil = [[CBCallDirectoryUtil alloc] initWithType: CBCallDirectoryType_Identification];
	}
	else if([title isEqualToString: kReloadBlockSetting])
	{
		[tableView deselectRowAtIndexPath: indexPath animated: YES];
		callDirectoryUtil = [[CBCallDirectoryUtil alloc] initWithType: CBCallDirectoryType_Block];
	}
	if(nil != callDirectoryUtil)
	{
		__weak __typeof__(self) weakSelf = self;
		[callDirectoryUtil isEnableCallDirectoryWithHandler: ^(BOOL isEnable) {
			if(isEnable)
			{
				[callDirectoryUtil synchronizeWithCompletion: ^(NSError *error) {
					if(error)
					{
						UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Notification" message: @"Synchronize Failed" preferredStyle: UIAlertControllerStyleAlert];
						UIAlertAction *action = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault handler: nil];
						[alert addAction: action];
						[weakSelf presentViewController: alert animated: YES completion: nil];
					}
					else
					{
						UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Notification" message: @"Synchronize Success" preferredStyle: UIAlertControllerStyleAlert];
						UIAlertAction *action = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault handler: nil];
						[alert addAction: action];
						[weakSelf presentViewController: alert animated: YES completion: nil];
					}
				}];
			}
			else
			{
				UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Warning" message: @"Please Enable Call Directory" preferredStyle: UIAlertControllerStyleAlert];
				UIAlertAction *action = [UIAlertAction actionWithTitle: @"OK" style: UIAlertActionStyleDefault handler: nil];
				[alert addAction: action];
				[weakSelf presentViewController: alert animated: YES completion: nil];
			}
		}];
	}
}

#pragma mark - data

- (void)initData
{
	NSDictionary *identificationSetting = @{@"title": kEnableIdentificationSetting};
	NSDictionary *blockSetting = @{@"title": kEnableBlockSetting};
	NSDictionary *autoReloadIdentificationSetting = @{@"title": kAutoReloadIdentificationSetting};
	NSDictionary *autoReloadBlockSetting = @{@"title": kAutoReloadBlockSetting};
	NSDictionary *reloadIdentificationSetting = @{@"title": kReloadIdentificationSetting};
	NSDictionary *reloadBlockSetting = @{@"title": kReloadBlockSetting};
	
	self.data = @[@[identificationSetting, blockSetting], @[autoReloadIdentificationSetting, autoReloadBlockSetting], @[reloadIdentificationSetting, reloadBlockSetting]];
}

#pragma mark - UI

- (void)initUI
{
	[self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: kSettingNormalCellIdentifier];
	[self.tableView registerClass: [CBSettingSwitchTableViewCell class] forCellReuseIdentifier: kSettingSwitchCellIdentifier];
}

#pragma mark - CBSettingTableViewCellDelegate

- (void)onSwitchChangedAtIndexPath:(NSIndexPath *)indexPath enable:(BOOL)enable
{
	NSString *title = _data[indexPath.section][indexPath.row][@"title"];
	if([kAutoReloadIdentificationSetting isEqualToString: title])
	{
		[[NSUserDefaults standardUserDefaults] setBool: enable forKey: @"autoreloadidentification"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else if([kAutoReloadBlockSetting isEqualToString: title])
	{
		[[NSUserDefaults standardUserDefaults] setBool: enable forKey: @"autoreloadblock"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
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
