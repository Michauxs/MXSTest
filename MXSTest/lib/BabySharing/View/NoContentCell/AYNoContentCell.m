//
//  AYNoContentCell.m
//  BabySharing
//
//  Created by Alfred Yang on 13/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNoContentCell.h"

@implementation AYNoContentCell {
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		_descLabel = [Tools creatLabelWithText:@"没有内容" textColor:[Tools garyColor] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:_descLabel];
		[_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.centerY.equalTo(self);
		}];
		
	}
	return self;
}

- (void)setTitleStr:(NSString *)titleStr {
	_titleStr = titleStr;
	_descLabel.text = titleStr;
}

@end
