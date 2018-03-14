//
//  AYServiceFacilityCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceFacilityCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYPlayItemsView.h"

@implementation AYServiceFacilityCellView {
	UILabel *titleLabel;
	NSMutableArray *facilityArr;
	UIScrollView *ScrollView;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;


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

#pragma mark -- life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.clipsToBounds = YES;
		
		titleLabel = [UILabel creatLabelWithText:@"场地安全友好性" textColor:[UIColor black13] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
			make.top.equalTo(self).offset(20);
			make.bottom.equalTo(self).offset(-100);
		}];
		
		ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, 62)];
		ScrollView.showsVerticalScrollIndicator = NO;
		ScrollView.showsHorizontalScrollIndicator = NO;
		[self addSubview:ScrollView];
		
		UIImageView *mask = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"mask_detail_facility")];
		[self addSubview:mask];
		[mask mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(ScrollView);
			make.centerY.equalTo(ScrollView);
			make.size.mas_equalTo(CGSizeMake(20, 76));
		}];
		
		UIView *bottom_view = [[UIView alloc] init];
		bottom_view.backgroundColor = [UIColor garyLine];
		[self addSubview:bottom_view];
		[bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
			make.right.equalTo(self).offset(-SERVICEPAGE_MARGIN_LR);
			make.bottom.equalTo(self);
			make.height.mas_equalTo(0.5);
		}];
    }
    return self;
}

#pragma mark -- actions
- (void)didFacalityBtnClick {
    kAYViewSendNotify(self, @"showCansOrFacility", nil)
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	NSDictionary *service_info = args;
	NSArray *facilities = [[service_info objectForKey:kAYServiceArgsLocationInfo] objectForKey:@"friendliness"];;
	NSArray *detail_imgs_name = kAY_service_options_title_facilities;
	
	CGFloat itemHeight = 62;
	CGFloat lineSpacing = 38;
	CGFloat preMaxX = 0;
	
	for (int i = 0; i < facilities.count; ++i) {
		
		NSString *title = [facilities objectAtIndex:i];
		int index = (int)[detail_imgs_name indexOfObject:title];
		
		AYPlayItemsView *facilityItem = [[AYPlayItemsView alloc] initWithTitle:title andIconName:[NSString stringWithFormat:@"detail_facility_%d", index]];
		[ScrollView addSubview:facilityItem];
		CGSize labelSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
		facilityItem.frame = CGRectMake((i==0?SERVICEPAGE_MARGIN_LR:lineSpacing) + preMaxX, 0, labelSize.width, itemHeight);
		
		preMaxX = facilityItem.frame.origin.x + labelSize.width;
	}
	ScrollView.contentSize = CGSizeMake(preMaxX+25, itemHeight);
	
//	NSString *service_cat = [service_info objectForKey:kAYServiceArgsCat];
//	if ([service_cat isEqualToString:kAYStringNursery]) {
//		
//	}
//	else if ([service_cat isEqualToString:kAYStringCourse]) {
//		titleLabel.text = @"";
//		[titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//			make.left.equalTo(self).offset(20);
//			make.top.equalTo(self).offset(0.001);
//			make.bottom.equalTo(self).offset(-0.001);
//			make.height.mas_equalTo(0.001);
//		}];
//		
//		ScrollView.frame = CGRectMake(0, 0, 0, 0);
//	} else {
//	
//	}
	
    return nil;
}

@end
