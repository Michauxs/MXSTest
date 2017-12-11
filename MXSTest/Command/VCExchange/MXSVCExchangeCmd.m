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
	
//	NSString* factoryName = @"";
//	Class c = NSClassFromString(factoryName);
//	Method m = class_getClassMethod(c, @selector(factoryInstance));//获取类方法
//	IMP im = method_getImplementation(m);
//	fac = im(c, @selector(factoryInstance));
}

- (id)getClassFromClassName:(NSString*)c_name {
	Class c = NSClassFromString(c_name);
	return [[c alloc] init];
}

#pragma mark - Action Method
#pragma mark - Push
- (void)fromVC:(id)f_vc pushVC:(id)t_vc withArgs:(id)args {
	t_vc = [self getClassFromClassName:t_vc];
	if (args) {
		[self vc:t_vc performSelector:MethodReceiveArgsTypePost args:args];
	}
	((MXSViewController*)t_vc).hidesBottomBarWhenPushed = YES;
	[[(MXSViewController*)f_vc navigationController] pushViewController:t_vc animated:YES];
	
}

- (void)pushAnimatVCFrom:(id)f_vc to:(id)t_vc withArgs:(id)args {
	t_vc = [self getClassFromClassName:t_vc];
	
	MXSProfileVC *firstVC = f_vc;
	MXSShowImageVC *secondVC = t_vc;
	
	MXShowTableCell *cell = [firstVC.showTable cellForRowAtIndexPath:args];
	
	UIView *snapShotView = [firstVC.tabBarController.view snapshotViewAfterScreenUpdates:NO];
	CGRect firstFrame  = [firstVC.view convertRect:cell.img.frame fromView:cell];
//	CGRect secondFrame = [secondVC.view convertRect:secondVC.showImg.frame fromView:secondVC.view];
	
	secondVC.popFrame = firstFrame;
	
	((MXSViewController*)t_vc).hidesBottomBarWhenPushed = YES;
	[[(MXSViewController*)f_vc navigationController] pushViewController:t_vc animated:NO];
	
//	secondVC.showImg.hidden = YES;
	
	CGRect secondFrame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	snapShotView.frame = secondFrame;
	firstVC.animatImgView = snapShotView;
	[secondVC.view addSubview:snapShotView];
	
	CGFloat scala_w = SCREEN_WIDTH/firstFrame.size.width;
	CGFloat scala_h = 160/firstFrame.size.height;
	
	CGRect retFrame = CGRectMake(- firstFrame.origin.x * scala_w, - firstFrame.origin.y * scala_h + 60, SCREEN_WIDTH*scala_w, secondFrame.size.height * scala_h);
	
	
	[UIView animateWithDuration:0.5 animations:^{
		snapShotView.frame = retFrame;
		snapShotView.alpha = 0;
	} completion:^(BOOL finished) {
		secondVC.showImg.hidden = NO;
	}];
}

- (void)popAnimatVCFrom:(id)f_vc withArgs:(id)args {
	UINavigationController * nav = ((MXSViewController*)f_vc).navigationController;
	[nav popViewControllerAnimated:NO];
	MXSViewController* recev = nav.viewControllers.lastObject;
	
	if (args) {
		[self vc:recev performSelector:MethodReceiveArgsTypeBack args:args];
	}
	
	SEL sel = NSSelectorFromString(@"respondPopAnimat");
	Method m = class_getInstanceMethod([recev class], sel);
	if (m) {
		IMP imp = method_getImplementation(m);
		id (*func)(id, SEL) = (id (*)(id, SEL))imp;
		func(recev, sel);
	}
	
}

#pragma mark - Pop
- (void)fromVC:(id)f_vc popOneStepWithArgs:(id)args {
	
	[[(MXSViewController*)f_vc navigationController] popViewControllerAnimated:YES];
	MXSViewController* recev = ((MXSViewController*)f_vc).navigationController.viewControllers.lastObject;
	
	if (args) {
		[self vc:recev performSelector:MethodReceiveArgsTypeBack args:args];
	}
}
- (void)fromVC:(id)f_vc popToDestVC:(id)d_vc withArgs:(id)args {
	d_vc = [self getClassFromClassName:d_vc];
	
	MXSViewController* des = nil;
	for (MXSViewController *iter in ((MXSViewController*)f_vc).navigationController.viewControllers) {
		if ([iter isKindOfClass:[d_vc class]]) {
			des = iter;
			break;
		}
	}
	[[(MXSViewController*)f_vc navigationController] popToViewController:des animated:YES];
	if (args) {
		[self vc:des performSelector:MethodReceiveArgsTypeBack args:args];
	}
}
- (void)fromVC:(id)f_vc popToRootWithArgs:(id)args {
	
	[[(MXSViewController*)f_vc navigationController] popToRootViewControllerAnimated:YES];
	MXSViewController* recev = ((MXSViewController*)f_vc).navigationController.viewControllers.firstObject;
	if (args) {
		[self vc:recev performSelector:MethodReceiveArgsTypeBack args:args];
	}
}

#pragma mark - Module
- (void)fromVC:(id)f_vc moduleVC:(id)t_vc withArgs:(id)args {
	t_vc = [self getClassFromClassName:t_vc];
	if (args) {
		[self vc:t_vc performSelector:MethodReceiveArgsTypePost args:args];
	}
	
	[(MXSViewController*)f_vc presentViewController:t_vc animated:YES completion:^{
		
	}];
}
- (void)fromVC:(id)f_vc dismissWithArgs:(id)args {
	[(MXSViewController*)f_vc dismissViewControllerAnimated:YES completion:^{
		if (args) {
			MXSViewController* act_vc = (MXSViewController*)[Tools activityViewController];
			[self vc:act_vc performSelector:MethodReceiveArgsTypeBack args:args];
		}
	}];
}

@end
