//
//  AYOTMHistoryCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 9/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOTMHistoryCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYOTMHistoryCellView {
	
	UILabel *mouthLabel;
	UILabel *dayLabel;
	
	UIImageView *photoIcon;
	UILabel *titleLabel;
	UILabel *dateLabel;
	UILabel *positionLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		CGFloat marginLeft = 65.f;
		UIView *leftLineView = [[UIView alloc] init];
		leftLineView.backgroundColor = [Tools garyLineColor];
		[self addSubview:leftLineView];
		[leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(marginLeft);
			make.top.equalTo(self);
			make.bottom.equalTo(self);
			make.width.mas_equalTo(1);
		}];
		
		UIView *pointSignView = [UIView new];
		[Tools setViewBorder:pointSignView withRadius:5.f andBorderWidth:0.f andBorderColor:nil andBackground:[Tools garyLineColor]];
		[self addSubview:pointSignView];
		[pointSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(leftLineView);
			make.top.equalTo(self);
			make.size.mas_equalTo(CGSizeMake(10, 10));
		}];
		
		mouthLabel = [Tools creatLabelWithText:@"01月" textColor:[Tools garyColor] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:mouthLabel];
		[mouthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(marginLeft * 0.5);
			make.top.equalTo(self);
		}];
		
		dayLabel = [Tools creatLabelWithText:@"01" textColor:[Tools black] fontSize:616.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:dayLabel];
		[dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(mouthLabel.mas_bottom).offset(3);
			make.centerX.equalTo(mouthLabel);
		}];
		
		UIImageView *bgView = [[UIImageView alloc] init];
		UIImage *bg = IMGRESOURCE(@"otm_history_bg");
		bg = [bg resizableImageWithCapInsets:UIEdgeInsetsMake(20, 15, 10, 10) resizingMode:UIImageResizingModeStretch];
		bgView.image = bg;
		[self addSubview:bgView];
		[bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 75, 25, 25));
		}];
		
		CGFloat photoImageWidth = 45.f;
		photoIcon = [[UIImageView alloc]init];
		photoIcon.image = IMGRESOURCE(@"default_user");
		photoIcon.contentMode = UIViewContentModeScaleAspectFill;
		photoIcon.layer.cornerRadius = 2.f;
		photoIcon.layer.borderColor = [Tools borderAlphaColor].CGColor;
		photoIcon.layer.borderWidth = 1.f;
		photoIcon.clipsToBounds = YES;
		photoIcon.layer.rasterizationScale = [UIScreen mainScreen].scale;
		[self addSubview:photoIcon];
		[photoIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(bgView).offset(-15);
			make.top.equalTo(bgView).offset(15);
			make.size.mas_equalTo(CGSizeMake(photoImageWidth, photoImageWidth));
		}];
		
		titleLabel = [Tools creatLabelWithText:@"service title" textColor:[Tools whiteColor] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(15);
			make.left.equalTo(bgView).offset(20);
			make.right.equalTo(photoIcon.mas_left).offset(-5);
		}];
		
		UIImageView *olockIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"otm_history_time")];
		[self addSubview:olockIcon];
		[olockIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(bgView).offset(20);
			make.top.equalTo(titleLabel.mas_bottom).offset(15);
			make.size.mas_equalTo(CGSizeMake(10, 10));
		}];
		
		dateLabel = [Tools creatLabelWithText:@"00:00 - 00:00" textColor:[Tools whiteColor] fontSize:13.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		dateLabel.numberOfLines = 0;
		[self addSubview:dateLabel];
		[dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(olockIcon).offset(0);
			make.left.equalTo(bgView).offset(35);
		}];
		
		UIImageView *positionIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"otm_history_position")];
		[self addSubview:positionIcon];
		[positionIcon mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(olockIcon);
			make.top.equalTo(olockIcon.mas_bottom).offset(15);
			make.size.mas_equalTo(CGSizeMake(8, 10));
		}];
		
		positionLabel = [Tools creatLabelWithText:@"service position address info" textColor:[Tools whiteColor] fontSize:13.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		positionLabel.numberOfLines = 2;
		[self addSubview:positionLabel];
		[positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(positionIcon.mas_centerY).offset(-10);
			make.left.equalTo(dateLabel);
			make.right.equalTo(photoIcon);
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
	id<AYViewBase> cell = VIEW(@"OTMHistoryCell", @"OTMHistoryCell");
	
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
	NSString *prefix = cmd.route;
	NSString *photo_name = [order_info objectForKey:kAYOrderArgsThumbs];
	[photoIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, photo_name]]
				 placeholderImage:IMGRESOURCE(@"default_user")];
	
	NSString *compName = [order_info objectForKey:kAYOrderArgsTitle];
	NSString *userName = [[order_info objectForKey:@"owner"] objectForKey:kAYProfileArgsScreenName];
	titleLabel.text = [NSString stringWithFormat:@"%@的%@", userName, compName];
	
	NSDictionary *info_location = [order_info objectForKey:kAYServiceArgsLocationInfo];
	NSString *addrStr = [info_location objectForKey:kAYServiceArgsAddress];
	if (addrStr.length != 0) {
		positionLabel.text = addrStr;
	}
	
	NSTimeInterval start = ((NSNumber*)[args objectForKey:@"start"]).longValue * 0.001;
	NSTimeInterval end = ((NSNumber*)[args objectForKey:@"end"]).longValue * 0.001;
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start];
	NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end];
	
	NSDateFormatter *formatterM = [Tools creatDateFormatterWithString:@"M月"];
	NSString *mouthStr = [formatterM stringFromDate:startDate];
	mouthLabel.text = mouthStr;
	
	NSDateFormatter *formatterD = [Tools creatDateFormatterWithString:@"dd"];
	NSString *dayStr = [formatterD stringFromDate:startDate];
	dayLabel.text = dayStr;
	
	NSDateFormatter *formatterTime = [Tools creatDateFormatterWithString:@"HH:mm"];
	NSString *startStr = [formatterTime stringFromDate:startDate];
	NSString *endStr = [formatterTime stringFromDate:endDate];
	dateLabel.text = [NSString stringWithFormat:@"%@ - %@", startStr, endStr];
	
	return nil;
}

@end
