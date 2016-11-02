//
//  UIColor+Hex.h
//  CallBlocker
//
//  Created by Aalen on 2016/11/1.
//  Copyright © 2016年 Aalen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexValue: (NSInteger)hexValue alpha: (CGFloat)alpha;

@end
