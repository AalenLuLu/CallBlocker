//
//  UIColor+Hex.m
//  CallBlocker
//
//  Created by Aalen on 2016/11/1.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHexValue:(NSInteger)hexValue alpha:(CGFloat)alpha
{
	return [UIColor colorWithRed: ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0
						   green: ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0
							blue: ((CGFloat)(hexValue & 0xFF)) / 255.0
						   alpha: alpha];
}

@end
