//
//  AYRemindDateHeaderView.m
//  BabySharing
//
//  Created by Alfred Yang on 5/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYRemindDateHeaderView.h"

@implementation AYRemindDateHeaderView {
	UILabel *dateLabel;
	UILabel *hoursLabel;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
		
//		self.backgroundView.backgroundColor = [Tools whiteColor];
		self.contentView.backgroundColor = [Tools whiteColor];
		
		dateLabel = [Tools creatLabelWithText:@"2017-01-01" textColor:[Tools black] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:dateLabel];
		[dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self).offset(20);
		}];

		hoursLabel =  [Tools creatLabelWithText:@"00:00-00:00" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:hoursLabel];
		[hoursLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(self).offset(-20);
		}];
		
		[Tools addBtmLineWithMargin:10.f andAlignment:NSTextAlignmentCenter andColor:[Tools garyLineColor] inSuperView:self];
		
	}
	return self;
}


- (void)setCellInfo:(NSDictionary *)cellInfo {
	_cellInfo = cellInfo;
	
	NSTimeInterval start = ((NSNumber*)[cellInfo objectForKey:@"start"]).longValue * 0.001;
	NSTimeInterval end = ((NSNumber*)[cellInfo objectForKey:@"end"]).longValue * 0.001;
	NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start];
	NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end];
	
	NSDateFormatter *formatterDay = [Tools creatDateFormatterWithString:@"yyyy年MM月dd日"];
	NSString *dayStr = [formatterDay stringFromDate:startDate];
	
	NSDateFormatter *formatterTime = [Tools creatDateFormatterWithString:@"HH:mm"];
	NSString *startStr = [formatterTime stringFromDate:startDate];
	NSString *endStr = [formatterTime stringFromDate:endDate];
	
	dateLabel.text = dayStr;
	hoursLabel.text = [NSString stringWithFormat:@"%@ - %@", startStr, endStr];
	
}


@end
