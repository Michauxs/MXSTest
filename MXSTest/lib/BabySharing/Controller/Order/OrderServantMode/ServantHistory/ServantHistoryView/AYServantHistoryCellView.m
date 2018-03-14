//
//  AYServantHistoryCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 13/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYServantHistoryCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYServantHistoryCellView {
	
	UIImageView *userPhotoView;
	UILabel *userNameLabel;
	UILabel *serviceTitleLabel;
	UILabel *statesLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor whiteColor];
		
		CGFloat imageWidth = 45.f;
		CGFloat margin = 10.f;
//		[Tools creatCALayerWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - margin*2, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
		userPhotoView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"default_user")];
		[Tools setViewBorder:userPhotoView withRadius:imageWidth * 0.5 andBorderWidth:2.f andBorderColor:[Tools borderAlphaColor] andBackground:nil];
		[self addSubview:userPhotoView];
		[userPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self).offset(-10);
			make.left.equalTo(self).offset(20);
			make.size.mas_equalTo(CGSizeMake(imageWidth, imageWidth));
		}];
		
		userNameLabel = [Tools creatLabelWithText:@"User Name" textColor:[Tools black] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:userNameLabel];
		[userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userPhotoView.mas_right).offset(20);
			make.bottom.equalTo(userPhotoView.mas_centerY);
		}];
		
		UILabel *startTitleLabel = [Tools creatLabelWithText:@"申请预定" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:startTitleLabel];
		[startTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userNameLabel.mas_right).offset(5);
			make.centerY.equalTo(userNameLabel);
		}];
		
		serviceTitleLabel = [Tools creatLabelWithText:@"The service's title" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:1];
		[self addSubview:serviceTitleLabel];
		[serviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(userPhotoView.mas_centerY);
			make.left.equalTo(userNameLabel);
		}];
		
		statesLabel = [Tools creatLabelWithText:@"申请状态" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:statesLabel];
		[statesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(serviceTitleLabel.mas_bottom).offset(3);
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

- (void)layoutSubviews {
	[super layoutSubviews];
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"ServantHistoryCell", @"ServantHistoryCell");
	
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


#pragma mark -- messages
- (id)setCellInfo:(id)args {
	
	NSDictionary *order_info = args;
	
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *prefix = cmd.route;
	NSString *photo_name = [[order_info objectForKey:@"user"] objectForKey:kAYProfileArgsScreenPhoto];
	[userPhotoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, photo_name]]
					 placeholderImage:IMGRESOURCE(@"default_user")];
	
	NSNumber *status = [order_info objectForKey:kAYOrderArgsStatus];
	NSString *actionStr = @"FeedBack Info";
	if (status.intValue == OrderStatusReject) {
		actionStr = @"已拒绝";
	} else if (status.intValue == OrderStatusPaid) {
		actionStr = @"已确认";
	} else if (status.intValue == OrderStatusCancel) {
		actionStr = @"已取消";
	}
	statesLabel.text = actionStr;
	
	userNameLabel.text = [[order_info objectForKey:@"user"] objectForKey:kAYProfileArgsScreenName];
	serviceTitleLabel.text = [order_info objectForKey:kAYOrderArgsTitle];
	
//	NSDictionary *order_info = args;
//	NSString *photo_name = [order_info objectForKey:@"screen_photo"];
//	
//	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//	NSString *PRE = cmd.route;
//	[userPhotoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", PRE, photo_name]]
//					 placeholderImage:IMGRESOURCE(@"default_user")];
//	
//	NSNumber *status = [order_info objectForKey:kAYOrderArgsStatus];
//	NSString *actionStr = @"FeedBack Info";
//	if (status.intValue == OrderStatusReject) {
//		actionStr = @"已拒绝";
//	} else if (status.intValue == OrderStatusPaid) {
//		actionStr = @"已确认";
//	} else if (status.intValue == OrderStatusCancel) {
//		actionStr = @"已取消";
//	}
//	statesLabel.text = actionStr;
//	
//	userNameLabel.text = [order_info objectForKey:kAYProfileArgsScreenName];
//	serviceTitleLabel.text = [[order_info objectForKey:@"service"] objectForKey:kAYServiceArgsTitle];
	
	return nil;
}

@end
