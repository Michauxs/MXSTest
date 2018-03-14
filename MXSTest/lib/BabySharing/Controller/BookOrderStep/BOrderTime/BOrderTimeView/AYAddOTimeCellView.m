//
//  AYAddOTimeCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 25/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAddOTimeCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYAddOTimeCellView {
	
	UILabel *titleLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor whiteColor];
		
		UIView *divView = [UIView new];
		divView.backgroundColor  = [UIColor clearColor];
		[self addSubview:divView];
		[divView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(120, 40));
		}];
		
		titleLabel = [Tools creatLabelWithText:@"添加时间" textColor:[Tools theme] fontSize:16.f backgroundColor:nil textAlignment:0];
		[divView addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(divView);
			make.centerY.equalTo(divView);
		}];
		
		UIButton *addSignBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
		addSignBtn.tintColor = [Tools theme];
		addSignBtn.userInteractionEnabled = NO;
		[divView addSubview:addSignBtn];
		[addSignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(divView);
			make.centerY.equalTo(divView);
			make.size.mas_equalTo(CGSizeMake(30, 30));
		}];
		
//		if (reuseIdentifier != nil) {
//			[self setUpReuseCell];
//		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"AddOTimeCell", @"AddOTimeCell");
	
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

- (id)setCellInfo:(NSDictionary*)args {
	
	return nil;
}

@end
