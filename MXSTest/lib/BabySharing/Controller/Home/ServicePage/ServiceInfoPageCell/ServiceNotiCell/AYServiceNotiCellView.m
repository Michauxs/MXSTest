//
//  AYServiceNotiCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 23/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceNotiCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"

@implementation AYServiceNotiCellView {
	UILabel *tipsTitleLabel;
	
	UIView *allowSignView;
	UILabel *allowLabel;
	
	UIView *otherSignView;
	UILabel *otherWordLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		tipsTitleLabel = [Tools creatLabelWithText:@"服务守则" textColor:[Tools garyColor] fontSize:318.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:tipsTitleLabel];
		[tipsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.top.equalTo(self).offset(30);
		}];
		
		allowSignView = [[UIView alloc] init];
		[Tools setViewBorder:allowSignView withRadius:2.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools theme]];
		[self addSubview:allowSignView];
		[allowSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(tipsTitleLabel);
			make.top.equalTo(tipsTitleLabel.mas_bottom).offset(40);
			make.size.mas_equalTo(CGSizeMake(4, 4));
		}];
		allowLabel = [Tools creatLabelWithText:@"Is Allow leave" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:allowLabel];
		[allowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(allowSignView.mas_right).offset(10);
			make.centerY.equalTo(allowSignView);
		}];
		
		otherSignView = [[UIView alloc] init];
		[Tools setViewBorder:otherSignView withRadius:2.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools theme]];
		[self addSubview:otherSignView];
		[otherSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(allowSignView);
			make.top.equalTo(allowSignView.mas_bottom).offset(25);
			make.size.equalTo(allowSignView);
		}];
		
		otherWordLabel = [Tools creatLabelWithText:@"Other Words" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		otherWordLabel.numberOfLines = 0;
		[self addSubview:otherWordLabel];
		[otherWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(allowLabel);
			make.right.equalTo(self).offset(-15);
			make.top.equalTo(otherSignView.mas_centerY).offset(-8);
			make.bottom.equalTo(self).offset(-20);
		}];
//		otherWordLabel.hidden = YES;
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"ServiceNotiCell", @"ServiceNotiCell");
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
- (void)didDetailBtnClick {
	kAYViewSendNotify(self, @"showServiceOfferDate", nil)
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	
	NSDictionary *service_info = args;
	NSDictionary *info_detail = [service_info objectForKey:kAYServiceArgsDetailInfo];
	
	NSString *leaveStr = @"不需要家长陪同";
	NSNumber *isAllow = [info_detail objectForKey:kAYServiceArgsAllowLeave];
	if (isAllow.boolValue) {
		leaveStr = @"需要家长陪同";
	}
	allowLabel.text = leaveStr;
	
	NSString *otherWords = [info_detail objectForKey:kAYServiceArgsNotice];
	if (!otherWords || [otherWords isEqualToString:@""]) {
		[allowLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-15);
			make.left.equalTo(allowSignView.mas_right).offset(10);
			make.centerY.equalTo(allowSignView);
			make.bottom.equalTo(self).offset(-30);
		}];
		otherSignView.hidden = otherWordLabel.hidden = YES;
	}
	else {
		otherWordLabel.text = otherWords;
	}
	
	return nil;
}

@end
