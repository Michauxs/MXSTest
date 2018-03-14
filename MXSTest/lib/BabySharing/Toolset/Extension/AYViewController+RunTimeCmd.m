//
//  AYViewController+RunTimeCmd.m
//  BabySharing
//
//  Created by Alfred Yang on 13/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYViewController+RunTimeCmd.h"

@implementation AYViewController (RunTimeCmd)

- (void)performAYSel:(NSString*)selector withResult:(NSObject**)obj {
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

@end
