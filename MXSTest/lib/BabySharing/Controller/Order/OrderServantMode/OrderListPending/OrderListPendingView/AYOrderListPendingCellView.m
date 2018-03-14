//
//  AYOrderListPendingCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 18/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderListPendingCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYOrderListPendingCellView {
	
	UIImageView *photoIcon;
	UILabel *titleLabel;
	UILabel *orderNoLabel;
//	UILabel *paymentInfoLabel;
//	UILabel *stateLabel;
	UILabel *userNameLabel;
	
	NSDictionary *service_info;
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor clearColor];
		//		[Tools creatCALayerWithFrame:CGRectMake(0, 99.5, SCREEN_WIDTH, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
		CGFloat photoImageWidth = 45.f;
		
		photoIcon = [[UIImageView alloc]init];
		photoIcon.image = IMGRESOURCE(@"default_user");
		photoIcon.contentMode = UIViewContentModeScaleAspectFill;
		photoIcon.layer.cornerRadius = photoImageWidth * 0.5;
		photoIcon.layer.borderColor = [Tools borderAlphaColor].CGColor;
		photoIcon.layer.borderWidth = 2.f;
		photoIcon.clipsToBounds = YES;
		photoIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
		[self addSubview:photoIcon];
		[photoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.centerY.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(photoImageWidth, photoImageWidth));
		}];
		//	photoIcon.userInteractionEnabled = YES;
		//	[photoIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
		
		titleLabel = [Tools creatLabelWithText:@"Servant's Service With Theme" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(photoIcon.mas_right).offset(20);
			make.centerY.equalTo(photoIcon);
		}];
		
		userNameLabel = [Tools creatLabelWithText:@"Order NO:" textColor:[Tools black] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:userNameLabel];
		[userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.bottom.equalTo(titleLabel.mas_top).offset(-3);
		}];
		
		orderNoLabel = [Tools creatLabelWithText:@"Order NO:" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:orderNoLabel];
		[orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(3);
		}];
		
		[Tools addBtmLineWithMargin:10.f andAlignment:NSTextAlignmentCenter andColor:[Tools garyLineColor] inSuperView:self];
		
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
	id<AYViewBase> cell = VIEW(@"OrderListPendingCell", @"OrderListPendingCell");
	
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
	
	NSDictionary *order_info = [args objectForKey:kAYOrderArgsSelf];
	
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *pre = cmd.route;
	
	NSString *photo_name = [[order_info objectForKey:@"user"] objectForKey:@"screen_photo"];
	[photoIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", pre, photo_name]]
				 placeholderImage:IMGRESOURCE(@"default_user")];
	
	
	NSString *orderID = [order_info objectForKey:kAYOrderArgsID];
	if (orderID) {
		orderID = [Tools Bit64String:orderID];
		orderNoLabel.text = [NSString stringWithFormat:@"订单号 %@", orderID];
	}
	
	NSString *userName = [[order_info objectForKey:@"user"] objectForKey:kAYProfileArgsScreenName];
	userNameLabel.text = userName;
	
	NSString *orderTitle = [order_info objectForKey:kAYOrderArgsTitle];
	titleLabel.text = orderTitle;
	
	return nil;
}

@end
