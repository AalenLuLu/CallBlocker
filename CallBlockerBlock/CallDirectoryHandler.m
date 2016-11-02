//
//  CallDirectoryHandler.m
//  CallBlockerBlock
//
//  Created by Aalen on 2016/10/28.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CallDirectoryHandler.h"

#import "CBBlockService.h"
#import "CBBlockNumber.h"

@interface CallDirectoryHandler () <CXCallDirectoryExtensionContextDelegate>

@property (strong, nonatomic) CBBlockService *blockService;

@end

@implementation CallDirectoryHandler

- (void)beginRequestWithExtensionContext:(CXCallDirectoryExtensionContext *)context {
    context.delegate = self;
	_blockService = [CBBlockService shareInstance];

    if (![self addBlockingPhoneNumbersToContext:context]) {
        NSLog(@"Unable to add blocking phone numbers");
        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:1 userInfo:nil];
        [context cancelRequestWithError:error];
        return;
    }
    
//    if (![self addIdentificationPhoneNumbersToContext:context]) {
//        NSLog(@"Unable to add identification phone numbers");
//        NSError *error = [NSError errorWithDomain:@"CallDirectoryHandler" code:2 userInfo:nil];
//        [context cancelRequestWithError:error];
//        return;
//    }
	
    [context completeRequestWithCompletionHandler:nil];
}

- (BOOL)addBlockingPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
//    CXCallDirectoryPhoneNumber phoneNumbers[] = { 14085555555, 18005555555 };
//    NSUInteger count = (sizeof(phoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));
//
//    for (NSUInteger index = 0; index < count; index += 1) {
//        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbers[index];
//        [context addBlockingEntryWithNextSequentialPhoneNumber:phoneNumber];
//    }
	
	NSUInteger size = 500;
	
	NSUInteger count = [_blockService queryBlockNumberCount];
	
	NSUInteger loop = count / size + 1;
	
	for(NSUInteger i = 0;i < loop;i++)
	{
		@autoreleasepool {
			[_blockService queryBlockNumbersAtPage: i + 1 size: size completion: ^(NSArray<CBBlockNumber *> *record) {
				for(CBBlockNumber *blockNumber in record)
				{
					[context addBlockingEntryWithNextSequentialPhoneNumber: [blockNumber.numericNumber longLongValue]];
				}
			}];
		}
	}

    return YES;
}

- (BOOL)addIdentificationPhoneNumbersToContext:(CXCallDirectoryExtensionContext *)context {
    // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
    // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
    //
    // Numbers must be provided in numerically ascending order.
    CXCallDirectoryPhoneNumber phoneNumbers[] = { 18775555555, 18885555555 };
    NSArray<NSString *> *labels = @[ @"Telemarketer", @"Local business" ];
    NSUInteger count = (sizeof(phoneNumbers) / sizeof(CXCallDirectoryPhoneNumber));

    for (NSUInteger i = 0; i < count; i += 1) {
        CXCallDirectoryPhoneNumber phoneNumber = phoneNumbers[i];
        NSString *label = labels[i];
        [context addIdentificationEntryWithNextSequentialPhoneNumber:phoneNumber label:label];
    }

    return YES;
}

#pragma mark - CXCallDirectoryExtensionContextDelegate

- (void)requestFailedForExtensionContext:(CXCallDirectoryExtensionContext *)extensionContext withError:(NSError *)error {
    // An error occurred while adding blocking or identification entries, check the NSError for details.
    // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
    //
    // This may be used to store the error details in a location accessible by the extension's containing app, so that the
    // app may be notified about errors which occured while loading data even if the request to load data was initiated by
    // the user in Settings instead of via the app itself.
}

@end
