//
//  MXSPushCommand.m
//  MXSTest
//
//  Created by Alfred Yang on 2/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSVCExchangeCmd.h"

@implementation MXSVCExchangeCmd

static MXSVCExchangeCmd *_instance;

+ (id)allocWithZone:(NSZone *)zone {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [super allocWithZone:zone];
	});
	return _instance;
}

+ (MXSVCExchangeCmd *)shared {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_instance = [[self alloc] init];
	});
	return _instance;
}

- (void)vc:(id)vc performSelector:(NSString*)method args:(id)args {
	SEL sel = NSSelectorFromString(method);
	Method m = class_getInstanceMethod([vc class], sel);
	IMP imp = method_getImplementation(m);
	id (*func)(id, SEL, id) = (id (*)(id, SEL, id))imp;
	func(vc, sel, args);
}

- (id)getClassFromClassName:(NSString*)c_name {
	Class c = NSClassFromString(c_name);
	return [[c alloc] init];
//	Method m = class_getClassMethod(c, @selector(factoryInstance));//获取类方法
//	IMP im = method_getImplementation(m);
//	return im(c, @selector(factoryInstance));
}

#pragma mark - Action Method
#pragma mark - Push
- (void)fromVC:(id)f_vc pushVC:(id)t_vc withArgs:(id)args {
	t_vc = [self getClassFromClassName:t_vc];
	if (args) {
		[self vc:t_vc performSelector:ReceiveArgsTypeAction args:args];
	}
	((MXSViewController*)t_vc).hidesBottomBarWhenPushed = YES;
	[[(MXSViewController*)f_vc navigationController] pushViewController:t_vc animated:YES];
}

#pragma mark - Pop
- (void)fromVC:(id)f_vc popOneStepWithArgs:(id)args {
	
	[[(MXSViewController*)f_vc navigationController] popViewControllerAnimated:YES];
	MXSViewController* recev = ((MXSViewController*)f_vc).navigationController.viewControllers.lastObject;
	
	if (args) {
		[self vc:recev performSelector:ReceiveArgsTypeBack args:args];
	}
}
- (void)fromVC:(id)f_vc popToDestVC:(id)d_vc withArgs:(id)args {
	d_vc = [self getClassFromClassName:d_vc];
	
	MXSViewController* des = nil;
	for (MXSViewController *iter in ((MXSViewController*)f_vc).navigationController.viewControllers) {
		if ([iter isKindOfClass:[d_vc class]]) {
			des = iter;
		}
	}
	[[(MXSViewController*)f_vc navigationController] popToViewController:des animated:YES];
	if (args) {
		[self vc:des performSelector:ReceiveArgsTypeBack args:args];
	}
}
- (void)fromVC:(id)f_vc popToRootWithArgs:(id)args {
	
	[[(MXSViewController*)f_vc navigationController] popToRootViewControllerAnimated:YES];
	MXSViewController* recev = ((MXSViewController*)f_vc).navigationController.viewControllers.firstObject;
	if (args) {
		[self vc:recev performSelector:ReceiveArgsTypeBack args:args];
	}
}

#pragma mark - Module
- (void)fromVC:(id)f_vc moduleVC:(id)t_vc withArgs:(id)args {
	
}
- (void)fromVC:(id)f_vc dismissWithArgs:(id)args {
	
}

@end
