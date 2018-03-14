//
//  AYServiceCategOptView.m
//  BabySharing
//
//  Created by Alfred Yang on 14/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYServiceCategOptView.h"

@implementation AYServiceCategOptView {
	UILabel *titleLabel;
	UILabel *subTitleLabel;
}

- (instancetype)initWithTitle:(NSString*)titleStr {
	if (self = [super init]) {
		
		[Tools setViewBorder:self withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools theme]];
		
		titleLabel = [Tools creatLabelWithText:titleStr textColor:[Tools whiteColor] fontSize:617 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self).offset(20);
		}];
		
		UIImageView *accessView = [[UIImageView alloc] init];
		accessView.image = [UIImage imageNamed:@"icon_arrow_r_white"];
//		accessView.transform = CGAffineTransformMakeRotation(M_PI);
		[self addSubview:accessView];
		[accessView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(self).offset(-13);
			make.size.mas_equalTo(CGSizeMake(8, 14));
		}];
		
		subTitleLabel = [Tools creatLabelWithText:@"Sub" textColor:[Tools whiteColor] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentRight];
		[self addSubview:subTitleLabel];
		[subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(accessView.mas_left).offset(-5);
		}];
		subTitleLabel.hidden = YES;
		
	}
	return self;
}

- (void)setSubArgs:(NSString *)subArgs {
	if (subArgs) {
		subTitleLabel.hidden = NO;
		subTitleLabel.text = subArgs;
	} else {
		subTitleLabel.text = @"Sub";
		subTitleLabel.hidden = YES;
	}
}

@end
