//
//  AYYardImagesItemView.m
//  BabySharing
//
//  Created by Alfred Yang on 20/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYYardImagesItemView.h"

@implementation AYYardImagesItemView {
	UIImageView *addSignView;
	
	UIImageView *coverImageView;
	
//	UILabel *coverLabel;
}

- (instancetype)init {
	if (self = [super init]) {
		[self initLayout];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self initLayout];
	}
	return self;
}

- (void)initLayout {
	
	coverImageView = [[UIImageView alloc] init];
	coverImageView.image = [UIImage imageNamed:@"default_image"];
	coverImageView.clipsToBounds = YES;
	coverImageView.contentMode = UIViewContentModeScaleAspectFill;
	[self addSubview:coverImageView];
	[coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
//	coverLabel =  [Tools creatUILabelWithText:@"封面" andTextColor:[Tools whiteColor] andFontSize:311 andBackgroundColor:[Tools themeColor] andTextAlignment:NSTextAlignmentCenter];
//	[self addSubview:coverLabel];
//	[coverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.left.equalTo(self);
//		make.top.equalTo(self);
//		make.size.mas_equalTo(CGSizeMake(30, 20));
//	}];
//	coverLabel.hidden = YES;
	
	_delBtn = [[UIButton alloc] init];
	[_delBtn setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
	[self addSubview:_delBtn];
	[_delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self);
		make.top.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(20, 20));
	}];
	
	addSignView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlbumAddBtn"]];
	[self addSubview:addSignView];
	[addSignView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	addSignView.hidden = YES;
}

- (void)setItemInfo:(NSDictionary *)itemInfo {
	_itemInfo = itemInfo;
	
	NSInteger index = [[_itemInfo objectForKey:@"index"] integerValue];
	_delBtn.tag = index;
	
	if (index == 0) {
		addSignView.hidden = NO;
		_delBtn.hidden = YES;
		coverImageView.image = nil;
	} else {
		addSignView.hidden = YES;
		_delBtn.hidden = NO;
	}
	
	id image = [[_itemInfo objectForKey:@"data_image"] objectForKey:kAYServiceArgsPic];
	if ([image isKindOfClass:[NSString class]]) {
		id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
		AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
		NSString *prefix = cmd.route;
		
		[coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, image]] placeholderImage:[UIImage imageNamed:@"default_image"] options:SDWebImageLowPriority];
	} else if ([image isKindOfClass:[UIImage class]]) {
		coverImageView.image = image;
	}
	
}

@end
