//
//  UIColor+Custom.h
//  BabySharing
//
//  Created by Alfred Yang on 8/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Custom)

+ (UIColor *)random;
+ (UIColor *)white;

+ (UIColor *)theme;
+ (UIColor *)themeBorder;
+ (UIColor *)themeLight;

+ (UIColor *)black;
+ (UIColor *)gary;
+ (UIColor *)lightGary;
+ (UIColor*)RGB153Gary;
+ (UIColor*)RGB89Gary;
+ (UIColor*)RGB127Gary;
+ (UIColor*)RGB225Gary;

+ (UIColor *)garyLine;
+ (UIColor *)garyBackground;
+ (UIColor *)darkBackground;

+ (UIColor *)disableBackground;

+ (UIColor *)borderAlpha;
+ (UIColor *)colorWithRED:(CGFloat)RED GREEN:(CGFloat)GREEN BLUE:(CGFloat)BLUE ALPHA:(CGFloat)ALPHA;

@end
