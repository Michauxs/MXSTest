//
//  AYOTMCourseCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 26/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOTMCourseCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYOTMCourseCellView {
	
	UILabel *startLabel;
	UILabel *endLabel;
	UIButton *checkBtn;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor clearColor];
		
		UIImageView *olockView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"timeflow_icon_olock")];
		[self addSubview:olockView];
		[olockView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(27);
			make.top.equalTo(self).offset(16);
			make.size.mas_equalTo(CGSizeMake(26, 26));
		}];
		
		UIView *timeDivView = [[UIView alloc] init];
		timeDivView.layer.cornerRadius = 4.f;
		timeDivView.clipsToBounds = YES;
		timeDivView.backgroundColor = [Tools whiteColor];
		[self addSubview:timeDivView];
		[timeDivView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self);
			make.left.equalTo(self).offset(55);
			make.right.equalTo(self).offset(-75);
			make.height.equalTo(@65);
		}];
		
		UILabel *startTitleLabel = [Tools creatLabelWithText:@"开始时间" textColor:[Tools theme] fontSize:14.f backgroundColor:nil textAlignment:1];
		[timeDivView addSubview:startTitleLabel];
		[startTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(timeDivView).offset(25);
			make.top.equalTo(timeDivView).offset(4);
		}];
		
		UILabel *endTitleLabel = [Tools creatLabelWithText:@"结束时间" textColor:[Tools theme] fontSize:14.f backgroundColor:nil textAlignment:1];
		[timeDivView addSubview:endTitleLabel];
		[endTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(timeDivView).offset(-25);
			make.centerY.equalTo(startTitleLabel);
		}];
		
		startLabel = [Tools creatLabelWithText:@"the start" textColor:[Tools theme] fontSize:20.f backgroundColor:nil textAlignment:1];
		[timeDivView addSubview:startLabel];
		[startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(startTitleLabel);
			make.top.equalTo(timeDivView).offset(30);
		}];
		
		endLabel = [Tools creatLabelWithText:@"the end" textColor:[Tools theme] fontSize:20.f backgroundColor:nil textAlignment:1];
		[timeDivView addSubview:endLabel];
		[endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(endTitleLabel);
			make.centerY.equalTo(startLabel);
		}];
		
		UIView *toIconView = [[UIView alloc] init];
		toIconView.backgroundColor = [Tools theme];
		[timeDivView addSubview:toIconView];
		[toIconView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(timeDivView);
			make.centerY.equalTo(startLabel);
			make.size.mas_equalTo(CGSizeMake(17, 1));
		}];
		
		checkBtn = [[UIButton alloc] init];
		[checkBtn setImage:IMGRESOURCE(@"icon_pick") forState:UIControlStateNormal];
		[checkBtn setImage:IMGRESOURCE(@"icon_pick_selected") forState:UIControlStateSelected];
		[self addSubview:checkBtn];
		[checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-15);
			make.centerY.equalTo(timeDivView);
			make.size.mas_equalTo(CGSizeMake(30, 30));
		}];
		checkBtn.userInteractionEnabled = NO;
		
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
	
	checkBtn.selected = ((NSNumber*)[args objectForKey:@"is_selected"]).boolValue;
	
	return nil;
}

@end
