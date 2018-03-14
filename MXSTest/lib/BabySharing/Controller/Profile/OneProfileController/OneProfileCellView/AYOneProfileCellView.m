//
//  AYOneProfileCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 12/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYOneProfileCellView.h"

@implementation AYOneProfileCellView {
	UILabel *userName;
	UILabel *brandName;
	
	UILabel *brandAbout;
}

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
		
		userName = [Tools creatLabelWithText:@"User Name" textColor:[UIColor black13] fontSize:626 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:userName];
		[userName mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.top.equalTo(self).offset(50);
		}];
		
		brandName = [UILabel creatLabelWithText:@"Brand Name" textColor:[UIColor gary115] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:brandName];
		[brandName mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userName);
			make.top.equalTo(userName.mas_bottom).offset(4);
		}];
		
		UILabel *descTitle = [UILabel creatLabelWithText:@"关于我们" textColor:[UIColor black] fontSize:615 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:descTitle];
		[descTitle mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userName);
			make.top.equalTo(brandName.mas_bottom).offset(28);
		}];
		
		brandAbout = [UILabel creatLabelWithText:@"Brand Name" textColor:[UIColor gary115] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:brandAbout];
		[brandAbout mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userName);
			make.top.equalTo(descTitle.mas_bottom).offset(4);
			make.right.equalTo(self).offset(-SCREEN_MARGIN_LR);
			make.bottom.equalTo(self).offset(-30);
		}];
	}
	return self;
}

#pragma mark -- actions
- (void)someAction {

}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	
	NSString *name = [args objectForKey:kAYBrandArgsName];
	if (name.length == 0) {
		name = @"品牌";
	}
	userName.text = name;
	brandName.text = [name stringByAppendingString:@"老师"];
	
	brandAbout.text = [args objectForKey:kAYBrandArgsAbout];
	
	return nil;
}

@end

