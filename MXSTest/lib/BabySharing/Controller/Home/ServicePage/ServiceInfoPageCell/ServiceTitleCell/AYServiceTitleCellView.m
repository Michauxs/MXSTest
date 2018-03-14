//
//  AYServiceTitleCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceTitleCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

@implementation AYServiceTitleCellView {
    UILabel *titleLabel;
	UILabel *themeLabel;
	UILabel *tagLabel;
	
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
		
		titleLabel = [UILabel creatLabelWithText:@"Service title is not set" textColor:[UIColor gary115] fontSize:20 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(24);
			make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
			make.right.equalTo(self).offset(-SERVICEPAGE_MARGIN_LR);
		}];
		
		themeLabel = [UILabel creatLabelWithText:@"Theme" textColor:[UIColor black13] fontSize:618 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview: themeLabel];
		[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(16);
		}];
		
		tagLabel = [UILabel creatLabelWithText:@"TAG" textColor:[UIColor tag] fontSize:616.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview: tagLabel];
		[tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(themeLabel.mas_bottom).offset(0);
			make.bottom.equalTo(self).offset(-24);
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

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
	
    NSDictionary *service_info = (NSDictionary*)args;
	
	NSString *service_cat = [service_info objectForKey:kAYServiceArgsCat];
	NSString *service_type = [service_info objectForKey:kAYServiceArgsType];
	NSString *service_leaf = [service_info objectForKey:kAYServiceArgsLeaf];
	
	NSString *themeStr;
	if ([service_cat isEqualToString:kAYStringNursery]) {
		themeStr = service_leaf;
		
	} else if ([service_cat isEqualToString:kAYStringCourse]) {
		themeStr = [NSString stringWithFormat:@"%@·%@%@", service_type, service_leaf, kAYStringCourse];
		
	} else {
		themeStr = @"服务·主题";
	}
	
	themeLabel.text = themeStr;
	
	
	NSString *titleStr = [service_info objectForKey:kAYServiceArgsPunchline];
	if (titleStr.length != 0) {
		titleLabel.text = [[@"\"" stringByAppendingString:titleStr] stringByAppendingString:@"\""];
	}
	
	NSString *tag = [[service_info objectForKey:kAYServiceArgsTags] firstObject];
	tagLabel.text = tag;
	
    return nil;
}

@end
