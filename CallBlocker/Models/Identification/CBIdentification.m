//
//  CBIdentification.m
//  CallBlocker
//
//  Created by Aalen on 2016/10/28.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "CBIdentification.h"

@implementation CBIdentification

- (instancetype)init
{
	return [self initWithNumber: nil name: nil];
}

- (instancetype)initWithNumber:(NSString *)number name:(NSString *)name
{
	if(self = [super init])
	{
		_number = [number copy];
		_name = [name copy];
		int64_t digiNumber = [number longLongValue];
		NSMutableString *strNumber = [[NSMutableString alloc] initWithFormat: @"%llu", digiNumber];
		if([number isEqualToString: strNumber])
		{
			//no prefix 0 && no +
			if([number hasPrefix: @"86"] && 8 == number.length)
			{
				//fixed phone
				[strNumber insertString: @"86" atIndex: 0];
			}
			else if(![number hasPrefix: @"86"])
			{
				//no prefix 86
				[strNumber insertString: @"86" atIndex: 0];
			}
		}
		else
		{
			//has prefix 0 or has +
			if(![number hasPrefix: @"+86"])
			{
				//no +86
				[strNumber insertString: @"86" atIndex: 0];
			}
		}
		_numericNumber = @([strNumber longLongValue]);
	}
	return self;
}

@end
