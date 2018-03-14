//
//  AYImageItemCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 18/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYImageItemCellView.h"

@implementation AYImageItemCellView {
	UIImageView *addSignView;
	
	UIImageView *coverImageView;
	
	UILabel *coverLabel;
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
	
	coverLabel =  [Tools creatLabelWithText:@"封面" textColor:[Tools whiteColor] fontSize:311 backgroundColor:[Tools theme] textAlignment:NSTextAlignmentCenter];
	[self addSubview:coverLabel];
	[coverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self);
		make.top.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(30, 20));
	}];
	coverLabel.hidden = YES;
	
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
		coverLabel.hidden = YES;
		coverImageView.image = nil;
	} else if(index == 1) {
		addSignView.hidden = YES;
		_delBtn.hidden = NO;
		coverLabel.hidden = NO;
	} else {
		addSignView.hidden = YES;
		_delBtn.hidden = NO;
		coverLabel.hidden = YES;
	}
	
	id image = [_itemInfo objectForKey:@"image"];
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
