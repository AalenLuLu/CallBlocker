//
//  CBBlockListTableViewController.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/27.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBBlockListTableViewController.h"

#import "CBBlockService.h"
#import "CBBlockNumber.h"

#import "CBAddBlockNumberViewController.h"

static NSString * const kBlockCellIdentifier = @"cell";

@interface CBBlockListTableViewController ()

@property (strong, nonatomic) CBBlockService *blockService;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation CBBlockListTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
	if(self = [super initWithStyle: style])
	{
		self.title = @"Block";
	}
	return self;
}

- (void)dealloc
{
	[self unregisterNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self initUI];
	[self initData];
	[self registerNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CBBlockNumber *blockNumber = _data[indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kBlockCellIdentifier forIndexPath: indexPath];
	cell.textLabel.text = blockNumber.number;
	return cell;
}

#pragma mark - Table view delegate

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
	__weak __typeof__(self) weakSelf = self;
	UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle: UITableViewRowActionStyleDestructive title: @"Delete" handler: ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		[weakSelf onDeletePressedAtIndexPath: indexPath];
	}];
	return @[deleteAction];
}

#pragma mark - data

- (void)initData
{
	_blockService = [CBBlockService shareInstance];
	[self refreshData];
}

- (void)refreshData
{
	__weak __typeof__(self) weakSelf = self;
	[_blockService queryBlockNumbersWithCompletion: ^(NSArray<CBBlockNumber *> *record) {
		weakSelf.data = [[NSMutableArray alloc] initWithArray: record];
		[weakSelf.tableView reloadData];
	}];
}

#pragma mark - notifications

- (void)registerNotifications
{
	[self unregisterNotifications];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onBlockNumberChanged:) name: kCBBlockNumberDidChangedNotification object: nil];
}

- (void)unregisterNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver: self name: kCBBlockNumberDidChangedNotification object: nil];
}

#pragma mark - notifications handle

- (void)onBlockNumberChanged: (NSNotification *)notification
{
	NSString *action = notification.userInfo[@"action"];
	if([@"add" isEqualToString: action])
	{
		CBBlockNumber *blockNumber = notification.userInfo[@"object"];
		void (^handle)() = ^{
			[_data insertObject: blockNumber atIndex: 0];
			[self.tableView insertRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: 0 inSection: 0]] withRowAnimation: UITableViewRowAnimationTop];
		};
		if([NSThread currentThread].isMainThread)
		{
			handle();
		}
		else
		{
			dispatch_async(dispatch_get_main_queue(), handle);
		}
	}
	else if([@"del" isEqualToString: action])
	{
		NSString *number = notification.userInfo[@"object"];
		void (^handle)() = ^{
			int i = 0;
			for(CBBlockNumber *blockNumber in _data)
			{
				if([number isEqualToString: blockNumber.number])
				{
					[_data removeObjectAtIndex: i];
					[self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: i inSection: 0]] withRowAnimation: UITableViewRowAnimationTop];
					break;
				}
				i++;
			}
		};
		if([NSThread currentThread].isMainThread)
		{
			handle();
		}
		else
		{
			dispatch_async(dispatch_get_main_queue(), handle);
		}
	}
	else
	{
		[self refreshData];
	}
}

#pragma mark - UI

- (void)initUI
{
	[self initNavigationBar];
	[self initTableView];
}

- (void)initNavigationBar
{
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(onAddButtonPressed)];
	self.navigationItem.rightBarButtonItem = addButton;
}

- (void)initTableView
{
	self.tableView.rowHeight = 56.0;
	[self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: kBlockCellIdentifier];
}

#pragma mark - UI handle

- (void)onAddButtonPressed
{
	CBAddBlockNumberViewController *viewController = [[CBAddBlockNumberViewController alloc] init];
	[self.navigationController pushViewController: viewController animated: YES];
}

- (void)onDeletePressedAtIndexPath: (NSIndexPath *)indexPath
{
	CBBlockNumber *blockNumber = _data[indexPath.row];
	[_blockService removeBlockNumber: blockNumber.number completion: nil];
}

@end
