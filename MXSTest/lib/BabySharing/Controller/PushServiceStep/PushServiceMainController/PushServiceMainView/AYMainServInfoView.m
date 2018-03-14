//
//  AYMainServInfoView.m
//  BabySharing
//
//  Created by Alfred Yang on 15/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYMainServInfoView.h"
#import "AYCommandDefines.h"

@implementation AYMainServInfoView {
	UILabel *titleLabel;
	UIButton *statusBtn;
	
	UIView *radiusBGView;
}

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTapBlock:(didViewTap)block{
	self = [super initWithFrame:frame];
	if (self) {
		
		_tapBlocak = block;
		
		self.layer.cornerRadius = 4.f;
		self.layer.shadowColor = [Tools garyColor].CGColor;
		self.layer.shadowRadius = 4.f;
		self.layer.shadowOpacity = 0.5f;
		self.layer.shadowOffset = CGSizeMake(0, 0);
		self.backgroundColor = [Tools whiteColor];
		
		radiusBGView = [[UIView alloc] initWithFrame:self.bounds];
		[self addSubview:radiusBGView];
		[Tools setViewBorder:radiusBGView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
		
		titleLabel = [Tools creatLabelWithText:title textColor:[Tools theme] fontSize:617 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self);
		}];
		
		statusBtn = [[UIButton alloc] init];
		[statusBtn setImage:IMGRESOURCE(@"icon_infocard_non") forState:UIControlStateDisabled];
		[statusBtn setImage:IMGRESOURCE(@"checked_icon") forState:UIControlStateNormal];
		[self addSubview:statusBtn];
		[statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(10);
			make.right.equalTo(self).offset(-10);
			make.size.mas_equalTo(CGSizeMake(18, 18));
		}];
		statusBtn.enabled = NO;
		statusBtn.userInteractionEnabled = NO;
		
		self.userInteractionEnabled = YES;
		[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didViewTap)]];
	}
	return  self;
}

- (void)didViewTap {
//	self.tapBlocak();
	_tapBlocak();
}

- (void)setIsReady:(BOOL)isReady {
	_isReady = isReady;
	statusBtn.enabled = isReady;
		
	if (_isReady) {
		[Tools setViewBorder:radiusBGView withRadius:4.f andBorderWidth:1 andBorderColor:[Tools theme] andBackground:[Tools whiteColor]];
	} else
		[Tools setViewBorder:radiusBGView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
}


- (void)hideCheckSign {
	statusBtn.hidden = YES;
}
- (void)setTitleWithString:(NSString*)title {
	titleLabel.text = title;
}

@end
