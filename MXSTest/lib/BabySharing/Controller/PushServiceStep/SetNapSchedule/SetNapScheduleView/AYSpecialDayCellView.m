//
//  AYSpecialDayCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSpecialDayCellView.h"

@implementation AYSpecialDayCellView {
	UILabel *titleLabel;
	UIView *radiuSignView;
	UIView *dotSignView;
}

- (instancetype)init {
	if (self = [super init]) {
		[self initLayout];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initLayout];
	}
	return self;
}

- (void)initLayout {
	self.backgroundColor = [UIColor whiteColor];
	
	radiuSignView = [[UIView alloc] init];
	[Tools setViewBorder:radiuSignView withRadius:16 andBorderWidth:1 andBorderColor:[Tools theme] andBackground:[Tools whiteColor]];
	[self addSubview:radiuSignView];
	[radiuSignView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(self).insets(UIEdgeInsetsMake(8, 8, 8, 8));
		make.center.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(32, 32));
	}];
	
	titleLabel = [Tools creatLabelWithText:@"0" textColor:[Tools black] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self);
	}];
	
	dotSignView = [[UIView alloc] init];
	[Tools setViewBorder:dotSignView withRadius:2 andBorderWidth:0 andBorderColor:nil andBackground:[Tools theme]];
	[self addSubview:dotSignView];
	[dotSignView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.top.equalTo(titleLabel.mas_bottom).offset(1);
		make.size.mas_equalTo(CGSizeMake(4, 4));
	}];
	
//	UIView *BgView = [[UIView alloc] init];
//	self.backgroundView = BgView;
	
	radiuSignView.hidden = dotSignView.hidden = YES;
}

- (void)isToday {
	titleLabel.text = @"今";
}

- (void)setDay:(NSInteger)day {
	titleLabel.text = [NSString stringWithFormat:@"%d", (int)day];
}

- (void)setState:(AYTMDayState)state {
	_state = state;
	switch (state) {
		case AYTMDayStateGone:
		{
			titleLabel.textColor = [Tools garyColor];
			radiuSignView.hidden = dotSignView.hidden = YES;
		}
			break;
		case AYTMDayStateNormal:
		{
			titleLabel.textColor = [Tools black];
			radiuSignView.hidden = dotSignView.hidden = YES;
		}
			break;
		case AYTMDayStateNoServ:
		{
			titleLabel.textColor = [Tools black];
			radiuSignView.hidden = dotSignView.hidden = YES;
		}
			break;
		case AYTMDayStateInServ:
		{
			titleLabel.textColor = [Tools theme];
			radiuSignView.hidden = dotSignView.hidden = YES;
		}
			break;
		case AYTMDayStateSpecial:
		{
			titleLabel.textColor = [Tools theme];
			radiuSignView.hidden = YES;
			dotSignView.hidden = NO;
		}
			break;
		case AYTMDayStateOpenDay:
		{
			titleLabel.textColor = [Tools theme];
			radiuSignView.hidden = NO;
			dotSignView.hidden = YES;
			[Tools setViewBorder:radiuSignView withRadius:16 andBorderWidth:1 andBorderColor:[Tools theme] andBackground:[Tools whiteColor]];
		}
			break;
		case AYTMDayStateSelect:
		{
			titleLabel.textColor = [Tools whiteColor];
			radiuSignView.hidden = NO;
			dotSignView.hidden = YES;
			[Tools setViewBorder:radiuSignView withRadius:16 andBorderWidth:0 andBorderColor:nil andBackground:[Tools theme]];
		}
			break;
			
		default:
			break;
	}
}

@end
