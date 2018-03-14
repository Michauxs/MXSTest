//
//  AYServiceImagesCell.m
//  BabySharing
//
//  Created by Alfred Yang on 5/6/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYServiceImagesCell.h"
#import "AYCommandDefines.h"

@implementation AYServiceImagesCell {
	UIImageView *imageView;
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
	
	imageView = [[UIImageView alloc] init];
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	imageView.clipsToBounds = YES;
	imageView.image = IMGRESOURCE(@"default_image");
	[self addSubview:imageView];
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self);
	}];
	
}

- (void)setItemImageWithImageName:(NSString *)imageName {
	
	if (imageName) {
		
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
		[dic setValue:imageName forKey:@"key"];
		[dic setValue:imageView forKey:@"imageView"];
		[dic setValue:@750 forKey:@"wh"];
		id tmp = [dic copy];
		id<AYFacadeBase> oss_f = DEFAULTFACADE(@"AliyunOSS");
		id<AYCommand> cmd_oss_get = [oss_f.commands objectForKey:@"OSSGet"];
		[cmd_oss_get performWithResult:&tmp];
		
//		id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//		AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//		NSString *prefix = cmd.route;
//		[imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, imageName]] placeholderImage:IMGRESOURCE(@"default_image") options:SDWebImageLowPriority];
	}
	
}

- (void)setItemImageWithImage:(UIImage *)image {
	imageView.image = image;
}

@end
