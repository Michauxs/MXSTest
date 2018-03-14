//
//  AYFilterCansCatCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 31/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYFilterCansCellView.h"

@implementation AYFilterCansCellView {
	UILabel *titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (instancetype)init{
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize {
	
	titleLabel = [Tools creatUILabelWithText:@"Title" andTextColor:[Tools themeColor] andFontSize:315.f andBackgroundColor:[Tools garyBackgroundColor] andTextAlignment:NSTextAlignmentCenter];
	[Tools setViewBorder:titleLabel withRadius:20.f andBorderWidth:2.f andBorderColor:[Tools themeColor] andBackground:nil];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(self).insets(UIEdgeInsetsMake(25, 20, 25, 0));
//		make.center.equalTo(self);
		make.edges.equalTo(self);
	}];
	
}

- (void)setItemInfo:(NSDictionary *)itemInfo {
	_itemInfo = itemInfo;
	
	NSString *title = [itemInfo objectForKey:@"title"];
	titleLabel.text = title;
	
	NSNumber *isSelected = [itemInfo objectForKey:@"is_selected"];
	[self setStatusWith:isSelected.boolValue];
	
}

- (void)setStatusWith:(BOOL)isSelected {
	if (isSelected) {
		titleLabel.textColor = [Tools whiteColor];
		titleLabel.backgroundColor = [Tools themeColor];
		[Tools setViewBorder:titleLabel withRadius:20.f andBorderWidth:0.f andBorderColor:nil andBackground:nil];
	} else {
		titleLabel.textColor = [Tools themeColor];
		titleLabel.backgroundColor = [Tools garyBackgroundColor];
		[Tools setViewBorder:titleLabel withRadius:20.f andBorderWidth:2.f andBorderColor:[Tools themeBorderColor] andBackground:nil];
	}
}

@end
