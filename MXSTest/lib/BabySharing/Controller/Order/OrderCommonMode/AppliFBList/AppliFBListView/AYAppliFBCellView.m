//
//  AYAppliFBCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAppliFBCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYAppliFBCellView {
	
	UIView *remindView;
	
	UIImageView *userPhotoView;
	UILabel *userNameLabel;
	UILabel *serviceTitleLabel;
	UILabel *FBActionLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor whiteColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		CGFloat imageWidth = 45.f;
		CGFloat margin = 10.f;
//		[Tools creatCALayerWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - margin*2, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
		userPhotoView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"default_user")];
		[Tools setViewBorder:userPhotoView withRadius:imageWidth * 0.5 andBorderWidth:2.f andBorderColor:[Tools borderAlphaColor] andBackground:nil];
		[self addSubview:userPhotoView];
		[userPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self).offset(20);
			make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
		}];
		
		userNameLabel = [Tools creatLabelWithText:@"User Name" textColor:[Tools black] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:userNameLabel];
		[userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userPhotoView.mas_right).offset(20);
			make.bottom.equalTo(userPhotoView.mas_centerY).offset(-3);
		}];
		
		FBActionLabel = [Tools creatLabelWithText:@"Accept OR Reject" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:FBActionLabel];
		[FBActionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userNameLabel.mas_right).offset(5);
			make.centerY.equalTo(userNameLabel);
		}];
		
		serviceTitleLabel = [Tools creatLabelWithText:@"The service's title" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:1];
		[self addSubview:serviceTitleLabel];
		[serviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(userPhotoView.mas_centerY).offset(3);
			make.left.equalTo(userNameLabel);
		}];
		
		UIView *lineView = [UIView new];
		lineView.backgroundColor = [Tools garyLineColor];
		[self addSubview:lineView];
		[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.bottom.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - margin * 2, 0.5));
		}];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"AppliFBCell", @"AppliFBCell");
	
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

- (id)setCellInfo:(id)args {
	
	NSDictionary *order_info = args;
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *prefix = cmd.route;
	NSString *photo_name = [[order_info objectForKey:@"owner"] objectForKey:kAYProfileArgsScreenPhoto];
	if (photo_name) {
		[userPhotoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, photo_name]]
						 placeholderImage:IMGRESOURCE(@"default_user")];
	}
	
	NSNumber *status = [order_info objectForKey:kAYOrderArgsStatus];
	NSString *actionStr = @"FeedBack Info";
	if (status.intValue == OrderStatusAccepted) {
		actionStr = @"已接受";
	} else if (status.intValue == OrderStatusReject) {
		actionStr = @"已拒绝";
	}
	FBActionLabel.text = actionStr;
	
	userNameLabel.text = [[order_info objectForKey:@"owner"] objectForKey:kAYProfileArgsScreenName];
	
	NSString *compName = [Tools serviceCompleteNameFromSKUWith:[order_info objectForKey:@"service"]];
	serviceTitleLabel.text = [NSString stringWithFormat:@"您的%@申请", compName];
	
	return nil;
}

@end
