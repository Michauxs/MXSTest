//
//  MXSNoteVC.m
//  MXSTest
//
//  Created by Alfred Yang on 13/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSNoteVC.h"

@interface MXSNoteVC ()

@end

@implementation MXSNoteVC {
	NSTimer *timer;
	UILabel *graduallyLabel;
	NSString *graStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	graduallyLabel = [Tools creatLabelWithText:@"" textColor:[Tools theme] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:graduallyLabel];
	//	graduallyLabel.frame = CGRectMake(TABLE_WIDTH+30, 0, SCREEN_WIDTH-(TABLE_WIDTH+30), SCREEN_HEIGHT);
	[graduallyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(50);
		make.left.equalTo(self.view).offset(30);
	}];
	
	graStr = @"缆绳绷紧了，\n他被慢慢地吊离了甲板。";
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
	[timer fire];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	if (timer) {
		[timer invalidate];
		timer = nil;
	}
}

#pragma mark - actions
- (void)timerRun {
	if (graduallyLabel.text.length == graStr.length) {
		[timer invalidate];
		timer = nil;
		return;
	}
	graduallyLabel.text = [graStr substringToIndex:graduallyLabel.text.length + 1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

	[[MXSVCExchangeCmd shared] fromVC:self popOneStepWithArgs:nil];
}

@end
