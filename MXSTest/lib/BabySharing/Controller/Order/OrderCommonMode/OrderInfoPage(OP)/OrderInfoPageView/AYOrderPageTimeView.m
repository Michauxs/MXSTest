//
//  AYOrderPageTimeView.m
//  BabySharing
//
//  Created by Alfred Yang on 17/1/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYOrderPageTimeView.h"

@implementation AYOrderPageTimeView {
	UILabel *dateLabel;
	UILabel *timeLabel;
}

- (instancetype)init {
	if (self = [super init]) {
		
		self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 85);
		self.backgroundColor = [Tools whiteColor];
		
		CGFloat margin = 10.f;
		[Tools creatCALayerWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - margin * 2, 0.5) andColor:[Tools garyLineColor] inSuperView:self];
		
		dateLabel =  [Tools creatLabelWithText:@"Service Date" textColor:[Tools black] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:dateLabel];
		[dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.top.equalTo(self).offset(20);
		}];
		
		timeLabel =  [Tools creatLabelWithText:@"Service Time" textColor:[Tools theme] fontSize:16.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:timeLabel];
		[timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(15);
			make.top.equalTo(dateLabel.mas_bottom).offset(10);
		}];
		
	}
	return self;
}

- (void)setArgs:(NSDictionary *)args {
	_args = args;
	
	NSNumber *start = [args objectForKey:kAYServiceArgsStart];
	NSNumber *end = [args objectForKey:kAYServiceArgsEnd];
	
	NSDateFormatter *format = [Tools creatDateFormatterWithString:@"yyyy-MM-dd, EEEE"];
	NSDateFormatter *format_time = [Tools creatDateFormatterWithString:@"HH:mm"];
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start.doubleValue * 0.001];
	NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end.doubleValue * 0.001];
	
	NSString *dateStr = [format stringFromDate:startDate];
	dateLabel.text = dateStr;
	
	NSString *startStr = [format_time stringFromDate:startDate];
	NSString *endStr = [format_time stringFromDate:endDate];
	timeLabel.text = [NSString stringWithFormat:@"%@ - %@", startStr, endStr];
}

@end
