//
//  AYPopAnimateCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 11/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved. 
//

#import "AYPopAnimateCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"

@implementation AYPopAnimateCommand

@synthesize para = _para;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	NSLog(@"pop command perfrom");
	
//	NSDictionary* dic = (NSDictionary*)*obj;
//
//	AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
//	
//	UINavigationController * nav = source.navigationController;
//	
//	AYViewController* des = [nav.viewControllers objectAtIndex:nav.viewControllers.count-2];
//	
//	id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
//	if (tmp != nil) {
//		NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
//		[dic_init setValue:kAYControllerActionPopBackValue forKey:kAYControllerActionKey];
//		[dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
//		[des performWithResult:&dic_init];
//	}
//	
//	if (source.shotTopView) {
//		
//		[UIView animateWithDuration:5 animations:^{
//			
//			source.shotTopView.frame = CGRectMake(0, 0, SCREEN_WIDTH, source.shotTopView.bounds.size.height);
//			source.shotMidView.frame = CGRectMake(0, source.shotTopView.bounds.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetHeight(source.shotTopView.frame)-CGRectGetHeight(source.shotBtmView.frame));
//			source.shotBtmView.frame = CGRectMake(0, SCREEN_HEIGHT-source.shotBtmView.bounds.size.height, SCREEN_WIDTH, source.shotBtmView.bounds.size.height);
//			
////			source.shotTopView.alpha = source.shotMidView.alpha = source.shotBtmView.alpha = 1;
//		} completion:^(BOOL finished) {
//			[source.shotTopView removeFromSuperview];
//			[source.shotMidView removeFromSuperview];
//			[source.shotBtmView removeFromSuperview];
//			
//			source.shotTopView = source.shotMidView = source.shotBtmView = nil;
//			
//			[nav popViewControllerAnimated:NO];
//		}];
//	} else {
//		[nav popViewControllerAnimated:YES];
//	}
	
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

@end
