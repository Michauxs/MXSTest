//
//  AYAddTimeSignView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAddTimeSignView.h"

@implementation AYAddTimeSignView {
	UILabel *titleLabel;
	UIImageView *addSignView;
	
	UIView *BGView;
	UIView *coverBtmRadiusView;
}

- (instancetype)initWithTitle:(NSString *)title {
	if (self = [super init]) {
		
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		
		BGView = [[UIView alloc] init];
		[self addSubview:BGView];
		[BGView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
		BGView.backgroundColor = [Tools themeLightColor];
		
		[Tools setViewBorder:BGView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools themeLightColor]];
		
		titleLabel = [Tools creatLabelWithText:title textColor:[Tools whiteColor] fontSize:615 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.centerY.equalTo(self);
		}];
		
		addSignView = [[UIImageView alloc] init];
		addSignView.image = [UIImage imageNamed:@"icon_addtime_white"];
		[self addSubview:addSignView];
		[addSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-20);
			make.centerY.equalTo(titleLabel);
			make.size.mas_equalTo(CGSizeMake(16, 16));
		}];
		
		coverBtmRadiusView = [[UIView alloc] init];
		coverBtmRadiusView.backgroundColor = [Tools whiteColor];
		[self addSubview:coverBtmRadiusView];
		[coverBtmRadiusView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self);
			make.left.equalTo(self);
			make.right.equalTo(self);
			make.height.equalTo(@4);
		}];
		coverBtmRadiusView.hidden = YES;
	}
	return self;
}

- (void)setState:(AYAddTMSignState)state {
	_state = state;
	switch (state) {
		case AYAddTMSignStateHead:
			{
				BGView.backgroundColor = [Tools whiteColor];
				titleLabel.textColor = [Tools black];
				addSignView.image = [UIImage imageNamed:@"add_icon_circle"];
				coverBtmRadiusView.hidden = NO;
				self.userInteractionEnabled = YES;
			}
			break;
			case AYAddTMSignStateUnable:
		{
			BGView.backgroundColor = [Tools themeLightColor];
			titleLabel.textColor = [Tools whiteColor];
			addSignView.image = [UIImage imageNamed:@"add_icon_circle_white"];
			coverBtmRadiusView.hidden = YES;
			self.userInteractionEnabled = NO;
		}
			break;
			case AYAddTMSignStateEnable:
		{
			BGView.backgroundColor = [Tools theme];
			titleLabel.textColor = [Tools whiteColor];
			addSignView.image = [UIImage imageNamed:@"add_icon_circle_white"];
			coverBtmRadiusView.hidden = YES;
			self.userInteractionEnabled = YES;
		}
			break;
			
		default:
			break;
	}
}


@end
