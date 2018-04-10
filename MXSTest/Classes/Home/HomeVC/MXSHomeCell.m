//
//  MXSHomeCell.m
//  MXSTest
//
//  Created by Alfred Yang on 10/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSHomeCell.h"

@implementation MXSHomeCell {
	UILabel *titleLabel;
}

@synthesize cellInfo = _cellInfo;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
//		self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
		self.backgroundColor = [UIColor clearColor];
		
		UIView *btmLine = [[UIView alloc] init];
		btmLine.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
		[self addSubview:btmLine];
		[btmLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self);
			make.left.equalTo(self);
			make.right.equalTo(self);
			make.height.mas_equalTo(1);
		}];
		UIView *topLine = [[UIView alloc] init];
		topLine.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
		[self addSubview:topLine];
		[topLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(btmLine.mas_top);
			make.left.equalTo(self);
			make.right.equalTo(self);
			make.height.mas_equalTo(0.5);
		}];
		
		titleLabel = [Tools creatLabelWithText:@"Title" textColor:[Tools whiteColor] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.centerY.equalTo(self);
		}];
	}
	return self;
}

- (void)setCellInfo:(id)cellInfo {
	_cellInfo = cellInfo;
	titleLabel.text = cellInfo;
}

@end
