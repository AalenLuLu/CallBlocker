//
//  CBBlockNumber.h
//  CallBlocker
//
//  Created by Aalen on 2016/11/2.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBBlockNumber : NSObject

@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSNumber *numericNumber;

- (instancetype)initWithNumber: (NSString *)number;

@end
