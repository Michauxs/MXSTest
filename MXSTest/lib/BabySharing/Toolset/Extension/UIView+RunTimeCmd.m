//
//  UIView+RunTimeCmd.m
//  BabySharing
//
//  Created by Alfred Yang on 7/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "UIView+RunTimeCmd.h"

@implementation UIView (RunTimeCmd)

#pragma mark - Cmd

- (void)performAYSel:(NSString *)selector withResult:(NSObject *__autoreleasing *)obj {
	
	SEL sel = NSSelectorFromString(selector);
	Method m = class_getInstanceMethod([self class], sel);
	
	id result = nil;
	if (obj != nil) {
		id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
		result = func(self, sel, *obj);
		*obj = result;
	} else {
		id (*func)(id, SEL) = (id (*)(id, SEL))method_getImplementation(m);
		result = func(self, sel);
	}
}

#pragma mark - UI
- (void)setRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor*)color background:(UIColor*)backColor {
	self.layer.cornerRadius = radius;
	self.layer.borderWidth = width;
	
	self.layer.rasterizationScale = [UIScreen mainScreen].scale;
	self.clipsToBounds = YES;
	
	if (color) {
		self.layer.borderColor = color.CGColor;
	}
	if (backColor) {
		self.backgroundColor = backColor;
	}
}

- (void)setImageViewContentMode {
	self.clipsToBounds = YES;
	self.contentMode = UIViewContentModeScaleAspectFill;
}

@end
