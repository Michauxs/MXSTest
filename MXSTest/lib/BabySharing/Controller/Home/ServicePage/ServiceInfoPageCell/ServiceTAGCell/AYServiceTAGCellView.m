//
//  AYServiceTAGCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYServiceTAGCellView.h"

@implementation AYServiceTAGCellView {
	UILabel *TAGsLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		TAGsLabel = [UILabel creatLabelWithText:@"##" textColor:[UIColor gary] fontSize:316.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:TAGsLabel];
		[TAGsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
			make.top.equalTo(self).offset(18);
			make.bottom.equalTo(self).offset(20);
		}];
	}
	return self;
}

#pragma mark -- life cycle


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
	
//	NSDictionary *service_info = args;

	
	return nil;
}

@end

