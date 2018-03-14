//
//  AYAssortmentListCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAssortmentCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

@implementation AYAssortmentCellView {
	
	UIImageView *coverImage;
	UIButton *likeBtn;
	
	UILabel *themeLabel;
	UILabel *ageBoundaryLabel;
	
	UILabel *titleLabel;
	
	UIImageView *positionSignView;
	UILabel *addressLabel;
	UILabel *priceLabel;
	
	NSDictionary *service_info;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		coverImage = [[UIImageView alloc]init];
		coverImage.image = IMGRESOURCE(@"default_image");
		coverImage.contentMode = UIViewContentModeScaleAspectFill;
		coverImage.layer.cornerRadius = 4.f;
		coverImage.clipsToBounds = YES;
		[self addSubview:coverImage];
		[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(15);
			make.left.equalTo(self).offset(20);
			make.right.equalTo(self).offset(-20);
			make.height.mas_equalTo(223);
		}];
		
		themeLabel = [Tools creatLabelWithText:@"Theme" textColor:[Tools theme] fontSize:611.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[Tools setViewBorder:themeLabel withRadius:4.f andBorderWidth:1.f andBorderColor:[Tools theme] andBackground:nil];
		[self addSubview:themeLabel];
		[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(coverImage);
			make.top.equalTo(coverImage.mas_bottom).offset(15);
			make.size.mas_equalTo(CGSizeMake(72, 26));
		}];
		
		ageBoundaryLabel = [Tools creatLabelWithText:@"0-0" textColor:[Tools theme] fontSize:611.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[Tools setViewBorder:ageBoundaryLabel withRadius:4.f andBorderWidth:1.f andBorderColor:[Tools theme] andBackground:nil];
		[self addSubview:ageBoundaryLabel];
		[ageBoundaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(themeLabel.mas_right).offset(10);
			make.centerY.equalTo(themeLabel);
			make.size.mas_equalTo(CGSizeMake(60, 26));
		}];
		
		titleLabel = [Tools creatLabelWithText:@"Service Belong to Servant" textColor:[Tools black] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		titleLabel.numberOfLines = 1;
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(coverImage);
			make.right.equalTo(coverImage);
			make.top.equalTo(themeLabel.mas_bottom).offset(15);
		}];
		
		positionSignView = [[UIImageView alloc]init];
		[self addSubview:positionSignView];
		positionSignView.image = IMGRESOURCE(@"home_icon_location");
		[positionSignView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(10);
			make.size.mas_equalTo(CGSizeMake(10, 12));
		}];
		
		addressLabel = [Tools creatLabelWithText:@"Address Info" textColor:[Tools RGB153GaryColor] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:addressLabel];
		[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(positionSignView);
			make.left.equalTo(positionSignView.mas_right).offset(5);
		}];
		
		
		priceLabel = [Tools creatLabelWithText:@"¥Price/Unit" textColor:[Tools theme] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:priceLabel];
		[priceLabel sizeToFit];
		[priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(coverImage);
			make.centerY.equalTo(positionSignView);
		}];
		
		likeBtn  = [[UIButton alloc] init];
		[likeBtn setImage:IMGRESOURCE(@"home_icon_love_normal") forState:UIControlStateNormal];
		[likeBtn setImage:IMGRESOURCE(@"home_icon_love_select") forState:UIControlStateSelected];
		[self addSubview:likeBtn];
		[likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(coverImage).offset(-10);
			make.top.top.equalTo(coverImage).offset(10);
			make.size.mas_equalTo(CGSizeMake(40, 40));
		}];
		[likeBtn addTarget:self action:@selector(didLikeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	return self;
}

#pragma mark -- life cycle
- (void)setUpReuseCell {
	id<AYViewBase> cell = VIEW(@"AssortmentCell", @"AssortmentCell");
	
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
- (void)didLikeBtnClick:(UIButton*)btn {
	
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	
	return nil;
}

@end
