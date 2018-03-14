//
//  AYValidatingView.m
//  BabySharing
//
//  Created by Alfred Yang on 13/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYValidatingView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYAlertView.h"

@implementation AYValidatingView {
	
	UIView *leftView;
	UIView *rightView;
	
	UIView *leftLine;
	UIView *rightLine;
	
	UIView *centerView;
	UIImageView *loadingView;
	UILabel *tipLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	
	self.frame = [UIScreen mainScreen].bounds;
	self.backgroundColor = [UIColor clearColor];
	self.userInteractionEnabled = NO;
	
	CGFloat marginOffset = SCREEN_WIDTH * 0.5;
	leftView = [[UIView alloc] initWithFrame:CGRectMake(-marginOffset, 0, marginOffset, SCREEN_HEIGHT)];
	[self addSubview:leftView];
	leftLine = [[UIView alloc] initWithFrame:CGRectMake(marginOffset, 0, 0.5, SCREEN_HEIGHT)];
	[leftView addSubview:leftLine];
	
	rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, marginOffset, SCREEN_HEIGHT)];
	[self addSubview:rightView];
	rightLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, SCREEN_HEIGHT)];
	[rightView addSubview:rightLine];
	
//	leftView.userInteractionEnabled = rightView.userInteractionEnabled = YES;
	leftView.backgroundColor = rightView.backgroundColor = [Tools whiteColor];
	leftLine.backgroundColor = rightLine.backgroundColor = [Tools garyLineColor];
	
	centerView = [[UIView alloc] init];
	[self addSubview:centerView];
	[centerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 80));
	}];
	
	loadingView = [[UIImageView alloc] init];
	loadingView.image = IMGRESOURCE(@"loading_0");
	NSMutableArray *ary = [NSMutableArray new];
	for(int i = 0; i < 4; ++i){
		//通过for 循环,把我所有的 图片存到数组里面
		NSString *imageName = [NSString stringWithFormat:@"loading_%d", i];
		UIImage *image = [UIImage imageNamed:imageName];
		[ary addObject:image];
	}
	
	loadingView.animationImages = ary;
	loadingView.animationRepeatCount = 0;
	loadingView.animationDuration = 3.0;
	
	[centerView addSubview:loadingView];
	[loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(centerView);
		make.centerY.equalTo(centerView.mas_top).offset(15);
		make.size.mas_equalTo(CGSizeMake(34, 6));
	}];
	centerView.alpha = 0;
	
	tipLabel = [Tools creatLabelWithText:@"Validating..." textColor:[Tools theme] fontSize:617 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[centerView addSubview:tipLabel];
	[tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(centerView);
		make.centerX.equalTo(centerView);
	}];
	
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCatigoryView;
}

#pragma mark -- commands
- (id)hideValidatingView {
	
	[loadingView stopAnimating];
	leftLine.hidden = rightLine.hidden = NO;
	self.userInteractionEnabled = NO;
	
	leftView.frame = CGRectMake(-SCREEN_WIDTH * 0.5, 0, SCREEN_WIDTH * 0.5, SCREEN_HEIGHT);
	rightView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH * 0.5, SCREEN_HEIGHT);
	centerView.alpha = 0.f;
	
	return nil;
}
- (id)showValidatingView {
	
	[loadingView startAnimating];
	leftLine.hidden = rightLine.hidden = YES;
	self.userInteractionEnabled = YES;
	
	leftView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, SCREEN_HEIGHT);
	rightView.frame = CGRectMake(SCREEN_WIDTH*0.5, 0, SCREEN_WIDTH * 0.5, SCREEN_HEIGHT);
	centerView.alpha = 1.f;
	
	return nil;
}

- (id)setTipContext:(id)args {
	tipLabel.text = args;
	return nil;
}

- (id)changeStatusWithSuccessTip:(id)args {
	
	[loadingView stopAnimating];
	[loadingView mas_updateConstraints:^(MASConstraintMaker *make) {
		make.size.mas_equalTo(CGSizeMake(30, 30));
	}];
	loadingView.image = IMGRESOURCE(@"checked_icon");
	tipLabel.text = args;
	return nil;
}

- (id)showValidatingViewWithAnimate {
	
	[loadingView startAnimating];
	self.userInteractionEnabled = YES;
	
	[UIView animateWithDuration:0.5 animations:^{
		leftView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.5, SCREEN_HEIGHT);
		rightView.frame = CGRectMake(SCREEN_WIDTH*0.5, 0, SCREEN_WIDTH * 0.5, SCREEN_HEIGHT);
		centerView.alpha = 1.f;
	} completion:^(BOOL finished) {
		leftLine.hidden = rightLine.hidden = YES;
	}];
	return nil;
}

- (id)hideValidatingViewWithAnimate {
	
	[loadingView stopAnimating];
	leftLine.hidden = rightLine.hidden = NO;
	self.userInteractionEnabled = NO;
	
	[UIView animateWithDuration:0.5 animations:^{
		leftView.frame = CGRectMake(-SCREEN_WIDTH * 0.5, 0, SCREEN_WIDTH * 0.5, SCREEN_HEIGHT);
		rightView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH * 0.5, SCREEN_HEIGHT);
		centerView.alpha = 0.f;
	}];
	return nil;
}


@end

