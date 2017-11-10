//
//  MXSHomeVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSHomeVC.h"

#define TABLE_WIDTH				120

@implementation MXSHomeVC {
	MXSTableView *actTableView;
	NSArray *titleArr;
	
	MXSTableView *showTableView;
	MXSDelegateBase *showDlg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
//	UIView *BG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//	BG.layer.
	//	[self.view addSubview:BG];
	self.view.layer.contents = (id)IMGRESOURE(@"circute").CGImage;
	
	titleArr = @[@"NOTIFY", @"APPEND", @"ENUM", @"REMOVE", @"SEARCH"];
	
	actTableView = [[MXSTableView alloc] initWithFrame:CGRectMake(0, 0, TABLE_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain andDelegate:nil];
	[self.view addSubview:actTableView];
	[actTableView registerClsaaWithCellName:@"MXSHomeCell" RowHeight:64 andController:self];
	actTableView.dlg.dlgData = titleArr;
	actTableView.backgroundColor = [UIColor clearColor];
	
}

#pragma mark - actions
- (void)APPENDClick {
	NSDictionary *data = @{kMXSHistoryModelArgsSender:@"zhagsan",
						   kMXSHistoryModelArgsReceiver:@"lisi",
						   kMXSHistoryModelArgsMessageText:@"hello,world",
						   kMXSHistoryModelArgsIsRead:[NSNumber numberWithBool:NO],
						   kMXSHistoryModelArgsDateSend:[NSNumber numberWithDouble:[NSDate date].timeIntervalSince1970]
						   };
	MXSHistoryModel *his = [MXSHistoryModel shared];
	[History appendDataInContext:his.doc.managedObjectContext withData:data];
}

- (void)ENUMClick {
	MXSHistoryModel *his = [MXSHistoryModel shared];
	NSArray *arr = [History enumAllDataInContext:his.doc.managedObjectContext];
	NSLog(@"data : %@", arr);
}

- (void)REMOVEClick {
	MXSHistoryModel *his = [MXSHistoryModel shared];
	[History removeAllDataInContext:his.doc.managedObjectContext];
}

- (void)SEARCHClick {
	MXSHistoryModel *his = [MXSHistoryModel shared];
	[History removeAllDataInContext:his.doc.managedObjectContext];
}

- (void)NOTIFYClick {
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

	IMP imp = method_getImplementation(m);
	id (*func)(id, SEL) = (id (*)(id, SEL))imp;
	func(self, sel);
}

#pragma mark - dlg notify
- (id)tableViewDidSelectRowAtIndexPath:(id)args {
	NSNumber *row = [args objectForKey:@"row"];
	NSLog(@"%ld", row.integerValue);
	[self didSelectedFunc:[[titleArr objectAtIndex:row.intValue] stringByAppendingString:@"Click"]];
	return nil;
}

- (id)cellDeleteFromTable:(id)args {
	
	return nil;
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
