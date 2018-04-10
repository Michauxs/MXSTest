//
//  MXSTableViewCell.m
//  MXSPlayer
//
//  Created by Alfred Yang on 29/8/17.
//  Copyright © 2017年 MXS. All rights reserved.
//

#import "MXSTableViewCell.h"

@implementation MXSTableViewCell {
	UILabel *titleLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
	}
	return self;
}

- (void)setCellInfo:(id)cellInfo {
	_cellInfo = cellInfo;
	
	titleLabel = [Tools creatLabelWithText:cellInfo textColor:[UIColor black] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(20);
		make.centerY.equalTo(self);
	}];
	
}

@end
