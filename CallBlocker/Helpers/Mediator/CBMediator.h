//
//  CBMediator.h
//  CallBlocker
//
//  Created by Aalen on 2016/10/27.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SingletonMacro.h"

@interface CBMediator : NSObject

SingletonDeclaration

- (id)performAction: (NSString *)actionName target: (NSString *)targetName params: (NSDictionary *)params;

@end
