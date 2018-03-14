//
//  AYOSEstabCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 11/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOSEstabCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYOSEstabCellView {
	
	UIImageView *photoIcon;
	UILabel *titleLabel;
	UILabel *stateLabel;
	UILabel *orderNoLabel;
	UILabel *dateLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.backgroundColor = [UIColor clearColor];
		
//		UIImageView *bgView= [[UIImageView alloc]init];
//		UIImage *bgImg = IMGRESOURCE(@"map_match_bg");
//		bgImg = [bgImg resizableImageWithCapInsets:UIEdgeInsetsMake(50, 100, 10, 10) resizingMode:UIImageResizingModeStretch];
//		bgView.image = bgImg;
//		[self addSubview:bgView];
//		[bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, -2.5, 10, -2.5));
//		}];
		
		photoIcon = [[UIImageView alloc]init];
		photoIcon.image = IMGRESOURCE(@"default_user");
		photoIcon.contentMode = UIViewContentModeScaleAspectFill;
		photoIcon.layer.cornerRadius = 5;
		photoIcon.layer.borderColor = [Tools borderAlphaColor].CGColor;
		photoIcon.layer.borderWidth = 2.f;
		photoIcon.clipsToBounds = YES;
		photoIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
		[self addSubview:photoIcon];
		[photoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-30);
			make.centerY.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(45, 45));
		}];
		//	photoIcon.userInteractionEnabled = YES;
		//	[photoIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ownerIconTap:)]];
		
		orderNoLabel = [Tools creatLabelWithText:nil textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:orderNoLabel];
		[orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self).offset(20);
		}];
		
		titleLabel = [Tools creatLabelWithText:@"Servant's Service With Theme" textColor:[Tools black] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(20);
			make.bottom.equalTo(orderNoLabel.mas_top).offset(-5);
		}];
		
		stateLabel = [Tools creatLabelWithText:@"" textColor:[Tools theme] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:stateLabel];
		[stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(orderNoLabel.mas_bottom).offset(5);
		}];
		
		
//		dateLabel = [Tools creatUILabelWithText:@"01-01 00:00-00:00" andTextColor:[Tools blackColor] andFontSize:13.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
//		[self addSubview:dateLabel];
//		[dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.left.equalTo(orderNoLabel);
//			make.top.equalTo(orderNoLabel.mas_bottom).offset(10);
//		}];
		
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
	id<AYViewBase> cell = VIEW(@"OSEstabCell", @"OSEstabCell");
	
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
	NSString *photo_name = [order_info objectForKey:kAYOrderArgsThumbs];
	[photoIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, photo_name]]
						 placeholderImage:IMGRESOURCE(@"default_user")];
	
	NSString *orderID = [order_info objectForKey:kAYOrderArgsID];
	if (orderID && ![orderID isEqualToString:@""]) {
		orderID = [Tools Bit64String:orderID];
		orderNoLabel.text = [NSString stringWithFormat:@"订单号 %@", orderID];
	}
	
//	NSDictionary *service_info = [order_info objectForKey:kAYServiceArgsSelf];
//	NSString *completeTheme = [Tools serviceCompleteNameFromSKUWith:service_info];
	NSString *orderTitle = [order_info objectForKey:kAYOrderArgsTitle];
	NSString *aplyName = [[order_info objectForKey:@"owner"] objectForKey:kAYProfileArgsScreenName];
	NSString *titleStr = [NSString stringWithFormat:@"%@的%@", aplyName, orderTitle];
	titleLabel.text = titleStr;
	
	OrderStatus OrderStatus = ((NSNumber*)[order_info objectForKey:@"status"]).intValue;
	switch (OrderStatus) {
		case OrderStatusPosted:{
			stateLabel.text = @"待确认";
		}
			break;
		case OrderStatusAccepted:
		{
			stateLabel.text = @"已接受";
		}
			break;
		case OrderStatusReject:
		{
			stateLabel.text = @"已拒绝";
		}
			break;
		case OrderStatusPaid:
		{
			stateLabel.text = @"已确认";
		}
			break;
		case OrderStatusCancel:
		{
			stateLabel.text = @"已取消";
		}
			break;
		case OrderStatusDone:
		{
			stateLabel.text = @"已完成";
		}
			break;
		default:
			break;
	}
	return nil;
}

@end
