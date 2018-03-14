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
		
		[self setRadius:4 borderWidth:1 borderColor:[UIColor gary] background:[UIColor white]];
		titleLabel = [UILabel creatLabelWithText:title textColor:[UIColor gary] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
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
	[self setRadius:4 borderWidth:0 borderColor:nil background:[UIColor theme]];
	titleLabel.textColor = [Tools whiteColor];
}

- (void)setUnselectStatus {
	[self setRadius:4 borderWidth:1 borderColor:[UIColor gary] background:[UIColor white]];
	titleLabel.textColor = [Tools garyColor];
}

@end
