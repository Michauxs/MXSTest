//
//  AYSetServiceCharactCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 18/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceCharactCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

#import "AYCourseSignView.h"

@implementation AYSetServiceCharactCellView {
	UILabel *titleLabel;
	
	NSArray *charactArr;
	NSMutableArray *charactViewArr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UIView *shadowBGView = [[UIView alloc] init];
		shadowBGView.layer.cornerRadius = 4.f;
		shadowBGView.layer.shadowColor = [Tools garyColor].CGColor;
		shadowBGView.layer.shadowRadius = 4.f;
		shadowBGView.layer.shadowOpacity = 0.5f;
		shadowBGView.layer.shadowOffset = CGSizeMake(0, 0);
		shadowBGView.backgroundColor = [Tools whiteColor];
		[self addSubview:shadowBGView];
		[shadowBGView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.self.insets(UIEdgeInsetsMake(8, 20, 8, 20));
		}];
		
		UIView *radiusBGView = [[UIView alloc] init];
		[self addSubview:radiusBGView];
		[radiusBGView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(shadowBGView);
		}];
		[Tools setViewBorder:radiusBGView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
		
		titleLabel = [Tools creatLabelWithText:nil textColor:[Tools black] fontSize:617 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(radiusBGView).offset(15);
			make.top.equalTo(radiusBGView).offset(12);
		}];
		
		charactArr = kAY_service_options_characters;
		charactViewArr = [NSMutableArray array];
		int row = 0, col = 0;
		CGFloat margin = 16;
		CGFloat itemWith = (SCREEN_WIDTH - 70 - margin*2)/3;
		CGFloat itemHeight = 33;
		for (int i = 0; i < charactArr.count; ++i) {
			row = i / 3;
			col = i % 3;
			AYCourseSignView *signView = [[AYCourseSignView alloc] initWithFrame:CGRectMake(15 + col*(margin + itemWith), 56 + row*(margin + itemHeight), itemWith, itemHeight) andTitle:[charactArr objectAtIndex:i]];
			[radiusBGView addSubview:signView];
			
			signView.userInteractionEnabled = YES;
			[signView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCharactViewTap:)]];
			[charactViewArr addObject:signView];
		}
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"SetServiceCharactCell", @"SetServiceCharactCell");
	
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
- (void)didCharactViewTap:(UITapGestureRecognizer*)tap {
	UIView *tapView = tap.view;
	NSString *sign = ((AYCourseSignView*)tapView).sign;
	kAYViewSendNotify(self, @"didCharactViewTap:", &sign)
}


- (id)setCellInfo:(id)args {
	NSString *title = [args objectForKey:@"title"];
	titleLabel.text = title;
	
	NSArray *charArr = [args objectForKey:kAYServiceArgsCharact];
	for (AYCourseSignView *view in charactViewArr) {
		if ([charArr containsObject:view.sign]) {
			[view setSelectStatus];
		} else {
			[view setUnselectStatus];
		}
	}
	
	return nil;
}


@end
