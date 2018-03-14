//
//  AYAssortmentItemView.m
//  BabySharing
//
//  Created by Alfred Yang on 25/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAssortmentItemView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

@implementation AYAssortmentItemView {
	
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

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (instancetype)init{
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)initialize {
	
	self.layer.shadowColor = [Tools garyColor].CGColor;
	self.layer.shadowOffset = CGSizeMake(0, 0);
	self.layer.shadowRadius = 3.f;
	self.layer.shadowOpacity = 0.5f;
	self.layer.cornerRadius = 4.f;
	
	UIView *radiusView = [[UIView alloc] init];
	[Tools setViewBorder:radiusView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
	[self addSubview:radiusView];
	[radiusView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
	coverImage = [[UIImageView alloc]init];
	coverImage.image = IMGRESOURCE(@"default_image");
	coverImage.contentMode = UIViewContentModeScaleAspectFill;
	coverImage.clipsToBounds = YES;
	[radiusView addSubview:coverImage];
	[coverImage mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self);
		make.left.equalTo(self);
		make.width.equalTo(self);
		make.height.mas_equalTo(116);
	}];
	
	
	titleLabel = [Tools creatLabelWithText:@"Service Belong to Servant" textColor:[Tools black] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	titleLabel.numberOfLines = 2;
	[radiusView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(10);
		make.right.equalTo(self).offset(-10);
		make.top.equalTo(coverImage.mas_bottom).offset(5);
	}];
	
	positionSignView = [[UIImageView alloc]init];
	[radiusView addSubview:positionSignView];
	positionSignView.image = IMGRESOURCE(@"home_icon_location");
	[positionSignView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel);
		make.top.equalTo(titleLabel.mas_bottom).offset(5);
		make.size.mas_equalTo(CGSizeMake(8, 10));
	}];
	
	addressLabel = [Tools creatLabelWithText:@"Address Info" textColor:[Tools RGB153GaryColor] fontSize:311.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[radiusView addSubview:addressLabel];
	[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(positionSignView);
		make.left.equalTo(positionSignView.mas_right).offset(3);
		make.right.equalTo(self).offset(-10);
	}];
	
	
	priceLabel = [Tools creatLabelWithText:@"¥Price/Unit" textColor:[Tools theme] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[radiusView addSubview:priceLabel];
	[priceLabel sizeToFit];
	[priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel);
		make.top.equalTo(positionSignView.mas_bottom).offset(8);
	}];
	
	ageBoundaryLabel = [Tools creatLabelWithText:@"0-0 old" textColor:[Tools theme] fontSize:311.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[Tools setViewBorder:ageBoundaryLabel withRadius:4.f andBorderWidth:1.f andBorderColor:[Tools theme] andBackground:nil];
	[radiusView addSubview:ageBoundaryLabel];
	[ageBoundaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(titleLabel);
		make.bottom.equalTo(self).offset(-10);
		make.size.mas_equalTo(CGSizeMake(48, 20));
	}];
	
	themeLabel = [Tools creatLabelWithText:@"Theme" textColor:[Tools theme] fontSize:311.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[Tools setViewBorder:themeLabel withRadius:4.f andBorderWidth:1.f andBorderColor:[Tools theme] andBackground:nil];
	[radiusView addSubview:themeLabel];
	[themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(ageBoundaryLabel.mas_left).offset(-8);
		make.centerY.equalTo(ageBoundaryLabel);
		make.size.mas_equalTo(CGSizeMake(56, 20));
	}];
	
	
//	likeBtn  = [[UIButton alloc] init];
//	[likeBtn setImage:IMGRESOURCE(@"home_icon_love_normal") forState:UIControlStateNormal];
//	[likeBtn setImage:IMGRESOURCE(@"home_icon_love_select") forState:UIControlStateSelected];
//	[self addSubview:likeBtn];
//	[likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.right.equalTo(coverImage).offset(-10);
//		make.top.top.equalTo(coverImage).offset(10);
//		make.size.mas_equalTo(CGSizeMake(40, 40));
//	}];
//	[likeBtn addTarget:self action:@selector(didLikeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
}

-(void)setItemInfo:(NSDictionary *)args {
	
	service_info = args;
	
	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
	NSString *prefix = cmd.route;
	
	NSString* photo_name = [service_info objectForKey:kAYServiceArgsImages];
	NSString *urlStr = [NSString stringWithFormat:@"%@%@", prefix, photo_name];
	[coverImage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:IMGRESOURCE(@"default_image") /*options:SDWebImageRefreshCached*/];
	
	NSDictionary *info_cat = [service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSString *service_cat = [info_cat objectForKey:kAYServiceArgsCat];
	NSDictionary *info_ower = [service_info objectForKey:@"owner"];
	NSString *ownerName = [info_ower objectForKey:kAYProfileArgsScreenName];
	
	NSString *unitCat = @"UNIT";
	//	if ([service_cat isEqualToString:kAYStringNursery]) {
	if ([service_cat containsString:@"看"]) {
		unitCat = @"小时";
		
		NSString *compName = [info_cat objectForKey:kAYServiceArgsCatSecondary];
		titleLabel.text = [NSString stringWithFormat:@"%@的%@", ownerName, compName];
		if(compName && ![compName isEqualToString:@""]) {
			themeLabel.text = compName;
		}
	}
	else if ([service_cat isEqualToString:kAYStringCourse]) {
		unitCat = @"次";
		
		NSString *compName = [info_cat objectForKey:kAYServiceArgsConcert];
		if (!compName || [compName isEqualToString:@""]) {
			compName = [info_cat objectForKey:kAYServiceArgsCatThirdly];
			if (!compName || [compName isEqualToString:@""]) {
				compName = [info_cat objectForKey:kAYServiceArgsCatSecondary];
			}
		}
		titleLabel.text = [NSString stringWithFormat:@"%@的%@%@", ownerName, compName, service_cat];
		if(compName && ![compName isEqualToString:@""]) {
			themeLabel.text = compName;
		}
	} else {
		NSLog(@"---null---");
	}
	
	NSDictionary *info_detail = [service_info objectForKey:kAYServiceArgsDetailInfo];
	NSDictionary *age_boundary = [info_detail objectForKey:kAYServiceArgsAgeBoundary];
	NSNumber *low = [age_boundary objectForKey:kAYServiceArgsAgeBoundaryLow];
	NSNumber *up = [age_boundary objectForKey:kAYServiceArgsAgeBoundaryUp];
	ageBoundaryLabel.text = [NSString stringWithFormat:@"%@-%@岁", low, up];
	
	
	NSNumber *price = [info_detail objectForKey:kAYServiceArgsPrice];
	NSString *tmp = [NSString stringWithFormat:@"%.f", price.intValue * 0.01];
	int length = (int)tmp.length;
	NSString *priceStr = [NSString stringWithFormat:@"¥%@/%@", tmp, unitCat];
	
	NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithString:priceStr];
	[attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.f], NSForegroundColorAttributeName :[Tools theme]} range:NSMakeRange(0, length+1)];
	[attributedText setAttributes:@{NSFontAttributeName:kAYFontLight(12.f), NSForegroundColorAttributeName :[Tools theme]} range:NSMakeRange(length + 1, priceStr.length - length - 1)];
	priceLabel.attributedText = attributedText;
	
	NSDictionary *info_location = [service_info objectForKey:kAYServiceArgsLocationInfo];
	NSString *addressStr = [info_location objectForKey:kAYServiceArgsAddress];
	if (addressStr && ![addressStr isEqualToString:@""]) {
		NSString *stringPre = @"中国北京市";
		if ([addressStr hasPrefix:stringPre]) {
			addressStr = [addressStr stringByReplacingOccurrencesOfString:stringPre withString:@""];
		}
		addressLabel.text = addressStr;
	}
	
	NSNumber *iscollect = [service_info objectForKey:kAYServiceArgsIsCollect];
	likeBtn.selected = iscollect.boolValue;
	
//	NSNumber *isChoice = [service_info objectForKey:kAYServiceArgsIsChoice];
//	choiceSignView.hidden = !isChoice.boolValue;
//	
//	NSNumber *isTopSort = [service_info objectForKey:kAYServiceArgsIsTopCateg];
//	hotSignView.hidden = !isTopSort.boolValue;
	
}

@end
