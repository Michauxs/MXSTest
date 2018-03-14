//
//  AYCollectServCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 8/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCollectServCellView.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFacadeBase.h"
#import "AYModelFacade.h"
#import "AYViewController.h"
#import "AYRemoteCallCommand.h"

@implementation AYCollectServCellView {
	
	UIImageView *coverImage;
	UILabel *titleLabel;
	UILabel *addrlabel;
	UILabel *tagLabel;
	UIButton *likeBtn;
	
	NSDictionary *service_info;
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
		self.backgroundColor = [UIColor clearColor];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		coverImage = [[UIImageView alloc] init];
		coverImage.contentMode = UIViewContentModeScaleAspectFill;
		coverImage.image = IMGRESOURCE(@"default_image");
		[Tools setViewBorder:coverImage withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
		[self addSubview:coverImage];
		[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(15);
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.right.equalTo(self).offset(-SCREEN_MARGIN_LR);
			make.height.equalTo(@210);
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
		[likeBtn addTarget:self action:@selector(didLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
		tagLabel = [UILabel creatLabelWithText:@"*TAG" textColor:[UIColor tag] fontSize:313 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:tagLabel];
		[tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(coverImage.mas_bottom).offset(14);
			make.left.equalTo(coverImage);
		}];
		
		titleLabel = [UILabel creatLabelWithText:@"Service title" textColor:[UIColor black] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		titleLabel.numberOfLines = 2;
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tagLabel.mas_bottom).offset(4);
			make.left.equalTo(coverImage);
			make.right.equalTo(coverImage);
		}];
		
		addrlabel = [UILabel creatLabelWithText:@"Address s" textColor:[UIColor gary] fontSize:11.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[self addSubview:addrlabel];
		[addrlabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(titleLabel.mas_bottom).offset(10);
			make.left.equalTo(coverImage);
		}];
		
	}
	return self;
}

#pragma mark -- actions
- (void)didLikeBtnClick {
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	[dic setValue:likeBtn forKey:@"btn"];
	[dic setValue:[service_info objectForKey:@"service_id"] forKey:@"service_id"];
	
	[(AYViewController*)self.controller performAYSel:@"didAssortmentMoreBtnClick:" withResult:&dic];
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	service_info = args;
	
	NSString *photoName = [service_info objectForKey:kAYServiceArgsImage];
	if (photoName) {
		
		id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
		AYRemoteCallCommand *cmd_load = [f.commands objectForKey:@"DownloadUserFiles"];
		NSString *prefix = cmd_load.route;
		[coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, photoName]] placeholderImage:IMGRESOURCE(@"default_image")];
	}
	
	
	NSString *district = [service_info objectForKey:kAYServiceArgsAddress];
	district = [district substringToIndex:3];
	addrlabel.text = district;
	
	NSString *tag = [[service_info objectForKey:kAYServiceArgsTags] firstObject];
	if (tag.length == 0) {
		tag = @"没有标签";
	}
	tagLabel.text = tag;
	
	NSString *brand_name = [service_info objectForKey:kAYBrandArgsName];
	NSString *operation = [[service_info objectForKey:kAYServiceArgsOperation] firstObject];
	NSString *leaf = [service_info objectForKey:kAYServiceArgsLeaf];
	if (![leaf hasSuffix:@"看顾"]) {
		leaf = [leaf stringByAppendingString:@"课程"];
	}
	
	titleLabel.text = [NSString stringWithFormat:@"%@的%@%@", brand_name, operation, leaf];
	
	return nil;
}

@end

