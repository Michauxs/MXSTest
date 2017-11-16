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
	
	UIScrollView *showView;
	UILabel *graduallyLabel;
	UIView *btmLine;
	
	NSTimer *timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.layer.contents = (id)IMGRESOURE(@"circute").CGImage;
	
	titleArr = @[@"NOTIFY", @"APPEND", @"ENUM", @"REMOVE", @"SEARCH", @"NEXT", @"NOTEBOOK"];
	
	actTableView = [[MXSTableView alloc] initWithFrame:CGRectMake(0, 0, TABLE_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain andDelegate:nil];
	[self.view addSubview:actTableView];
	[actTableView registerClsaaWithCellName:@"MXSHomeCell" RowHeight:64 andController:self];
	actTableView.dlg.dlgData = titleArr;
	actTableView.backgroundColor = [UIColor clearColor];
	[actTableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view);
		make.top.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(TABLE_WIDTH, SCREEN_HEIGHT));
	}];
	
	graduallyLabel = [Tools creatUILabelWithText:@"" andTextColor:[Tools themeColor] andFontSize:315 andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[self.view addSubview:graduallyLabel];
//	graduallyLabel.frame = CGRectMake(TABLE_WIDTH+30, 0, SCREEN_WIDTH-(TABLE_WIDTH+30), SCREEN_HEIGHT);
	[graduallyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(50);
		make.left.equalTo(actTableView.mas_right).offset(30);
	}];
	btmLine = [[UIView alloc] init];
	btmLine.backgroundColor = [Tools themeColor];
	[self.view addSubview:btmLine];
	[btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(graduallyLabel.mas_bottom).offset(10);
		make.left.equalTo(graduallyLabel);
		make.right.equalTo(self.view);
		make.height.mas_equalTo(0.5);
	}];
	btmLine.hidden = YES;
}

#pragma mark - actions
- (id)NOTEBOOKClick {
	[[MXSVCExchangeCmd shared] fromVC:self pushVC:@"MXSNoteVC" withArgs:nil];
	return nil;
}
- (id)NEXTClick {
	
	return nil;
}

- (id)APPENDClick {
	NSDictionary *data = @{kMXSHistoryModelArgsSender:@"zhagsan",
						   kMXSHistoryModelArgsReceiver:@"lisi",
						   kMXSHistoryModelArgsMessageText:@"hello,world",
						   kMXSHistoryModelArgsIsRead:[NSNumber numberWithBool:NO],
						   kMXSHistoryModelArgsDateSend:[NSNumber numberWithDouble:[NSDate date].timeIntervalSince1970]
						   };
	
	[[MXSModelCmd shared] appendData:@"" withData:data];
	return nil;
}

- (id)ENUMClick {
	NSArray *arr = [[MXSModelCmd shared] enumAllData:@""];
	NSLog(@"data : %@", arr);
	if (arr.count == 0) {
		return nil;
	}
	NSDictionary *info_m = [arr firstObject];
	NSString *m = [NSString stringWithFormat:@"发送者：%@\n接受者：%@\n消息内容：%@",[info_m objectForKey:kMXSHistoryModelArgsSender],[info_m objectForKey:kMXSHistoryModelArgsReceiver],[info_m objectForKey:kMXSHistoryModelArgsMessageText]];
	graduallyLabel.text = @"";
	btmLine.hidden = NO;
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerRun:) userInfo:m repeats:YES];
	[timer fire];
	
	return nil;
}

- (void)timerRun:(NSTimer*)time {
	NSString *msg = [time userInfo];
	if (graduallyLabel.text.length == msg.length) {
		[timer invalidate];
		return;
	}
	graduallyLabel.text = [msg substringToIndex:graduallyLabel.text.length + 1];
}

- (id)REMOVEClick {
	[[MXSModelCmd shared] removeAllData:@""];
	return nil;
}

- (id)SEARCHClick {
	[[MXSModelCmd shared] searchData:@"" withKV:@{}];
	return nil;
}

- (id)NOTIFYClick {
	UILocalNotification *l_n = [[UILocalNotification alloc] init];
	l_n.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
	l_n.soundName = UILocalNotificationDefaultSoundName;
	l_n.alertBody = @"User Local Notification";
	l_n.alertTitle = @"The Notify";
	l_n.alertAction = @"Action";
	l_n.userInfo = @{@"key":@"mxs_notify_demo"};
	[[UIApplication sharedApplication] scheduleLocalNotification:l_n];
	return nil;
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
	id (*func)(id, SEL, ...) = (id (*)(id, SEL, ...))imp;
	func(self, sel, nil);
}

#pragma mark - dlg notify
- (id)tableViewDidSelectRowAtIndexPath:(id)args {
	NSNumber *row = [args objectForKey:@"row"];
	
	[self didSelectedFunc:[[titleArr objectAtIndex:row.intValue] stringByAppendingString:@"Click"]];
	return nil;
}

- (id)cellDeleteFromTable:(id)args {
	
	return nil;
}

@end
