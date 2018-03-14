//
//  AYHomeTopicItem.m
//  BabySharing
//
//  Created by Alfred Yang on 12/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeTopicItem.h"

@implementation AYHomeTopicItem {
	
	UILabel *engLabel;
	UILabel *titleLabel;
	UILabel *themeLabel;
	
	CGFloat titleWidth;
	NSDictionary *service_info;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize {
	
	self.layer.shadowColor = [UIColor gary].CGColor;
	self.layer.shadowOffset = CGSizeMake(0, 3);
	self.layer.shadowRadius = 3.f;
	self.layer.shadowOpacity = 0.5f;
	self.layer.cornerRadius = 3.f;
	
//	UIView *radiusView = [[UIView alloc] init];
//	[Tools setViewBorder:radiusView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[UIColor white]];
//	[self addSubview:radiusView];
//	[radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(self);
//	}];
	
	_coverImage = [[UIImageView alloc] init];
	_coverImage.image = IMGRESOURCE(@"default_image");
	_coverImage.contentMode = UIViewContentModeScaleAspectFill;
	[_coverImage setRadius:4 borderWidth:0 borderColor:nil background:nil];
	[self addSubview:_coverImage];
	[_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	engLabel = [UILabel creatLabelWithText:@"Service" textColor:[UIColor white] fontSize:622.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	engLabel.numberOfLines = 1;
	engLabel.textColor = [UIColor colorWithWhite:1 alpha:0.3];
	[self addSubview:engLabel];
	[engLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
		make.centerY.equalTo(self.mas_top).offset(18);
//		make.right.equalTo(self).offset(-SCREEN_MARGIN_LR);
	}];
	
	UIView *leftView = [[UIView alloc] init];
	[self addSubview:leftView];
	[leftView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self);
		make.top.equalTo(self).offset(37);
		make.size.mas_equalTo(CGSizeMake(SCREEN_MARGIN_LR, 40));
	}];
	
	titleLabel = [UILabel creatLabelWithText:@"Service" textColor:[UIColor white] fontSize:624.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(leftView.mas_right).offset(0);
		make.top.equalTo(self).offset(37);
		make.height.mas_equalTo(40);
//		make.width.mas_equalTo(124);
	}];
	UIView *rightView = [[UIView alloc] init];
	[self addSubview:rightView];
	[rightView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel.mas_right);
		make.top.equalTo(leftView).offset(0);
		make.size.equalTo(leftView);
	}];
	leftView.backgroundColor = rightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
	leftView.hidden = rightView.hidden = YES;
	
	themeLabel = [UILabel creatLabelWithText:@"Theme" textColor:[UIColor white] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	themeLabel.numberOfLines = 1;
	[self addSubview:themeLabel];
	[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
		make.right.equalTo(self).offset(-5);
		make.top.equalTo(titleLabel.mas_bottom).offset(14);
	}];
	
	engLabel.hidden = titleLabel.hidden = themeLabel.hidden = YES;
}

#pragma mark - actions
- (void)setItemInfo:(NSDictionary*)itemInfo {
	
	NSString *eng = [itemInfo objectForKey:@"eng"];
	engLabel.text = eng;
	
	NSString *title = [itemInfo objectForKey:@"title"];
	titleLabel.text = title;
	
	NSString *title_sub = [itemInfo objectForKey:@"title_sub"];
	themeLabel.text = title_sub;
	
	NSString *imgName = [itemInfo objectForKey:@"img"];
	_coverImage.image = IMGRESOURCE(imgName);
}


@end
