//
//  AYNurseScheduleCellThemeView.m
//  BabySharing
//
//  Created by Alfred Yang on 1/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNurseScheduleCellThemeView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYNurseScheduleCellThemeView {
	
	UILabel *startLabel;
	UILabel *endLabel;
	UIButton *delBtn;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		CGFloat selfHeight = 55.f;
		
		startLabel = [Tools creatLabelWithText:@"开始" textColor:[Tools theme] fontSize:20.f backgroundColor:nil textAlignment:1];
		[self addSubview:startLabel];
		[startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.centerY.equalTo(self);
			make.width.mas_equalTo(80);
		}];
		
		endLabel = [Tools creatLabelWithText:@"结束" textColor:[Tools theme] fontSize:20.f backgroundColor:nil textAlignment:1];
		[self addSubview:endLabel];
		[endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(startLabel.mas_right).offset(55);
			make.centerY.equalTo(self);
			make.width.mas_equalTo(80);
		}];
		
		startLabel.alpha = endLabel.alpha = 0.6f;
		
		delBtn = [[UIButton alloc] init];
		[delBtn setImage:IMGRESOURCE(@"cross_theme") forState:UIControlStateNormal];
		[self addSubview:delBtn];
		[delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-20);
			make.centerY.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(30, 30));
		}];
		[delBtn addTarget:self action:@selector(didDelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		
		UIView *startLine = [UIView new];
		[self addSubview:startLine];
		[startLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(startLabel);
			make.bottom.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(80, 0.5));
		}];
		UIView *endLine = [UIView new];
		[self addSubview:endLine];
		[endLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(endLabel);
			make.bottom.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(80, 0.5));
		}];
		startLine.backgroundColor = endLine.backgroundColor = [Tools theme];
		
		[Tools creatCALayerWithFrame:CGRectMake(119, selfHeight * 0.5 - 1, 15, 2) andColor:[Tools theme] inSuperView:self];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"NurseScheduleCellTheme", @"NurseScheduleCellTheme");
	
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

#pragma mark -- actions
- (void)didDelBtnClick:(UIButton*)btn {
	
	NSNumber *tmp = [NSNumber numberWithInteger:btn.tag];
	kAYViewSendNotify(self, @"delTimeDuration:", &tmp)
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	
	NSNumber *is_first = [args objectForKey:@"is_first"];
	delBtn.hidden = is_first.boolValue;
	delBtn.tag = ((NSNumber*)[args objectForKey:@"row"]).integerValue;
	
	NSDictionary *dic_time = [args objectForKey:@"dic_time"];
	if (dic_time) {
		NSNumber *top = [dic_time objectForKey:@"starthours"];
		if (!top) {
			top = [dic_time objectForKey:kAYServiceArgsStart];
		}
		NSNumber *btm = [dic_time objectForKey:@"endhours"];
		if (!btm) {
			btm = [dic_time objectForKey:kAYServiceArgsEnd];
		}
		
		NSMutableString *tmp = [NSMutableString stringWithFormat:@"%.4d", top.intValue];
		[tmp insertString:@":" atIndex:2];
		startLabel.text = tmp;
		
		tmp = [NSMutableString stringWithFormat:@"%.4d", btm.intValue];
		[tmp insertString:@":" atIndex:2];
		endLabel.text = tmp;
		
		startLabel.alpha = endLabel.alpha = 1.f;
	}
	
	return nil;
}

@end
