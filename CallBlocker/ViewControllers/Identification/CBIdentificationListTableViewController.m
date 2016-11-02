//
//  CBIdentificationListTableViewController.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/27.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBIdentificationListTableViewController.h"

#import "CBIdentificationService.h"
#import "CBIdentification.h"
#import "CBIdentificationListTableViewCell.h"

#import "CBEditIdentificationViewController.h"

static NSString * const kIdentificationCellIdentifier = @"cell";

@interface CBIdentificationListTableViewController ()

@property (strong, nonatomic) CBIdentificationService *identificationService;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation CBIdentificationListTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
	if(self = [super initWithStyle: style])
	{
		self.title = @"Identification";
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
	CBIdentification *identification = _data[indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kIdentificationCellIdentifier forIndexPath: indexPath];
	cell.textLabel.text = identification.name;
	cell.detailTextLabel.text = identification.number;
	return cell;
}

#pragma mark - Table view delegate

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
	__weak __typeof__(self) weakSelf = self;
	UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle: UITableViewRowActionStyleNormal title: @"Edit" handler: ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		[weakSelf onEditPressedAtIndexPath: indexPath];
	}];
	
	UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle: UITableViewRowActionStyleDestructive title: @"Delete" handler: ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		[weakSelf onDeletePressedAtIndexPath: indexPath];
	}];
	
	return @[deleteAction, editAction];
}

#pragma mark - data

- (void)initData
{
	_identificationService = [CBIdentificationService shareInstance];
	[self refreshData];
}

- (void)refreshData
{
	__weak __typeof__(self) weakSelf = self;
	[_identificationService queryIdentificationWithCompletion: ^(NSArray<CBIdentification *> *record) {
		weakSelf.data = [[NSMutableArray alloc] initWithArray: record];
		[weakSelf.tableView reloadData];
	}];
}

#pragma mark - notifications

- (void)registerNotifications
{
	[self unregisterNotifications];
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(onIdentificationChanged:) name: kCBIdentificationDidChangedNotification object: nil];
}

- (void)unregisterNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver: self name: kCBIdentificationDidChangedNotification object: nil];
}

#pragma mark - notifications handle

- (void)onIdentificationChanged: (NSNotification *)notification
{
	NSString *action = notification.userInfo[@"action"];
	if([@"add" isEqualToString: action])
	{
		CBIdentification *identification = notification.userInfo[@"object"];
		void (^handle)() = ^{
			[_data insertObject: identification atIndex: 0];
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
	else if([@"update" isEqualToString: action])
	{
		CBIdentification *identification = notification.userInfo[@"object"];
		void (^handle)() = ^{
			int i = 0;
			for(CBIdentification *temp in _data)
			{
				if([temp.number isEqualToString: identification.number])
				{
					NSIndexPath *indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
					dispatch_async(dispatch_get_main_queue(), ^{
						if(i < _data.count)
						{
							_data[i] = identification;
							[self.tableView reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
						}
					});
					break;
				}
				i++;
			}
		};
		if([NSThread currentThread].isMainThread)
		{
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), handle);
		}
		else
		{
			handle();
		}
	}
	else if([@"del" isEqualToString: action])
	{
		NSString *number = notification.userInfo[@"object"];
		void (^handle)() = ^{
			int i = 0;
			for(CBIdentification *identification in _data)
			{
				if([number isEqualToString: identification.number])
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
		/*
		NSArray<NSString *> *numbers = notification.userInfo[@"object"];
		void (^handle)() = ^{
			NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity: numbers.count];
			for(NSString *number in numbers)
			{
				NSIndexPath *indexPath = nil;
				int i = 0;
				for(CBIdentification *identification in _data)
				{
					if([number isEqualToString: identification.number])
					{
						indexPath = [NSIndexPath indexPathForRow: i inSection: 0];
						[indexPaths addObject: indexPath];
						break;
					}
					i++;
				}
			}
			NSArray *sortedIndexs = [indexPaths sortedArrayUsingComparator: ^NSComparisonResult(NSIndexPath * _Nonnull obj1, NSIndexPath * _Nonnull obj2) {
				return obj1.row < obj2.row;
			}];
			dispatch_async(dispatch_get_main_queue(), ^{
				for(NSInteger i = sortedIndexs.count - 1;i >= 0;i--)
				{
					NSIndexPath *indexPath = sortedIndexs[i];
					[_data removeObjectAtIndex: indexPath.row];
				}
				[self.tableView deleteRowsAtIndexPaths: sortedIndexs withRowAnimation: UITableViewRowAnimationTop];
			});
		};
		if([NSThread currentThread].isMainThread)
		{
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), handle);
		}
		else
		{
			handle();
		}
		*/
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
	self.tableView.rowHeight = 64.0;
	[self.tableView registerClass: [CBIdentificationListTableViewCell class] forCellReuseIdentifier: kIdentificationCellIdentifier];
}

#pragma mark - UI handle

- (void)onAddButtonPressed
{
	CBEditIdentificationViewController *viewController = [[CBEditIdentificationViewController alloc] initWithIdentification: nil];
	[self.navigationController pushViewController: viewController animated: YES];
}

- (void)onEditPressedAtIndexPath: (NSIndexPath *)indexPath
{
	CBIdentification *identification = _data[indexPath.row];
	CBEditIdentificationViewController *viewController = [[CBEditIdentificationViewController alloc] initWithIdentification: identification];
	[self.navigationController pushViewController: viewController animated: YES];
}

- (void)onDeletePressedAtIndexPath: (NSIndexPath *)indexPath
{
	CBIdentification *identification = _data[indexPath.row];
	[_identificationService removeIdentificationWithNumber: identification.number completion: nil];
}

@end
