//
//  AYServiceThemeCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceCapacityCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYPlayItemsView.h"

@implementation AYServiceCapacityCellView {
	
	AYCapacityUnitView *classView;
	AYCapacityUnitView *ageView;
	AYCapacityUnitView *teacherView;
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
		
		//age_boundary_icon
		ageView = [[AYCapacityUnitView alloc] initWithIcon:@"details_icon_ages" title:@"适合年龄" info:@"0"];
		[self addSubview:ageView];
		[ageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self);
			make.top.equalTo(self).offset(18);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/3, 73));
			make.bottom.equalTo(self).offset(-17);
		}];
		
		//capacity_icon
		classView = [[AYCapacityUnitView alloc] initWithIcon:@"details_icon_classmax" title:@"班级人数" info:@"0"];
		[self addSubview:classView];
		[classView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(ageView.mas_right);
			make.top.equalTo(ageView);
			make.size.equalTo(ageView);
		}];
		
		//allow_leave_icon
		teacherView = [[AYCapacityUnitView alloc] initWithIcon:@"details_icon_teacher" title:@"师生配比" info:@"0"];
		[self addSubview:teacherView];
		[teacherView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(classView.mas_right);
			make.top.equalTo(ageView);
			make.size.equalTo(ageView);
		}];
		
		UIView *bottom_view = [[UIView alloc] init];
		bottom_view.backgroundColor = [UIColor garyLine];
		[self addSubview:bottom_view];
		[bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.right.equalTo(self).offset(-SCREEN_MARGIN_LR);
			make.bottom.equalTo(self);
			make.height.mas_equalTo(0.5);
		}];
		
    }
    return self;
}

#pragma mark -- actions


#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	NSDictionary *service_info = args;
	[ageView info:args atIndex:0];
	[classView info:args atIndex:1];
	[teacherView info:args atIndex:2];
	
	int class = [[service_info objectForKey:@"class_max_stu"] intValue];
	int teacher = [[service_info objectForKey:@"teacher_num"] intValue];
	
	if ( teacher <= 0) {	//no teacher
		if (class <= 0) {	//no class
			[ageView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.size.mas_equalTo(CGSizeMake(101, 73));
			}];
			classView.hidden = teacherView.hidden = YES;
		} else {
			[ageView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.5, 73));
			}];
			[classView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.size.equalTo(ageView);
			}];
			teacherView.hidden = YES;
		}
	} else {	//have teacher
		if (class <= 0) {	//no class
			
		} else {	//have class
			
		}
	}
    return nil;
}

@end
