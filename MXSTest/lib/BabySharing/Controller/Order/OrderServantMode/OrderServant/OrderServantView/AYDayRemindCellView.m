//
//  AYDayRemindCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYDayRemindCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYDayRemindCellView {
	
	UIImageView *olockView;
	UILabel *countRemindLabel;
	
	UILabel *subTitleLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor clearColor];
		CGFloat marginContent = 20.f;
		UILabel *titleLabel = [Tools creatLabelWithText:@"提醒" textColor:[Tools black] fontSize:625.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(marginContent);
			make.top.equalTo(self).offset(30);
		}];
		
		subTitleLabel = [Tools creatLabelWithText:@"没有任何提醒" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:subTitleLabel];
		[subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(8);
		}];
		
		olockView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"chan_group_back")];
		[self addSubview:olockView];
		[olockView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(subTitleLabel);
			make.right.equalTo(self).offset(-marginContent);
			make.size.mas_equalTo(CGSizeMake(20, 20));
		}];
		olockView.hidden = YES;
		
		countRemindLabel = [Tools creatLabelWithText:@"0 个" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:1];
		[self addSubview:countRemindLabel];
		[countRemindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(marginContent);
			make.centerY.equalTo(subTitleLabel.mas_bottom).offset(40);
		}];
		
//		UIView *lineView = [UIView new];
//		lineView.backgroundColor = [Tools garyLineColor];
//		[self addSubview:lineView];
//		[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.centerX.equalTo(self);
//			make.bottom.equalTo(self);
//			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - marginLine * 2, 0.5));
//		}];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"DayRemindCell", @"DayRemindCell");
	
	NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
	for (NSString* name in cell.commands.allKeys) {
		AYViewCommand* cmd = [cell.commands objectForKey:name];
		AYViewCommand* c = [[AYViewCommand alloc]init];
		c.view = self;
		c.method_name = cmd.method_name;
		c.need_args = cmd.need_args;
		[arr_commands setValue:c forKey:name];
	}
	self.commands = [arr_commands copy];
	
	NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
	for (NSString* name in cell.notifies.allKeys) {
		AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
		AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
		c.view = self;
		c.method_name = cmd.method_name;
		c.need_args = cmd.need_args;
		[arr_notifies setValue:c forKey:name];
	}
	self.notifies = [arr_notifies copy];
}

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

- (id)setCellInfo:(NSArray*)args {
	
	if (args.count == 0) {
		olockView.hidden = YES;
		subTitleLabel.text = @"今日没有日程提醒";
		countRemindLabel.hidden = YES;
		
	} else if (args.count >= 1) {
		
		subTitleLabel.text = @"今日日程";
		olockView.hidden = countRemindLabel.hidden = NO;
		
		NSString *tmp = [NSString stringWithFormat:@"%ld 个", args.count];
		int length = (int)tmp.length;
		
		NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:tmp];
		[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:25.f], NSForegroundColorAttributeName :[Tools black]} range:NSMakeRange(0, length-2)];
		countRemindLabel.attributedText = attributedText;
		
	}
	return nil;
}

@end
