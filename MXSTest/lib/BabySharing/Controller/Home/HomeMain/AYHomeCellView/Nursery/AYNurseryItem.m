//
//  AYHomeAssortmentCellItem.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNurseryItem.h"
#import "AYCommandDefines.h"

@implementation AYNurseryItem {
	
	UILabel *titleLabel;
	UILabel *addrlabel;
	UILabel *tagLabel;
	
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize {
	
//	self.backgroundColor = [Tools randomColor];
//	self.clipsToBounds = YES;
//	[Tools setViewBorder:self withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	
	_coverImage = [[UIImageView alloc] init];
	_coverImage.contentMode = UIViewContentModeScaleAspectFill;
	_coverImage.image = IMGRESOURCE(@"default_image");
	[Tools setViewBorder:_coverImage withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:nil];
	[self addSubview:_coverImage];
	[_coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(self);
		make.left.equalTo(self).offset(0);
		make.right.equalTo(self);
		make.top.equalTo(self);
		make.height.mas_equalTo(197);
	}];
	
	_likeBtn  = [[UIButton alloc] init];
	[_likeBtn setImage:IMGRESOURCE(@"home_icon_love_normal") forState:UIControlStateNormal];
	[_likeBtn setImage:IMGRESOURCE(@"home_icon_love_select") forState:UIControlStateSelected];
	[self addSubview:_likeBtn];
	[_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(_coverImage).offset(0);
		make.top.top.equalTo(_coverImage).offset(0);
		make.size.mas_equalTo(CGSizeMake(40, 40));
	}];
	[_likeBtn addTarget:self action:@selector(didLikeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	tagLabel = [UILabel creatLabelWithText:@"*TAG" textColor:[UIColor tag] fontSize:615 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self addSubview:tagLabel];
	[tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(_coverImage.mas_bottom).offset(10);
		make.left.equalTo(_coverImage);
//		make.left.equalTo(addrlabel.mas_right).offset(5);
//		make.centerY.equalTo(addrlabel);
	}];
	
	titleLabel = [UILabel creatLabelWithText:@"Service title" textColor:[UIColor black] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	titleLabel.numberOfLines = 2;
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(tagLabel.mas_bottom).offset(2);
		make.left.equalTo(_coverImage);
		make.right.equalTo(_coverImage);
	}];
	
	addrlabel = [UILabel creatLabelWithText:@"Address s" textColor:[UIColor gary] fontSize:315 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[self addSubview:addrlabel];
	[addrlabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(titleLabel.mas_bottom).offset(10);
		make.left.equalTo(_coverImage);
	}];
	
}

- (void)didLikeBtnClick:(UIButton*)btn {
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	[dic setValue:btn forKey:@"btn"];
	[dic setValue:[_itemInfo copy] forKey:kAYServiceArgsInfo];
	_likeBtnClick([dic copy]);
}

- (void)setItemInfo:(NSDictionary *)itemInfo {
	_itemInfo = itemInfo;
	
	NSString *photoName = [_itemInfo objectForKey:kAYServiceArgsImage];
	if (photoName) {
		
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
		[dic setValue:photoName forKey:@"key"];
		[dic setValue:_coverImage forKey:@"imageView"];
		[dic setValue:@750 forKey:@"wh"];
		id tmp = [dic copy];
		id<AYFacadeBase> oss_f = DEFAULTFACADE(@"AliyunOSS");
		id<AYCommand> cmd_oss_get = [oss_f.commands objectForKey:@"OSSGet"];
		[cmd_oss_get performWithResult:&tmp];
		
//		id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//		AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//		NSString *prefix = cmd.route;
		
//		NSString *prefix = @"http://blackmirror.oss-cn-beijing.aliyuncs.com/upload/";
//		[_coverImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, photoName]] placeholderImage:IMGRESOURCE(@"default_image")];
	}
	
	_likeBtn.selected = [[_itemInfo objectForKey:kAYServiceArgsIsCollect] boolValue];
	
	NSString *district = [_itemInfo objectForKey:kAYServiceArgsAddress];
	district = [district substringToIndex:3];
	addrlabel.text = district;
	
	NSString *brand_name = [_itemInfo objectForKey:kAYBrandArgsName];
	NSString *leaf = [_itemInfo objectForKey:kAYServiceArgsLeaf];
	NSArray *operations = [_itemInfo objectForKey:kAYServiceArgsOperation];
	NSArray *tags = [_itemInfo objectForKey:kAYServiceArgsTags];
	
	NSString *tag;
	NSString *operation;
	NSString *categ = [_itemInfo objectForKey:kAYServiceArgsCat];
	if ([categ isEqualToString:kAYStringCourse]) {
		for (NSString *ope in operations) {
			if ([kAY_operation_fileters_tag_course containsObject:ope]) {
				tag = ope;
			}
			if ([kAY_operation_fileters_title_course containsObject:ope]) {
				operation = ope;
			}
		}
		
		if (tag.length == 0) {
			tag = @"没有标签";
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
}

@end
