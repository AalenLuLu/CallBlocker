//
//  SingletonMacro.h
//  VVM
//
//  Created by Aalen on 16/8/18.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#ifndef SingletonMacro_h
#define SingletonMacro_h

#define SingletonDeclaration + (instancetype)shareInstance;

#define ARCSingletonImplement(x) static x *sharedInstance = nil;		\
																		\
+ (instancetype)shareInstance											\
{																		\
	if(nil == sharedInstance)											\
	{																	\
		@synchronized(self)												\
		{																\
			if(nil == sharedInstance)									\
			{															\
				sharedInstance = [[super allocWithZone: NULL] init];	\
			}															\
		}																\
	}																	\
	return sharedInstance;												\
}																		\
																		\
+ (instancetype)allocWithZone:(struct _NSZone *)zone					\
{																		\
	return [self shareInstance];										\
}

#define MRRSingletonImplement(x) static x *sharedInstance = nil;		\
																		\
+ (instancetype)shareInstance											\
{																		\
	if(nil == sharedInstance)											\
	{																	\
		@synchronized(self)												\
		{																\
			if(nil == sharedInstance)									\
			{															\
				sharedInstance = [[super allocWithZone: NULL] init];	\
			}															\
		}																\
	}																	\
	return sharedInstance;												\
}																		\
																		\
+ (instancetype)allocWithZone:(struct _NSZone *)zone					\
{																		\
	return [[self shareInstance] retain];								\
}																		\
																		\
- (id)copyWithZone:(struct _NSZone *)zone								\
{																		\
	return self;														\
}																		\
																		\
- (id)retain															\
{																		\
	return self;														\
}																		\
																		\
- (NSUInteger)retainCount												\
{																		\
	return NSUIntegerMax;												\
}																		\
																		\
- (oneway void)release													\
{																		\
																		\
}																		\
																		\
- (id)autorelease														\
{																		\
	return self;														\
}

#endif /* SingletonMacro_h */
