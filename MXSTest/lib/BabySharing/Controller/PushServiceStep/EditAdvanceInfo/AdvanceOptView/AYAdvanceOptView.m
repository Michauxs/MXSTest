//
//  AYAdvanceOptView.m
//  BabySharing
//
//  Created by Alfred Yang on 24/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAdvanceOptView.h"

@implementation AYAdvanceOptView

- (instancetype)initWithTitle:(UILabel *)titleLabel {
	self = [super init];
	if (self) {
		
//		UILabel *titleLabel = [Tools creatUILabelWithText:title andTextColor:[Tools blackColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(5);
			make.centerY.equalTo(self);
			make.width.mas_equalTo(95);
		}];
		
		_subTitleLabel =  [Tools creatLabelWithText:@"" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentRight];
		[self addSubview:_subTitleLabel];
		[_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-30);
			make.centerY.equalTo(self);
			make.left.equalTo(titleLabel.mas_right);
		}];
		
		_access = [[UIImageView alloc]init];
		[self addSubview:_access];
		_access.image = IMGRESOURCE(@"plan_time_icon");
		[_access mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-10);
			make.centerY.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(23, 23));
		}];
		
		UIView *bottomLine = [[UIView alloc] init];
		bottomLine.backgroundColor = [Tools garyLineColor];
		[self addSubview:bottomLine];
		[bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self);
			make.centerX.equalTo(self);
			make.width.equalTo(self);
			make.height.mas_equalTo(0.5);
		}];
		
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
