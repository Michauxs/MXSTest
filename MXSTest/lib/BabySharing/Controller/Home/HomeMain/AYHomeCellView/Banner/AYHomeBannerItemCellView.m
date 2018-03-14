//
//  AYHomeBannerItemCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeBannerItemCellView.h"
#import "AYCommandDefines.h"

@implementation AYHomeBannerItemCellView{
	UIImageView *imageView;
	NSArray *borderColors;
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
	
	self.backgroundColor = [UIColor clearColor];
	borderColors = @[[Tools colorWithRED:140 GREEN:140 BLUE:240 ALPHA:1.f], [Tools colorWithRED:140 GREEN:140 BLUE:240 ALPHA:1.f],
					 [Tools colorWithRED:140 GREEN:140 BLUE:240 ALPHA:1.f], [Tools colorWithRED:140 GREEN:140 BLUE:240 ALPHA:1.f]];
	
//	UIView *borderView = [[UIView alloc] init];
////	[Tools setViewBorder:borderView withRadius:0 andBorderWidth:1.f andBorderColor:[Tools themeColor] andBackground:[UIColor clearColor]];
//	borderView.layer.borderColor = [Tools themeColor].CGColor;
//	borderView.layer.borderWidth = 1.5f;
//	borderView.layer.shadowColor = [Tools garyColor].CGColor;
//	borderView.layer.shadowOffset = CGSizeMake(6.5, 6.5);
//	borderView.layer.shadowOpacity = 0.5f;
//	borderView.layer.shadowRadius = 1.5f;
//	[self addSubview:borderView];
//	[borderView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.edges.equalTo(self).insets(UIEdgeInsetsMake(15, 20, 15, 20));
//	}];
	
	imageView = [[UIImageView alloc] init];
//	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageView.clipsToBounds = YES;
	imageView.image = IMGRESOURCE(@"default_image");
	[self addSubview:imageView];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self).insets(UIEdgeInsetsMake(10, 23, 16, 15));
	}];
	
}

- (void)setItemImageWithImageUrl:(NSString *)imageUrl {
	[imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:IMGRESOURCE(@"default_image") options:SDWebImageHighPriority];
}

- (void)setItemImageWithImage:(UIImage *)image {
	imageView.image = image;
}

- (void)setItemImageWithImageName:(NSString*)imageName {
	imageView.image = [UIImage imageNamed:imageName];
}

@end
