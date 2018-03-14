//
//  AYBtmTipView.m
//  BabySharing
//
//  Created by Alfred Yang on 11/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYBtmTipView.h"

@implementation AYBtmTipView {
	UILabel *titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		
		self.backgroundColor = [UIColor white];
		
		_closeBtn = [UIButton new];
		[_closeBtn setImage:IMGRESOURCE(@"content_close") forState:UIControlStateNormal];
		[self addSubview:_closeBtn];
		[_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-5);
			make.centerY.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(49, 49));
		}];
		
		
		titleLabel = [Tools creatLabelWithText:@"title" textColor:[Tools black] fontSize:614.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		titleLabel.numberOfLines = 0;
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self).offset(15);
			make.right.equalTo(_closeBtn.mas_left).offset(-10);
		}];
		
		CALayer *topLine = [CALayer layer];
		topLine.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
		topLine.backgroundColor = [UIColor garyLine].CGColor;
		[self.layer addSublayer:topLine];
		
		
		self.userInteractionEnabled = YES;
		[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap)]];
	}
	return self;
}

- (void)selfTap {
	//nothing todo
}

- (void)setTitle:(NSString *)title {
	_title = title;
	titleLabel.text = title;
}

- (void)replaceInterfaceBtnWithString:(NSString *)title {
	
	_closeBtn = [UIButton creatBtnWithTitle:title titleColor:[Tools theme] fontSize:314.f backgroundColor:nil];
	[self addSubview:_closeBtn];
	[_closeBtn sizeToFit];
	[_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel);
		make.top.equalTo(titleLabel.mas_bottom).offset(5);
		make.size.mas_equalTo(CGSizeMake(_closeBtn.bounds.size.width + 10, _closeBtn.bounds.size.height));
	}];
	[titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(_closeBtn.mas_left).offset(-10);
	}];
}

- (void)replaceCertainBtn {
	NSString *btnTitleStr = @"确认";
	_closeBtn = [UIButton creatBtnWithTitle:btnTitleStr titleColor:[Tools theme] fontSize:314.f backgroundColor:nil];
	[self addSubview:_closeBtn];
	[_closeBtn sizeToFit];
	[_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel);
		make.top.equalTo(titleLabel.mas_bottom).offset(5);
		make.size.mas_equalTo(CGSizeMake(_closeBtn.bounds.size.width + 10, _closeBtn.bounds.size.height));
	}];
	
	[titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(_closeBtn.mas_left).offset(-10);
	}];
}

@end
