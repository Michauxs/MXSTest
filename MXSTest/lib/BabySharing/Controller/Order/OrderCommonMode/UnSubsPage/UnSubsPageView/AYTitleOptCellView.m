//
//  AYTitleOptCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 5/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYTitleOptCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"


@implementation AYTitleOptCellView {
	
	UILabel *titleLabel;
	UIImageView *signView;
	
	NSDictionary *service;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		titleLabel = [Tools creatLabelWithText:@"Pay Way Option" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self).offset(20);
		}];
		
		signView = [UIImageView new];
		signView.image = IMGRESOURCE(@"checked_icon");
		[self addSubview:signView];
		[signView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(self).offset(-20);
			make.size.mas_equalTo(CGSizeMake(12.5, 12.5));
		}];
		signView.hidden = YES;
		
		[Tools addBtmLineWithMargin:10.f andAlignment:NSTextAlignmentCenter andColor:[Tools garyLineColor] inSuperView:self];
		
		self.userInteractionEnabled = YES;
		[self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didOptionClick)]];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"TitleOptCell", @"TitleOptCell");
	
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
- (void)didOptionClick {
	id tmp = @{@"view":signView, @"string":titleLabel.text};
	id<AYCommand> cmd = [self.notifies objectForKey:@"didOptionClick:"];
	[cmd performWithResult:&tmp];
	
}

#pragma mark -- messages
- (id)setCellInfo:(NSDictionary*)dic_args {
	
	NSUInteger row = ((NSNumber*)[dic_args objectForKey:@"row_index"]).integerValue;
	signView.tag = row;
	
	NSString *title = [dic_args objectForKey:@"title"];
	titleLabel.text = title;
	
	if (row == 0) {
		
		signView.hidden = NO;
		id tmp = @{@"view":signView, @"string":titleLabel.text};
		id<AYCommand> cmd = [self.notifies objectForKey:@"didOptionClick:"];
		[cmd performWithResult:&tmp];
		
	}
	
	return nil;
}

@end
