//
//  AYSELTimeCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 25/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOTMNurseCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYOTMNurseCellView {
	
	UILabel *startLabel;
	UILabel *endLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		UILabel *startTitleLabel = [Tools creatLabelWithText:@"开始时间" textColor:[Tools theme] fontSize:14.f backgroundColor:nil textAlignment:1];
		[self addSubview:startTitleLabel];
		[startTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(47);
			make.top.equalTo(self).offset(8);
		}];
		
		UILabel *endTitleLabel = [Tools creatLabelWithText:@"结束时间" textColor:[Tools theme] fontSize:14.f backgroundColor:nil textAlignment:1];
		[self addSubview:endTitleLabel];
		[endTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-47);
			make.centerY.equalTo(startTitleLabel);
		}];
		
		startLabel = [Tools creatLabelWithText:@"the start" textColor:[Tools theme] fontSize:20.f backgroundColor:nil textAlignment:1];
		[self addSubview:startLabel];
		[startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(startTitleLabel);
			make.top.equalTo(self).offset(30);
		}];
		
		endLabel = [Tools creatLabelWithText:@"the end" textColor:[Tools theme] fontSize:20.f backgroundColor:nil textAlignment:1];
		[self addSubview:endLabel];
		[endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(endTitleLabel);
			make.centerY.equalTo(startLabel);
		}];
		
		[Tools creatCALayerWithFrame:CGRectMake(180, 45, 15, 1) andColor:[Tools theme] inSuperView:self];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"OTMNurseCell", @"OTMNurseCell");
	
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
	
	NSNumber *top = [args objectForKey:kAYServiceArgsStart];
	NSNumber *btm = [args objectForKey:kAYServiceArgsEnd];
	
	NSMutableString *tmp = [NSMutableString stringWithFormat:@"%.4d", top.intValue];
	[tmp insertString:@":" atIndex:2];
	startLabel.text = tmp;
	
	tmp = [NSMutableString stringWithFormat:@"%.4d", btm.intValue];
	[tmp insertString:@":" atIndex:2];
	endLabel.text = tmp;
		
	return nil;
}

@end
