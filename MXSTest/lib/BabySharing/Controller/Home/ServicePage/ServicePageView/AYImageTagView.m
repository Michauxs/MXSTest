//
//  AYImageTagView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYImageTagView.h"

@implementation AYImageTagView {
	
	UIImageView *sign;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title {
	self = [super initWithFrame:frame];
	if (self) {
		
		_label = [UILabel creatLabelWithText:title textColor:[UIColor white] fontSize:313 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:_label];
		[_label mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self);
		}];
		
		sign = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"triangle")];
		[self addSubview:sign];
		[sign mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(9, 5));
		}];
		sign.hidden = YES;
	}
	return self;
}


- (void)setIsSelect:(BOOL)isSelect {
	_isSelect = isSelect;
	sign.hidden = !isSelect;
}

@end
