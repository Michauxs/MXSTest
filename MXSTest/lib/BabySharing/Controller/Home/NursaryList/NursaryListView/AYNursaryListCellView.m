//
//  AYNursaryListCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 5/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYNursaryListCellView.h"

@implementation AYNursaryListCellView {
	
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
		self.clipsToBounds = YES;
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
			make.right.equalTo(coverImage).offset(0);
			make.top.top.equalTo(coverImage).offset(0);
			make.size.mas_equalTo(CGSizeMake(40, 40));
		}];
		[likeBtn addTarget:self action:@selector(didLikeBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
		tagLabel = [UILabel creatLabelWithText:@"*TAG" textColor:[UIColor tag] fontSize:615 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:tagLabel];
		[tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(coverImage.mas_bottom).offset(14);
			make.left.equalTo(coverImage);
		}];
		
		titleLabel = [UILabel creatLabelWithText:@"Service title" textColor:[UIColor black] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		titleLabel.numberOfLines = 2;
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tagLabel.mas_bottom).offset(4);
			make.left.equalTo(coverImage);
			make.right.equalTo(coverImage);
		}];
		
		addrlabel = [UILabel creatLabelWithText:@"Address s" textColor:[UIColor gary] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
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
	
	[(AYViewController*)self.controller performAYSel:@"willCollectWithRow:" withResult:&dic];
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	service_info = args;
	
	NSString *photoName = [service_info objectForKey:kAYServiceArgsImage];
	if (photoName) {
		
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
		[dic setValue:photoName forKey:@"key"];
		[dic setValue:coverImage forKey:@"imageView"];
		[dic setValue:@750 forKey:@"wh"];
		id tmp = [dic copy];
		id<AYFacadeBase> oss_f = DEFAULTFACADE(@"AliyunOSS");
		id<AYCommand> cmd_oss_get = [oss_f.commands objectForKey:@"OSSGet"];
		[cmd_oss_get performWithResult:&tmp];
		
//		id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//		AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//		NSString *prefix = cmd.route;
//		[coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, photoName]] placeholderImage:IMGRESOURCE(@"default_image")];
	}
	
	
	NSString *district = [service_info objectForKey:kAYServiceArgsAddress];
	district = [district substringToIndex:3];
	addrlabel.text = district;
	
	NSString *brand_name = [service_info objectForKey:kAYBrandArgsName];
	NSString *leaf = [service_info objectForKey:kAYServiceArgsLeaf];
	NSArray *operations = [service_info objectForKey:kAYServiceArgsOperation];
	NSArray *tags = [service_info objectForKey:kAYServiceArgsTags];
	
	NSString *tag;
	NSString *operation;
	NSString *categ = [service_info objectForKey:kAYServiceArgsCat];
	if ([categ isEqualToString:kAYStringCourse]) {
		for (NSString *ope in operations) {
			if ([kAY_operation_fileters_tag_course containsObject:ope]) {
				tag = tag.length == 0 ? ope : tag;
			}
			if ([kAY_operation_fileters_title_course containsObject:ope]) {
				operation = operation.length == 0 ? ope : operation;
			}
		}
		
		if (tag.length == 0) {
			tag = @"没有标签";
			tagLabel.hidden = YES;
			[titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(coverImage.mas_bottom).offset(10);
				make.left.equalTo(coverImage);
				make.right.equalTo(coverImage);
			}];
		} else {
			tagLabel.hidden = NO;
			[titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(tagLabel.mas_bottom).offset(1);
				make.left.equalTo(coverImage);
				make.right.equalTo(coverImage);
			}];
		}
		if (operation.length == 0) {
			operation = @"";
		}
		
		titleLabel.text = [NSString stringWithFormat:@"%@的%@%@课程", brand_name, operation, leaf];
	}
	else if([categ isEqualToString:kAYStringNursery]) {
		tag = [tags firstObject];
		if (tag.length == 0) {
			tag = @"没有标签";
			tagLabel.hidden = YES;
			[titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(coverImage.mas_bottom).offset(10);
				make.left.equalTo(coverImage);
				make.right.equalTo(coverImage);
			}];
		} else {
			tagLabel.hidden = NO;
			[titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(tagLabel.mas_bottom).offset(1);
				make.left.equalTo(coverImage);
				make.right.equalTo(coverImage);
			}];
		}
		
		for (NSString *ope in operations) {
			if ([kAY_operation_fileters_title_nursery containsObject:ope]) {
				operation = ope;
			}
		}
		if (operation.length == 0) {
			operation = @"";
		}
		titleLabel.text = [NSString stringWithFormat:@"%@的%@%@", brand_name, operation, leaf];
	}
	
	tagLabel.text = tag;
	
	likeBtn.selected = [[service_info objectForKey:kAYServiceArgsIsCollect] boolValue];
	
	return nil;
}

@end
