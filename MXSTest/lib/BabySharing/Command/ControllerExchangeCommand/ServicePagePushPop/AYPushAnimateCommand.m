//
//  AYPushAnimateCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 11/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYPushAnimateCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"

@implementation AYPushAnimateCommand

@synthesize para = _para;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	NSLog(@"push animate command perfrom");
	
//	NSDictionary* dic = (NSDictionary*)*obj;
//
//	AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
//	AYViewController* des = [dic objectForKey:kAYControllerActionDestinationControllerKey];
//	UIView *imgForFrame = [dic objectForKey:kAYControllerImgForFrameKey];
//
//	id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
//	if (tmp != nil) {
//		NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
//		[dic_init setValue:kAYControllerActionInitValue forKey:kAYControllerActionKey];
//		[dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
//		[des performWithResult:&dic_init];
//	}
//
//	des.hidesBottomBarWhenPushed = YES;
//	[source.navigationController pushViewController:des animated:NO];
//
////	UIView *snapShotView = [source.navigationController.view snapshotViewAfterScreenUpdates:NO];
////	UIView *snapShotView = [source.navigationController.view resizableSnapshotViewFromRect:CGRectMake(0, 0, SCREEN_WIDTH, 300) afterScreenUpdates:NO withCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//	CGRect firstFrame  = [source.view convertRect:imgForFrame.frame fromView:[imgForFrame superview]];
//
//	CGRect topFrame = CGRectMake(0, 0, SCREEN_WIDTH, firstFrame.origin.y);
//	CGRect midFrame = CGRectMake(0, firstFrame.origin.y, SCREEN_WIDTH, firstFrame.size.height);
//	CGRect btmFrame = CGRectMake(0, CGRectGetMaxY(firstFrame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(firstFrame));
//
//	UIView *shot_view_top = [source.navigationController.view resizableSnapshotViewFromRect:topFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//	UIView *shot_view_mid = [source.navigationController.view resizableSnapshotViewFromRect:midFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//	UIView *shot_view_btm = [source.navigationController.view resizableSnapshotViewFromRect:btmFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//
//	shot_view_top.frame = topFrame;
//	shot_view_mid.frame = midFrame;
//	shot_view_btm.frame = btmFrame;
//	des.shotTopView = shot_view_top;
//	des.shotMidView = shot_view_mid;
//	des.shotBtmView = shot_view_btm;
//	[des.view addSubview:shot_view_top];
//	[des.view addSubview:shot_view_mid];
//	[des.view addSubview:shot_view_btm];
//
//	CGFloat scala_w = SCREEN_WIDTH/firstFrame.size.width;
//
//	CGRect retFrame_top = CGRectMake(0, -CGRectGetHeight(topFrame), SCREEN_WIDTH, CGRectGetHeight(topFrame));
//	CGRect retFrame_mid = CGRectMake(- firstFrame.origin.x * scala_w, 0, SCREEN_WIDTH*scala_w, 300);
//	CGRect retFrame_btm = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CGRectGetHeight(btmFrame));
//
//	[UIView animateWithDuration:5 animations:^{
//		shot_view_top.frame = retFrame_top;
//		shot_view_mid.frame = retFrame_mid;
//		shot_view_btm.frame = retFrame_btm;
//
//	} completion:^(BOOL finished) {
//		shot_view_top.alpha = shot_view_mid.alpha = shot_view_btm.alpha = 0;
//	}];
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}


- (UIImage *)imageFromView: (UIView *) theView {
	
	UIGraphicsBeginImageContext(theView.frame.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[theView.layer renderInContext:context];
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return theImage;
}
@end
