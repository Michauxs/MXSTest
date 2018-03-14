//
//  AYOnceTipView.m
//  BabySharing
//
//  Created by Alfred Yang on 25/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOnceTipView.h"
#import "AYCommandDefines.h"

@implementation AYOnceTipView {
	UILabel *titleLabel;
}

- (instancetype)initWithTitle:(NSString *)title {
	self = [super init];
	if (self) {
		
//		self.backgroundColor = [Tools garyBackgroundColor];
		
		_delBtn = [[UIButton alloc] init];
		[_delBtn setImage:IMGRESOURCE(@"content_close") forState:UIControlStateNormal];
		[self addSubview:_delBtn];
		[_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(self).offset(-5);
			make.size.mas_equalTo(CGSizeMake(10, 10));
		}];
		
		titleLabel = [Tools creatLabelWithText:title textColor:[Tools garyColor] fontSize:313 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.centerY.equalTo(self);
			make.right.equalTo(_delBtn.mas_left).offset(-5);
		}];
		
		UIImageView *BGView = [[UIImageView alloc] init];
		UIImage *bgImage = [UIImage imageNamed:@"arrow_sign_left_triangle"];
		bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 2) resizingMode:UIImageResizingModeTile];
		[self addSubview:BGView];
		[BGView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
		BGView.image = bgImage;
		[self sendSubviewToBack:BGView];
		
//		[_delBtn addTarget:self action:@selector(didViewTap) forControlEvents:UIControlEventTouchUpInside];
	}
	return  self;
}

@end
