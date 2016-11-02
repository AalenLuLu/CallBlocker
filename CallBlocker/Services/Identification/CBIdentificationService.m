//
//  CBIdentificationService.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/28.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBIdentificationService.h"

#import "CBStoreHelper.h"
#import "CBIdentification.h"
#import "CBCallDirectoryUtil.h"

#import <CallKit/CallKit.h>

NSString * const kCBIdentificationDidChangedNotification = @"com.aalen.callblocker.identification.didchanged.notification";

NSString * const kIdentificationTableName = @"t_identification";

@interface CBIdentificationService ()

@property (strong, nonatomic) CBStoreHelper *store;
@property (strong, nonatomic) CXCallDirectoryManager *manager;

@end

@implementation CBIdentificationService

ARCSingletonImplement(CBIdentificationService)

- (instancetype)init
{
	if(self = [super init])
	{
		_manager = [CXCallDirectoryManager sharedInstance];
		_store = [CBStoreHelper shareInstance];
		[self createIdentificationTable];
	}
	return self;
}

#pragma mark - interface

- (void)addIdentification:(CBIdentification *)identification completion:(void (^)())completion
{
	NSString *sql = [[NSString alloc] initWithFormat: @"INSERT INTO %@ (number, identification, orderid) VALUES (?, ?, ?);", kIdentificationTableName];
	[_store sharedDataExecuteWithSql: sql params: @[identification.number, identification.name, identification.numericNumber] completion: ^{
		[[NSNotificationCenter defaultCenter] postNotificationName: kCBIdentificationDidChangedNotification object: nil userInfo: @{@"action": @"add", @"object": identification}];
		if(completion)
		{
			completion();
		}
		[self autoReloadIdentification];
	}];
}

- (void)queryIdentificationWithCompletion:(void (^)(NSArray<CBIdentification *> *record))completion
{
	NSString *sql = [[NSString alloc] initWithFormat: @"SELECT number, identification, orderid FROM %@ ORDER BY id DESC;", kIdentificationTableName];
	[_store sharedDataQueryWithSql: sql params: nil completion: ^(NSArray *record) {
		if(completion)
		{
			NSMutableArray *identifications = [[NSMutableArray alloc] initWithCapacity: record.count];
			for(NSDictionary *dic in record)
			{
//				CBIdentification *identification = [[CBIdentification alloc] initWithNumber: dic[@"number"] name: dic[@"identification"]];
				CBIdentification *identification = [[CBIdentification alloc] init];
				identification.number = dic[@"number"];
				identification.name = dic[@"identification"];
				identification.numericNumber = dic[@"orderid"];
				[identifications addObject: identification];
			}
			completion(identifications);
		}
	}];
}

- (void)updateIdentification:(CBIdentification *)identification completion:(void (^)())completion
{
	NSString *sql = [[NSString alloc] initWithFormat: @"INSERT OR REPLACE INTO %@ (number, identification, orderid) VALUES (?, ?, ?);", kIdentificationTableName];
	[_store sharedDataExecuteWithSql: sql params: @[identification.number, identification.name, identification.numericNumber] completion: ^{
		[[NSNotificationCenter defaultCenter] postNotificationName: kCBIdentificationDidChangedNotification object: nil userInfo: @{@"action": @"update", @"object": identification}];
		if(completion)
		{
			completion();
		}
		[self autoReloadIdentification];
	}];
}

- (void)removeIdentificationWithNumber:(NSString *)number completion:(void (^)())completion
{
	NSString *sql = [[NSString alloc] initWithFormat: @"DELETE FROM %@ WHERE number = ?;", kIdentificationTableName];
	[_store sharedDataExecuteWithSql: sql params: @[number] completion: ^{
		[[NSNotificationCenter defaultCenter] postNotificationName: kCBIdentificationDidChangedNotification object: nil userInfo: @{@"action": @"del", @"object": number}];
		if(completion)
		{
			completion();
		}
		[self autoReloadIdentification];
	}];
}

- (void)removeIdentificationWithNumbers:(NSArray<NSString *> *)numbers completion: (void (^)())completion
{
	void (^handle)() = ^{
		[[NSNotificationCenter defaultCenter] postNotificationName: kCBIdentificationDidChangedNotification object: nil userInfo: @{@"action": @"del", @"object": numbers}];
		if(completion)
		{
			completion();
		}
		[self autoReloadIdentification];
	};
	if(500 < numbers.count)
	{
		//more than 500...
		NSMutableArray *sqls = [[NSMutableArray alloc] init];
		NSMutableArray *subNumbers = [[NSMutableArray alloc] initWithCapacity: 500];
		for(int i = 0;i < numbers.count;i++)
		{
			NSString *number = numbers[i];
			[subNumbers addObject: number];
			if(0 == i % 500 || i == numbers.count - 1)
			{
				NSString *numberString = [subNumbers componentsJoinedByString: @"','"];
				NSString *sql = [[NSString alloc] initWithFormat: @"DELETE FROM %@ WHERE number in ('%@');", kIdentificationTableName, numberString];
				[sqls addObject: sql];
				[subNumbers removeAllObjects];
			}
		}
		[_store sharedDataExecuteTransactionWithSqls: sqls params: nil completion: handle];
	}
	else
	{
		//less than or equal to 500...
		NSString *numbersString = [numbers componentsJoinedByString: @"','"];
		NSString *sql = [[NSString alloc] initWithFormat: @"DELETE FROM %@ WHERE number in ('%@')", kIdentificationTableName, numbersString];
		[_store sharedDataExecuteWithSql: sql params: nil completion: handle];
	}
}

- (void)reloadIdentificationWithCompletion:(void (^)(BOOL))completion
{
	
}

#pragma mark - for call directory function

- (NSUInteger)queryIdentificationCount
{
	__block NSUInteger result = 0;
	NSString *sql = [[NSString alloc] initWithFormat: @"SELECT COUNT(*) count FROM %@;", kIdentificationTableName];
	[_store sharedDataQueryWithSql: sql params: nil completion: ^(NSArray *record) {
		NSDictionary *dic = record.firstObject;
		result = [dic[@"count"] unsignedIntegerValue];
	}];
	return result;
}

- (void)queryIdentificationAtPage:(NSUInteger)page size:(NSUInteger)size completion:(void (^)(NSArray<CBIdentification *> *))completion
{
	//[sql appendFormat: @"LIMIT %ld OFFSET %ld;", size, (page - 1) * size];
	NSString *sql = [[NSString alloc] initWithFormat: @"SELECT number, identification, orderid FROM %@ ORDER BY orderid LIMIT %ld OFFSET %ld;", kIdentificationTableName, size, (page - 1) * size];
	[_store sharedDataQueryWithSql: sql params: nil completion: ^(NSArray *record) {
		if(completion)
		{
			NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity: record.count];
			for(NSDictionary *dic in record)
			{
//				CBIdentification *identification = [[CBIdentification alloc] initWithNumber: dic[@"number"] name: dic[@"identification"]];
				CBIdentification *identification = [[CBIdentification alloc] init];
				identification.number = dic[@"number"];
				identification.name = dic[@"identification"];
				identification.numericNumber = dic[@"orderid"];
				[result addObject: identification];
			}
			completion(result);
		}
	}];
}

#pragma mark - private function

- (void)createIdentificationTable
{
	NSString *sql = [[NSString alloc] initWithFormat: @"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, number TEXT NOT NULL UNIQUE, identification TEXT NOT NULL, orderid INTEGER);", kIdentificationTableName];
	[_store sharedDataExecuteWithSql: sql params: nil completion: nil];
}

- (void)autoReloadIdentification
{
	if([[NSUserDefaults standardUserDefaults] boolForKey: @"autoreloadidentification"])
	{
		CBCallDirectoryUtil *callDirectoryUtil = [[CBCallDirectoryUtil alloc] initWithType: CBCallDirectoryType_Identification];
		[callDirectoryUtil isEnableCallDirectoryWithHandler: ^(BOOL isEnable) {
			if(isEnable)
			{
				[callDirectoryUtil synchronizeWithCompletion: nil];
			}
		}];
	}
}

@end
