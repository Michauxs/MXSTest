//
//  AYSetPriceInputView.m
//  BabySharing
//
//  Created by Alfred Yang on 11/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetPriceInputView.h"

@implementation AYSetPriceInputView {
	
	UIView *sepLine;
}

- (instancetype)initWithSign:(NSString *)sign {
	if (self = [super init]) {
		
		_inputField = [[UITextField alloc] init];
//		_inputField.placeholder =  @"请输入";
		NSString *holderText =  @"请输入";
		NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
		[placeholder addAttribute:NSForegroundColorAttributeName
							value:[Tools garyColor]
							range:NSMakeRange(0, holderText.length)];
		[placeholder addAttribute:NSFontAttributeName
							value:kAYFontMedium(17)
							range:NSMakeRange(0, holderText.length)];
		_inputField.attributedPlaceholder = placeholder;
		
		
		_inputField.textColor = [Tools theme];
		_inputField.font = [UIFont boldSystemFontOfSize:24.f];
		_inputField.textAlignment = NSTextAlignmentCenter;
		_inputField.keyboardType = UIKeyboardTypeNumberPad;
		_inputField.returnKeyType = UIReturnKeyDone;
		[self addSubview:_inputField];
		[_inputField mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self.mas_centerY).offset(-5);
			make.centerX.equalTo(self);
			make.width.equalTo(self);
		}];
		
		sepLine = [[UIView alloc] init];
		sepLine.backgroundColor = [Tools RGB225GaryColor];
		[self addSubview:sepLine];
		[sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self);
			make.width.equalTo(self);
			make.height.mas_equalTo(1);
		}];
		
		UILabel *signLabel = [Tools creatLabelWithText:sign textColor:[Tools black] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:signLabel];
		[signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.top.equalTo(self.mas_centerY).offset(5);
		}];
	}
	return self;
}

- (void)setIsHideSep:(BOOL)isHideSep {
	_isHideSep = isHideSep;
	sepLine.hidden = isHideSep;
}

@end
