//
//  AYVersionNavCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 17/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYVersionNavCellView.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

@implementation AYVersionNavCellView {
	
	UIImageView *coverImageView;
	UILabel *titleLabel;
	UILabel *detailLabel;
	
}

#pragma mark -- commands
- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	
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
	self.backgroundColor = [Tools whiteColor];
	
	coverImageView = [[UIImageView alloc]init];
	coverImageView.contentMode = UIViewContentModeScaleAspectFill;
	coverImageView.clipsToBounds = YES;
	[self addSubview:coverImageView];
	[coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.top.equalTo(self).offset(25);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 50, SCREEN_HEIGHT * 475/667));
	}];
	
	titleLabel = [Tools creatLabelWithText:@"Title" textColor:[Tools black] fontSize:20.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self).offset(25);
		make.top.equalTo(coverImageView.mas_bottom).offset(25);
	}];
	
	detailLabel = [Tools creatLabelWithText:@"Detail" textColor:[Tools black] fontSize:15.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	detailLabel.numberOfLines = 0;
	[self addSubview:detailLabel];
	[detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(titleLabel);
		make.top.equalTo(titleLabel.mas_bottom).offset(20);
	}];
	
	//	[self setUpReuseCell];
}

- (void)layoutSubviews {
	[super layoutSubviews];
}

#pragma mark -- life cycle

#pragma mark -- actions

#pragma mark -- messages
- (id)setCellInfo:(NSArray*)dic_args {
	
	return nil;
}

- (void)setItemInfoDic:(NSDictionary *)itemInfoDic {
	_itemInfoDic = itemInfoDic;
	
	NSString *image_name = [_itemInfoDic objectForKey:@"cover"];
	UIImage *coverImage = IMGRESOURCE(image_name);
	coverImageView.image = coverImage;
	
	titleLabel.text = [_itemInfoDic objectForKey:@"title"];
	
	NSString *detailStr = [_itemInfoDic objectForKey:@"detail"];
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:detailStr];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineSpacing:4];//调整行间距
	[attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [detailStr length])];
	detailLabel.attributedText = attributedString;
	
//	detailLabel.text = [_itemInfoDic objectForKey:@"detail"];
	
}

@end

