//
//  AYOrderNewsreelCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 10/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderNewsreelCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

@implementation AYOrderNewsreelCellView {
	
	UILabel *dateLabel;
	
	UIView *pointSignView;
	UILabel *titleLabel;
	UIImageView *photoIcon;
	
	UIImageView *startTimeIcon;
	UILabel *startTimeLabel;
	UIImageView *endTimeIcon;
	UILabel *endTimeLabel;
	
	UIImageView *positionIcon;
	UILabel *positionLabel;
	
	/*****/
	UIImageView *remindOlockIcon;
	UILabel *remindLabel;
	
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
			make.top.equalTo(self).offset(10);
			make.bottom.equalTo(self).offset(10);
			make.width.mas_equalTo(1);
		}];
		
		pointSignView = [UIView new];
		[Tools setViewBorder:pointSignView withRadius:5.f andBorderWidth:0.f andBorderColor:nil andBackground:[Tools garyLineColor]];
		[self addSubview:pointSignView];
		[pointSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(leftLineView);
			make.top.equalTo(leftLineView);
			make.size.mas_equalTo(CGSizeMake(10, 10));
		}];
		
		dateLabel = [Tools creatLabelWithText:@"今天" textColor:[Tools black] fontSize:318.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:dateLabel];
		[dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self.mas_left).offset(marginLeft * 0.5);
			make.centerY.equalTo(pointSignView);
		}];
		
		titleLabel = [Tools creatLabelWithText:@"service title" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(marginLeft+15);
			make.centerY.equalTo(pointSignView);
			make.right.equalTo(self).offset(-45-40-5);
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
			make.right.equalTo(self).offset(-40);
			make.top.equalTo(titleLabel);
			make.size.mas_equalTo(CGSizeMake(photoImageWidth, photoImageWidth));
		}];
		
		remindOlockIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"remind_olock")];
		[self addSubview:remindOlockIcon];
		remindLabel = [Tools creatLabelWithText:@"Remind message" textColor:[Tools theme] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:remindLabel];
		
		startTimeIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"remind_time")];
		[self addSubview:startTimeIcon];
		startTimeLabel = [Tools creatLabelWithText:@"00:00 Start Olcok" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:startTimeLabel];
		
		endTimeIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"remind_time")];
		[self addSubview:endTimeIcon];
		endTimeLabel = [Tools creatLabelWithText:@"00:00 End Olcok" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:endTimeLabel];
		
		positionIcon = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"remind_position")];
		[self addSubview:positionIcon];
		positionLabel = [Tools creatLabelWithText:@"service position address info" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		positionLabel.numberOfLines = 2;
		[self addSubview:positionLabel];
		
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
	id<AYViewBase> cell = VIEW(@"OrderNewsreelCell", @"OrderNewsreelCell");
	
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
	NSTimeInterval nowNode = [NSDate date].timeIntervalSince1970;
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
	if (addrStr && ![addrStr isEqualToString:@""]) {
		positionLabel.text = addrStr;
	}
	
	NSTimeInterval start = ((NSNumber*)[args objectForKey:@"start"]).longValue * 0.001;
	NSTimeInterval end = ((NSNumber*)[args objectForKey:@"end"]).longValue * 0.001;
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start];
	NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end];
	
	NSDateFormatter *formatterTime = [Tools creatDateFormatterWithString:@"HH:mm"];
	NSString *startStr = [formatterTime stringFromDate:startDate];
	NSString *endStr = [formatterTime stringFromDate:endDate];
	startTimeLabel.text = [NSString stringWithFormat:@"%@ 开始时间", startStr];
	endTimeLabel.text = [NSString stringWithFormat:@"%@ 结束时间", endStr];
	
	if (nowNode < start) { //未开始
		[self setWillBeginConstraints];
	}
	else if(nowNode >= start && nowNode < end) { //进行中
		[self setIsOngoingConstraints];
	}
	else if(nowNode > end) { //结束
		[self setWasEndConstraints];
	}
	else {
		[self setOnErrorConstraints];
	}
	
	
	[positionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(positionIcon.mas_centerY).offset(-10);
		make.left.equalTo(titleLabel);
		make.right.equalTo(photoIcon);
	}];
	[endTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(endTimeIcon);
		make.left.equalTo(titleLabel);
	}];
	[startTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(startTimeIcon);
		make.left.equalTo(titleLabel);
	}];
	[remindLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(remindOlockIcon);
		make.left.equalTo(titleLabel);
	}];
	
	return nil;
}

- (void)setWillBeginConstraints {
	[remindOlockIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(pointSignView.mas_bottom).offset(15);
		make.centerX.equalTo(pointSignView);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	remindLabel.text = @"课程即将开始，请合理安排日程";
	
	[startTimeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(remindOlockIcon.mas_bottom).offset(15);
		make.centerX.equalTo(pointSignView);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	[endTimeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(startTimeIcon.mas_bottom).offset(15);
		make.centerX.equalTo(pointSignView);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	
	[positionIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(pointSignView);
		make.top.equalTo(endTimeIcon.mas_bottom).offset(15);
		make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
	}];
}

- (void)setIsOngoingConstraints {
	[startTimeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(pointSignView.mas_bottom).offset(15);
		make.centerX.equalTo(pointSignView);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	[remindOlockIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(startTimeIcon.mas_bottom).offset(15);
		make.centerX.equalTo(pointSignView);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	remindLabel.text = @"服务正在进行";
	
	[endTimeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(remindOlockIcon.mas_bottom).offset(15);
		make.centerX.equalTo(pointSignView);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	
	[positionIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(pointSignView);
		make.top.equalTo(endTimeIcon.mas_bottom).offset(15);
		make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
	}];
}

- (void)setWasEndConstraints {
	[startTimeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(pointSignView.mas_bottom).offset(15);
		make.centerX.equalTo(pointSignView);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	[endTimeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(startTimeIcon.mas_bottom).offset(15);
		make.centerX.equalTo(pointSignView);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	
	[remindOlockIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(endTimeIcon.mas_bottom).offset(15);
		make.centerX.equalTo(pointSignView);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	remindLabel.text = @"课程已结束，欢迎再次光顾";
	
	[positionIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(pointSignView);
		make.top.equalTo(remindOlockIcon.mas_bottom).offset(15);
		make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
	}];
}

- (void)setOnErrorConstraints {
	[remindOlockIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(pointSignView.mas_bottom).offset(15);
		make.centerX.equalTo(pointSignView);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	remindLabel.text = @"服务时间出现未知错误，请重新核实";
	
	[startTimeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(remindOlockIcon.mas_bottom).offset(15);
		make.centerX.equalTo(pointSignView);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	[endTimeIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(startTimeIcon.mas_bottom).offset(15);
		make.centerX.equalTo(pointSignView);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	
	[positionIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(pointSignView);
		make.top.equalTo(endTimeIcon.mas_bottom).offset(15);
		make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
	}];
}

@end
