//
//  AYListEndSignCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 8/2/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYListEndSignCellView.h"

@implementation AYListEndSignCellView 

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCatigoryView;
}

#pragma mark -- life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UIImageView *sign = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"icon_nomore_sign")];
		[self addSubview:sign];
		[sign mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(344, 16));
			make.top.equalTo(self).offset(0);
			make.bottom.equalTo(self).offset(-28);
		}];
	}
	return self;
}

#pragma mark -- actions
- (void)showHideLabelTap {
	
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	
	return nil;
}

@end

