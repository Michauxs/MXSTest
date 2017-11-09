//
//  MXSHomeVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSHomeVC.h"

@implementation MXSHomeVC {
	
	NSArray *titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIButton *demoBtn = [Tools creatUIButtonWithTitle:@"DEMO" andTitleColor:[Tools whiteColor] andFontSize:316 andBackgroundColor:[Tools blackColor]];
	[self.view addSubview:demoBtn];
	demoBtn.frame = CGRectMake(30, 80, 200, 50);
	[demoBtn addTarget:self action:@selector(demoBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *appendBtn = [Tools creatUIButtonWithTitle:@"APPEND" andTitleColor:[Tools whiteColor] andFontSize:316 andBackgroundColor:[Tools blackColor]];
	[self.view addSubview:appendBtn];
	appendBtn.frame = CGRectMake(30, 180, 200, 50);
	[appendBtn addTarget:self action:@selector(appendBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *enumBtn = [Tools creatUIButtonWithTitle:@"ENUM" andTitleColor:[Tools whiteColor] andFontSize:316 andBackgroundColor:[Tools blackColor]];
	[self.view addSubview:enumBtn];
	enumBtn.frame = CGRectMake(30, 280, 200, 50);
	[enumBtn addTarget:self action:@selector(enumBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *removeBtn = [Tools creatUIButtonWithTitle:@"REMOVE" andTitleColor:[Tools whiteColor] andFontSize:316 andBackgroundColor:[Tools blackColor]];
	[self.view addSubview:removeBtn];
	removeBtn.frame = CGRectMake(30, 380, 200, 50);
	[removeBtn addTarget:self action:@selector(removeBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

#pragma mark - actions
- (void)appendBtnClick {
	NSDictionary *data = @{kMXSHistoryModelArgsSender:@"zhagsan",
						   kMXSHistoryModelArgsReceiver:@"lisi",
						   kMXSHistoryModelArgsMessageText:@"hello,world",
						   kMXSHistoryModelArgsIsRead:[NSNumber numberWithBool:NO],
						   kMXSHistoryModelArgsDateSend:[NSNumber numberWithDouble:[NSDate date].timeIntervalSince1970]
						   };
	MXSHistoryModel *his = [MXSHistoryModel shared];
	[History appendDataInContext:his.doc.managedObjectContext withData:data];
}

- (void)enumBtnClick {
	MXSHistoryModel *his = [MXSHistoryModel shared];
	NSArray *arr = [History enumAllDataInContext:his.doc.managedObjectContext];
	NSLog(@"data : %@", arr);
}

- (void)removeBtnClick {
	MXSHistoryModel *his = [MXSHistoryModel shared];
	[History removeAllDataInContext:his.doc.managedObjectContext];
}

- (void)demoBtnClick {
	UILocalNotification *l_n = [[UILocalNotification alloc] init];
	l_n.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
	l_n.soundName = UILocalNotificationDefaultSoundName;
	l_n.alertBody = @"User Local Notification";
	l_n.alertTitle = @"The Notify";
	l_n.alertAction = @"Action";
	l_n.userInfo = @{@"key":@"mxs_notify_demo"};
	[[UIApplication sharedApplication] scheduleLocalNotification:l_n];
}

- (void)cancelTheOneNotify {
	//取消某一个通知
	NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
	//获取当前所有的本地通知
	if (!notificaitons || notificaitons.count <= 0) {
		return;
		}
	for (UILocalNotification *notify in notificaitons) {
		if ([[notify.userInfo objectForKey:@"key"] isEqualToString:@"mxs_notify_demo"]) {
			//取消一个特定的通知
			[[UIApplication sharedApplication] cancelLocalNotification:notify];
			break;
		}
	}
	
}

- (void)cancelAllLocalNotifies {
	
	//取消所有的本地通知
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)didSelectedFunc:(NSString*)funcName {
	
	SEL sel = NSSelectorFromString(funcName);
	Method m = class_getInstanceMethod([self class], sel);
	if (m) {
		IMP imp = method_getImplementation(m);
		id (*func)(id, SEL, ...) = (id (*)(id, SEL, ...))imp;
		func(self, sel);
	}
	
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//	
//	[self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//	
//	UITouch *touch = [[touches allObjects] firstObject];
//	CGPoint centerP = [touch locationInView:[touch view]];
//	
//	NSString *title = @"You have a new message 002";
//	UILabel *tipsLabel = [Tools creatUILabelWithText:title andTextColor:[Tools themeColor] andFontSize:18.f andBackgroundColor:nil andTextAlignment:1];
//	[self.view addSubview:tipsLabel];
//	tipsLabel.bounds = CGRectMake(0, 0, 300, 30);
//	tipsLabel.center = centerP;
//	
//	MXSViewController *actVC = [self.tabBarController.viewControllers objectAtIndex:1];
//	actVC.tabBarItem.badgeValue = @"2";
//}

@end
