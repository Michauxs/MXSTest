//
//  AYFilterThemeCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 20/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYFilterThemeCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYFilterThemeCellView {
	
	UILabel *titleLabel;
	UIButton *optionBtn;
	
	NSDictionary *dic_theme;
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		titleLabel = [Tools creatLabelWithText:@"Titles" textColor:[Tools black] fontSize:17.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.centerY.equalTo(self);
		}];
		
		optionBtn = [[UIButton alloc]init];
		[self addSubview:optionBtn];
		[optionBtn setImage:[UIImage imageNamed:@"icon_pick"] forState:UIControlStateNormal];
		[optionBtn setImage:[UIImage imageNamed:@"icon_pick_selected"] forState:UIControlStateSelected];
		[optionBtn addTarget:self action:@selector(didOptionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		[optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(self).offset(-20);
			make.size.mas_equalTo(CGSizeMake(25, 25));
		}];
		
//		CALayer *sepLayer = [CALayer layer];
//		sepLayer.frame = CGRectMake(0, 44.5, SCREEN_WIDTH, 0.5);
//		sepLayer.backgroundColor = [Tools garyLineColor].CGColor;
//		[self.layer addSublayer:sepLayer];
		
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
	id<AYViewBase> cell = VIEW(@"FilterThemeCell", @"FilterThemeCell");
	
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
-(void)didOptionBtnClick:(UIButton*)btn {
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]initWithDictionary:dic_theme];
	[tmp setValue:btn forKey:@"option_btn"];
	id<AYCommand> cmd = [self.notifies objectForKey:@"didSelectedOpt:"];
	[cmd performWithResult:&tmp];
	
}


#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)args {
	
	titleLabel.text = [args objectForKey:@"title"];
	dic_theme = args;
	
	BOOL is_selected = ((NSNumber*)[args objectForKey:@"is_selected"]).boolValue;
	if (is_selected) {
		
		[self didOptionBtnClick:optionBtn];
	} else {
		optionBtn.selected = NO;
	}
	
	return nil;
}

@end
