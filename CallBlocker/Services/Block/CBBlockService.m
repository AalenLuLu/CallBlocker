//
//  CBBlockService.m
//  CallBlocker
//
//  Created by Aalen on 2016/11/2.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBBlockService.h"

#import "CBStoreHelper.h"
#import "CBBlockNumber.h"
#import "CBCallDirectoryUtil.h"

#import <CallKit/CallKit.h>

NSString * const kCBBlockNumberDidChangedNotification = @"com.aalen.callblocker.blocknumber.didchanged.notification";

NSString * const kBlockNumberTableName = @"t_blocknumber";

@interface CBBlockService ()

@property (strong, nonatomic) CBStoreHelper *store;
@property (strong, nonatomic) CXCallDirectoryManager *manager;

@end

@implementation CBBlockService

ARCSingletonImplement(CBBlockService)

- (instancetype)init
{
	if(self = [super init])
	{
		_manager = [CXCallDirectoryManager sharedInstance];
		_store = [CBStoreHelper shareInstance];
		[self createBlockNumberTable];
	}
	return self;
}

#pragma mark - interface

- (void)addBlockNumber:(CBBlockNumber *)blockNumber completion:(void (^)())completion
{
	NSString *sql = [[NSString alloc] initWithFormat: @"INSERT INTO %@ (number, orderid) VALUES (?, ?);", kBlockNumberTableName];
	[_store sharedDataExecuteWithSql: sql params: @[blockNumber.number, blockNumber.numericNumber] completion: ^{
		[[NSNotificationCenter defaultCenter] postNotificationName: kCBBlockNumberDidChangedNotification object: nil userInfo: @{@"action": @"add", @"object": blockNumber}];
		if(completion)
		{
			completion();
		}
		[self autoReloadBlock];
	}];
}

- (void)queryBlockNumbersWithCompletion:(void (^)(NSArray<CBBlockNumber *> *))completion
{
	NSString *sql = [[NSString alloc] initWithFormat: @"SELECT number, orderid FROM %@ ORDER BY id DESC;", kBlockNumberTableName];
	[_store sharedDataQueryWithSql: sql params: nil completion: ^(NSArray *record) {
		if(completion)
		{
			NSMutableArray *blockNumbers = [[NSMutableArray alloc] initWithCapacity: record.count];
			for(NSDictionary *dic in record)
			{
				CBBlockNumber *blockNumber = [[CBBlockNumber alloc] init];
				blockNumber.number = dic[@"number"];
				blockNumber.numericNumber = dic[@"orderid"];
				[blockNumbers addObject: blockNumber];
			}
			completion(blockNumbers);
		}
	}];
}

- (void)removeBlockNumber:(NSString *)number completion:(void (^)())completion
{
	NSString *sql = [[NSString alloc] initWithFormat: @"DELETE FROM %@ WHERE number = ?;", kBlockNumberTableName];
	[_store sharedDataExecuteWithSql: sql params: @[number] completion: ^{
		[[NSNotificationCenter defaultCenter] postNotificationName: kCBBlockNumberDidChangedNotification object: nil userInfo: @{@"action": @"del", @"object": number}];
		if(completion)
		{
			completion();
		}
		[self autoReloadBlock];
	}];
}

#pragma mark - for call directory function

- (NSUInteger)queryBlockNumberCount
{
	__block NSUInteger result = 0;
	NSString *sql = [[NSString alloc] initWithFormat: @"SELECT COUNT(*) count FROM %@;", kBlockNumberTableName];
	[_store sharedDataQueryWithSql: sql params: nil completion: ^(NSArray *record) {
		NSDictionary *dic = record.firstObject;
		result = [dic[@"count"] unsignedIntegerValue];
	}];
	return result;
}

- (void)queryBlockNumbersAtPage:(NSUInteger)page size:(NSUInteger)size completion:(void (^)(NSArray<CBBlockNumber *> *))completion
{
	NSString *sql = [[NSString alloc] initWithFormat: @"SELECT number, orderid FROM %@ ORDER BY orderid LIMIT %ld OFFSET %ld;", kBlockNumberTableName, size, (page - 1) * size];
	[_store sharedDataQueryWithSql: sql params: nil completion: ^(NSArray *record) {
		if(completion)
		{
			NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity: record.count];
			for(NSDictionary *dic in record)
			{
				CBBlockNumber *blockNumber = [[CBBlockNumber alloc] init];
				blockNumber.number = dic[@"number"];
				blockNumber.numericNumber = dic[@"orderid"];
				[result addObject: blockNumber];
			}
			completion(result);
		}
	}];
}

#pragma mark - private function

- (void)createBlockNumberTable
{
	NSString *sql = [[NSString alloc] initWithFormat: @"CREATE TABLE IF NOT EXISTS %@ (id INTEGER PRIMARY KEY AUTOINCREMENT, number TEXT NOT NULL UNIQUE, orderid INTEGER);", kBlockNumberTableName];
	[_store sharedDataExecuteWithSql: sql params: nil completion: nil];
}

- (void)autoReloadBlock
{
	if([[NSUserDefaults standardUserDefaults] boolForKey: @"autoreloadblock"])
	{
		CBCallDirectoryUtil *callDirectoryUtil = [[CBCallDirectoryUtil alloc] initWithType: CBCallDirectoryType_Block];
		[callDirectoryUtil isEnableCallDirectoryWithHandler: ^(BOOL isEnable) {
			if(isEnable)
			{
				[callDirectoryUtil synchronizeWithCompletion: nil];
			}
		}];
	}
}

@end
