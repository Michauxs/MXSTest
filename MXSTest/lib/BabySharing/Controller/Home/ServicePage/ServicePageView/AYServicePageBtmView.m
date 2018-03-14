//
//  AYServicePageBtmView.m
//  BabySharing
//
//  Created by Alfred Yang on 24/8/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYServicePageBtmView.h"
#import "AYCommandDefines.h"

#define kChatBtnWidth				69
#define kBookBtnWidth				152

@implementation AYServicePageBtmView {
	UILabel *priceLabel;
	UILabel *capacityLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initLayoutView];
	}
	return self;
}

- (void)initLayoutView {
	
	/*-------------------------*/
	self.backgroundColor = [Tools whiteColor];
	self.layer.shadowColor = [Tools garyColor].CGColor;
	self.layer.shadowOffset = CGSizeMake(0, -0.5);
	self.layer.shadowOpacity = 0.4f;
	
	[Tools creatCALayerWithFrame:CGRectMake(kChatBtnWidth, 0, 0.5, self.bounds.size.height) andColor:[Tools garyLineColor] inSuperView:self];
	
	_chatBtn = [[UIButton alloc]init];
	[_chatBtn setImage:IMGRESOURCE(@"service_chat") forState:UIControlStateNormal];
	[_chatBtn setTitle:@"沟通" forState:UIControlStateNormal];
	_chatBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
	[_chatBtn setTitleColor:[Tools garyColor] forState:UIControlStateNormal];
	[_chatBtn setImageEdgeInsets:UIEdgeInsetsMake(-17, 0, 0, -24)];
	[_chatBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, -31, 0)];
//	[chatBtn addTarget:self action:@selector(didChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_chatBtn];
	[_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self);
		make.top.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(kChatBtnWidth, self.bounds.size.height));
	}];
	
	
	priceLabel = [Tools creatLabelWithText:@"Price 0f Serv" textColor:[Tools black] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self addSubview:priceLabel];
	[priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(_chatBtn.mas_right).offset((SCREEN_WIDTH - kBookBtnWidth - kChatBtnWidth) * 0.5);
		make.bottom.equalTo(self.mas_centerY).offset(2);
	}];
	
	capacityLabel = [Tools creatLabelWithText:@"MIN Book Times" textColor:[Tools garyColor] fontSize:311.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[self addSubview:capacityLabel];
	[capacityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mas_centerY).offset(4);
		make.left.equalTo(priceLabel);
	}];
	
	
	_bookBtn = [Tools creatBtnWithTitle:@"查看可预订时间" titleColor:[Tools whiteColor] fontSize:615.f backgroundColor:[Tools theme]];
	UIImage *bgimage = IMGRESOURCE(@"details_button_checktime");
	_bookBtn.layer.contents = (__bridge id _Nullable)(bgimage.CGImage);
//	[_bookBtn addTarget:self action:@selector(didBookBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	[self addSubview:_bookBtn];
	[_bookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.right.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(kBookBtnWidth, self.bounds.size.height));
	}];
}

- (void)setViewWithData:(NSDictionary *)service_info {
	NSDictionary *info_detail = [service_info objectForKey:kAYServiceArgsDetailInfo];
	NSDictionary *inf0_categ = [service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSString *unitCat;
	NSNumber *leastTimesOrHours;
	NSString *service_cat = [inf0_categ objectForKey:kAYServiceArgsCat];
	if ([service_cat containsString:@"看"]) {
		unitCat = @"小时";
		leastTimesOrHours = [info_detail objectForKey:kAYServiceArgsLeastHours];
	}else if ([service_cat isEqualToString:kAYStringCourse]) {
		unitCat = @"次";
		leastTimesOrHours = [info_detail objectForKey:kAYServiceArgsLeastTimes];
	} else {
		NSLog(@"---null---");
		unitCat = @"单价";
		leastTimesOrHours = @1;
	}
	NSNumber *price = [info_detail objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%.f", price.intValue * 0.01];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", tmp, unitCat];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontMedium(18.f), NSForegroundColorAttributeName :[Tools black]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11.f], NSForegroundColorAttributeName :[Tools garyColor]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	priceLabel.attributedText = attributedText;
	
	capacityLabel.text = [NSString stringWithFormat:@"最少预定%@%@", leastTimesOrHours, unitCat];
}

@end
