//
//  CBIdentification.h
//  CallBlocker
//
//  Created by Aalen on 2016/10/28.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBIdentification : NSObject

@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSNumber *numericNumber;

- (instancetype)initWithNumber: (NSString *)number name: (NSString *)name;

@end
