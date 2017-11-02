//
//  MXSAnimetionVC.m
//  MXSTest
//
//  Created by Alfred Yang on 2/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSAnimetionVC.h"

@interface MXSAnimetionVC ()

@end

@implementation MXSAnimetionVC {
	
	UIView *animtDisplay;
	CAShapeLayer *animtLayer;
	
}

- (void)receiveActionArgs:(id)args {
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	animtDisplay = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_WIDTH)];
	[self.view addSubview:animtDisplay];
	
	UIBezierPath *path = [[UIBezierPath alloc] init];
	[path moveToPoint:CGPointMake(SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
	[path addLineToPoint:CGPointMake(SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.8)];
	
	animtLayer = [CAShapeLayer layer];
	animtLayer.path = path.CGPath;
	animtLayer.fillColor = [UIColor clearColor].CGColor;
	animtLayer.strokeColor = [Tools themeColor].CGColor;
	animtLayer.lineWidth = 2.f;
	animtLayer.lineCap = kCALineCapRound;
	animtLayer.lineJoin = kCALineJoinRound;
	[animtDisplay.layer addSublayer:animtLayer];
	
	UIButton *ComeOnBtn = [Tools creatUIButtonWithTitle:@"ATK" andTitleColor:[Tools whiteColor] andFontSize:14.f andBackgroundColor:[Tools themeColor]];
	[self.view addSubview:ComeOnBtn];
	[ComeOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view).offset(-49);
		make.right.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.5, 40));
	}];
	[ComeOnBtn addTarget:self action:@selector(didComeOnBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *otherBtn = [Tools creatUIButtonWithTitle:@"BAC" andTitleColor:[Tools whiteColor] andFontSize:14.f andBackgroundColor:[Tools darkBackgroundColor]];
	[self.view addSubview:otherBtn];
	[otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view).offset(-49);
		make.left.equalTo(self.view);
		make.size.equalTo(ComeOnBtn);
	}];
	[otherBtn addTarget:self action:@selector(didOtherBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

#pragma mark - actions

- (void)didComeOnBtnClick {
	
}
- (void)didOtherBtnBtnClick {
	[[MXSVCExchangeCmd shared] fromVC:self popToRootWithArgs:@1];
}


@end
