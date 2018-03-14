//
//  AYOrderInfoPageCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 13/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderPageHeadCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYOrderPageTimeView.h"

#define POSITIONHEIGHT			55

@implementation AYOrderPageHeadCellView {
	
//	UIImageView *photoIcon;
	UILabel *titleLabel;
	UILabel *orderNoLabel;
	UILabel *addressLabel;
//	UILabel *sumPriceLabel;
//	UILabel *unitPriceLabel;
	
	NSDictionary *service_info;
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		titleLabel = [Tools creatLabelWithText:@"Servant's Service With Theme" textColor:[Tools black] fontSize:317.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.top.equalTo(self).offset(15);
		}];
		
		orderNoLabel = [Tools creatLabelWithText:@"Order NO" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:orderNoLabel];
		[orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(15);
		}];
		
		/*******************************/
		
		UIView *line_b_address_date = [[UIView alloc]init];
		line_b_address_date.backgroundColor = [Tools garyLineColor];
		[self addSubview:line_b_address_date];
		[line_b_address_date mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self).offset(-POSITIONHEIGHT+0.5);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
		}];
		
		UIImageView *positionImage = [[UIImageView alloc]init];
		[self addSubview:positionImage];
		positionImage.image = IMGRESOURCE(@"location_icon");
		[positionImage mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel).offset(0);
			make.centerY.equalTo(self.mas_bottom).offset(-POSITIONHEIGHT*0.5);
			make.size.mas_equalTo(CGSizeMake(13, 13));
		}];
		
		addressLabel = [Tools creatLabelWithText:@"Services position address info" textColor:[Tools black] fontSize:13.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:addressLabel];
		[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(positionImage.mas_right).offset(15);
			make.centerY.equalTo(positionImage);
			make.right.equalTo(self).offset(-15);
		}];
		
		UIView *line_btm = [[UIView alloc]init];
		line_btm.backgroundColor = [Tools garyLineColor];
		[self addSubview:line_btm];
		[line_btm mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
		}];
		
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
	id<AYViewBase> cell = VIEW(@"OrderPageHeadCell", @"OrderPageHeadCell");
	
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
	
	NSDictionary *order_info = (NSDictionary*)args;
	service_info = [order_info objectForKey:@"service"];
	
	NSString *ownerName = [[order_info objectForKey:@"owner"] objectForKey:kAYProfileArgsScreenName];
	
	NSDictionary *info_montage = [Tools montageServiceInfoWithServiceData:service_info];
	
	NSString *montageName = [info_montage objectForKey:@"montage"];
	titleLabel.text = [NSString stringWithFormat:@"%@的%@", ownerName, montageName];
	
	NSString *orderID = [order_info objectForKey:@"order_id"];
	orderID = [Tools Bit64String:orderID];
	orderNoLabel.text = [NSString stringWithFormat:@"订单号 %@", orderID];
	
	NSString *addressStr = [[service_info objectForKey:kAYServiceArgsLocationInfo] objectForKey:kAYServiceArgsAddress];
	NSString *stringPre = @"中国北京市";
	if ([addressStr hasPrefix:stringPre]) {
		addressStr = [addressStr stringByReplacingOccurrencesOfString:stringPre withString:@""];
	}
	if (addressStr && ![addressStr isEqualToString:@""]) {
		addressLabel.text = addressStr;
	}
	
	id order_date = [order_info objectForKey:@"order_date"];
	if ( [order_date isKindOfClass:[NSArray class]]) {
		for (int i = 0; i < ((NSArray*)order_date).count; ++i) {
			AYOrderPageTimeView *timeView = [[AYOrderPageTimeView alloc]init];
			timeView.args = [((NSArray*)order_date) objectAtIndex:i];
			[self addSubview:timeView];
			[timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(orderNoLabel.mas_bottom).offset(20+85*i);
				make.centerX.equalTo(self);
				make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 85));
			}];
		}
	} else /*if ( [tmp isKindOfClass:[NSDictionary class]]) */{
		AYOrderPageTimeView *timeView = [[AYOrderPageTimeView alloc]init];
		timeView.args = order_date;
		[self addSubview:timeView];
		[timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(orderNoLabel.mas_bottom).offset(20);
			make.centerX.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 85));
		}];
	}
	
	return nil;
}

@end
