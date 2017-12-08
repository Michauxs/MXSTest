//
//  UIView+RunTimeCmd.m
//  BabySharing
//
//  Created by Alfred Yang on 7/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "UIView+RunTimeCmd.h"

@implementation UIView (RunTimeCmd)

//- (void)performNotify:(NSString*)selector withResult:(NSObject**)obj {
//	SEL sel = NSSelectorFromString(selector);
//	AYViewController *vc = ((id<AYViewBase>)self).controller;
//	Method m = class_getInstanceMethod([vc class], sel);
//	
//	id result = nil;
//	if (obj != nil) {
//		id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
//		result = func(self, sel, *obj);
//		*obj = result;
//	} else {
//		id (*func)(id, SEL) = (id (*)(id, SEL))method_getImplementation(m);
//		result = func(self, sel);
//	}
//}
//
//- (void)performMessage:(NSString *)selector withResult:(NSObject *__autoreleasing *)obj {
//	
//	SEL sel = NSSelectorFromString(selector);
//	Method m = class_getInstanceMethod([self class], sel);
//	
//	id result = nil;
//	if (obj != nil) {
//		id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
//		result = func(self, sel, *obj);
//		*obj = result;
//	} else {
//		id (*func)(id, SEL) = (id (*)(id, SEL))method_getImplementation(m);
//		result = func(self, sel);
//	}
//}

@end
