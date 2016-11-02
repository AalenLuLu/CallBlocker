//
//  CBStoreHelper.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/27.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBStoreHelper.h"

#import <FMDB/FMDatabaseQueue.h>
#import <FMDB/FMDatabase.h>
#import <sqlite3.h>

@interface CBStoreHelper ()

@property (strong, nonatomic) FMDatabaseQueue *sharedDataQueue;
@property (strong, nonatomic) FMDatabaseQueue *unsharedDataQueue;

@end

@implementation CBStoreHelper

ARCSingletonImplement(CBStoreHelper)

- (instancetype)init
{
	if(self = [super init]){
		NSURL *groupURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier: @"group.com.aalen.callblocker"];
		groupURL = [groupURL URLByAppendingPathComponent: @"Library/share/"];
		if(![[NSFileManager defaultManager] fileExistsAtPath: groupURL.absoluteString])
		{
			[[NSFileManager defaultManager] createDirectoryAtURL:groupURL withIntermediateDirectories: YES attributes: nil error: nil];
		}
		groupURL = [groupURL URLByAppendingPathComponent: @"database.sqlite"];
		_sharedDataQueue = [[FMDatabaseQueue alloc] initWithPath: groupURL.absoluteString flags: SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE];
		
		NSString *unsharedPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent: @"database"];
		if(![[NSFileManager defaultManager] fileExistsAtPath: unsharedPath])
		{
			[[NSFileManager defaultManager] createDirectoryAtPath: unsharedPath withIntermediateDirectories: YES attributes: nil error: nil];
		}
		unsharedPath = [unsharedPath stringByAppendingPathComponent: @"database.sqlite"];
		_unsharedDataQueue = [[FMDatabaseQueue alloc] initWithPath: unsharedPath flags: SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE];
	}
	return self;
}

#pragma mark shared data handle

- (void)sharedDataExecuteWithSql:(NSString *)sql params:(NSArray *)params completion: (void (^)())completion
{
	[self executeUsingQueue: _sharedDataQueue sql: sql params: params completion: completion];
}

- (void)sharedDataQueryWithSql:(NSString *)sql params:(NSArray *)params completion:(void (^)(NSArray *))completion
{
	[self queryUsingQueue: _sharedDataQueue sql: sql params: params completion: completion];
}

- (void)sharedDataExecuteTransactionWithSqls:(NSArray<NSString *> *)sqls params:(NSArray<NSArray *> *)params completion: (void (^)())completion
{
	[self executeTransactionUsingQueue: _sharedDataQueue sqls: sqls params: params completion: completion];
}

#pragma mark unshared data handle

- (void)unsharedDataExecuteWithSql:(NSString *)sql params:(NSArray *)params completion: (void (^)())completion
{
	[self executeUsingQueue: _unsharedDataQueue sql: sql params: params completion: completion];
}

- (void)unsharedDataQueryWithSql:(NSString *)sql params:(NSArray *)params completion:(void (^)(NSArray *))completion
{
	[self queryUsingQueue: _unsharedDataQueue sql: sql params: params completion: completion];
}

- (void)unsharedDataExecuteTransactionWithSqls:(NSArray<NSString *> *)sqls params:(NSArray<NSArray *> *)params completion: (void (^)())completion
{
	[self executeTransactionUsingQueue: _unsharedDataQueue sqls: sqls params: params completion: completion];
}

#pragma mark private function

- (void)executeUsingQueue: (FMDatabaseQueue *)queue sql: (NSString *)sql params: (NSArray *)params completion: (void (^)())completion
{
	if(nil == sql)
	{
		return;
	}
	[queue inDatabase: ^(FMDatabase *db) {
		BOOL result = [db executeUpdate: sql withArgumentsInArray: params];
		if(!result)
		{
			NSLog(@"%@", db.lastError);
		}
	}];
	if(completion)
	{
		completion();
	}
}

- (void)queryUsingQueue: (FMDatabaseQueue *)queue sql: (NSString *)sql params: (NSArray *)params completion:(void (^)(NSArray *))completion
{
	if(nil == sql)
	{
		return;
	}
	NSMutableArray *result = [[NSMutableArray alloc] init];
	[queue inDatabase: ^(FMDatabase *db) {
		FMResultSet *resultSet = [db executeQuery: sql withArgumentsInArray: params];
		while([resultSet next])
		{
			[result addObject: [resultSet resultDictionary]];
		}
		[resultSet close];
	}];
	if(completion)
	{
		completion(result);
	}
}

- (void)executeTransactionUsingQueue: (FMDatabaseQueue *)queue sqls: (NSArray<NSString *> *)sqls params: (NSArray<NSArray *> *)params completion: (void (^)())completion
{
	if(nil == sqls)
	{
		return;
	}
	[queue inTransaction: ^(FMDatabase *db, BOOL *rollback) {
		for(int i = 0;i < sqls.count; i++)
		{
			NSString *sql = sqls[i];
			NSArray *param = params[i];
			[db executeUpdate: sql withArgumentsInArray: param];
		}
	}];
	if(completion)
	{
		completion();
	}
}

@end
