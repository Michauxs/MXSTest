//
//  AYCourseSignView.m
//  BabySharing
//
//  Created by Alfred Yang on 14/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYCourseSignView.h"

@implementation AYCourseSignView {
	UILabel *titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title {
	self = [super initWithFrame:frame];
	if (self) {
		[Tools setViewBorder:self withRadius:4.f andBorderWidth:1 andBorderColor:[Tools garyLineColor] andBackground:[Tools whiteColor]];
		
		titleLabel = [Tools creatLabelWithText:title textColor:[Tools garyColor] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self);
		}];
		if(SCREEN_WIDTH < 375) {
			titleLabel.font = [UIFont systemFontOfSize:13];
		}
		
		self.sign = title;
		
	}
	return self;
}

- (void)setSelectStatus {
	[Tools setViewBorder:self withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools theme]];
	titleLabel.textColor = [Tools whiteColor];
}

- (void)setUnselectStatus {
	[Tools setViewBorder:self withRadius:4.f andBorderWidth:1 andBorderColor:[Tools garyLineColor] andBackground:[Tools whiteColor]];
	titleLabel.textColor = [Tools garyColor];
}

@end
