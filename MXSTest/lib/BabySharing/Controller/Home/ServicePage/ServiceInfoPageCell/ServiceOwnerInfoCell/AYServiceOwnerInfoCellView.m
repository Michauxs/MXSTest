//
//  AYServiceOwnerInfoCellVeiw.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServiceOwnerInfoCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYRemoteCallCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"

#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYViewController.h"

static NSString* const isGettingCertData = @"正在获取信息";

static NSString* const VerifiedRealName = @"实名认证";
static NSString* const hasNoRealName = @"实名待认证";

static NSString* const VerifiedPhoneNo = @"手机号码验证";
static NSString* const hasNoPhoneNo = @"手机号码待验证";

@implementation AYServiceOwnerInfoCellView {
	
    UIImageView *userPhoto;
	UILabel *brandTagLabel;
	
    UILabel *userName;
	UILabel *userJob;
	
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
		
        self.clipsToBounds = YES;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		CGFloat photoWidth = 55;
        userPhoto = [[UIImageView alloc] init];
		NSString *img = [NSString stringWithFormat:@"avatar_%d", arc4random()%10];
		userPhoto.image = IMGRESOURCE(img);
		userPhoto.backgroundColor = [UIColor theme];
        userPhoto.contentMode = UIViewContentModeScaleAspectFill;
        userPhoto.clipsToBounds = YES;
        userPhoto.layer.cornerRadius = photoWidth*0.5;
        [self addSubview:userPhoto];
        [userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-SERVICEPAGE_MARGIN_LR);
            make.top.equalTo(self).offset(16);
			make.bottom.equalTo(self).offset(-16);
            make.size.mas_equalTo(CGSizeMake(photoWidth, photoWidth));
        }];
		
		[userPhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPhotoTap)]];
		
		brandTagLabel = [UILabel creatLabelWithText:@"-" textColor:[UIColor white] fontSize:620 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		brandTagLabel.font = [UIFont boldSystemFontOfSize:20];
		[self addSubview:brandTagLabel];
		[brandTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.center.equalTo(userPhoto);
		}];
		
		userName = [UILabel creatLabelWithText:@"UserName" textColor:[UIColor black13] fontSize:617.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		userName.numberOfLines = 1;
		[self addSubview:userName];
		[userName mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(userPhoto).offset(7);
			make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
			make.right.equalTo(userPhoto.mas_left).offset(-20);
		}];
		userJob = [UILabel creatLabelWithText:@"UserJob" textColor:[UIColor gary115] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		userJob.numberOfLines = 1;
		[self addSubview:userJob];
		[userJob mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(userPhoto).offset(-4);
			make.left.equalTo(userName);
			make.right.equalTo(userName);
		}];
		
		
		UIView *bottom_view = [[UIView alloc] init];
		bottom_view.backgroundColor = [UIColor garyLine];
		[self addSubview:bottom_view];
		[bottom_view mas_makeConstraints:^(MASConstraintMaker *make) {
//			make.top.equalTo(userPhoto.mas_bottom).offset(30);
			make.left.equalTo(self).offset(SERVICEPAGE_MARGIN_LR);
			make.right.equalTo(self).offset(-SERVICEPAGE_MARGIN_LR);
			make.bottom.equalTo(self);
			make.height.mas_equalTo(0.5);
		}];
		
    }
    return self;
}


#pragma mark -- actions
- (void)userPhotoTap {
	[(AYViewController*)self.controller performAYSel:@"showOwnerInfo" withResult:nil];
}

#pragma mark -- notifies
- (id)setCellInfo:(id)args {
    
    service_info = (NSDictionary*)args;
	
    id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
    NSString *pre = cmd.route;
    
	NSNumber *pre_mode = [service_info objectForKey:@"perview_mode"];
	if (pre_mode) {     //用户预览
		NSDictionary *user_info;
		CURRENPROFILE(user_info)

		userName.text = [user_info objectForKey:@"screen_name"];
		NSString* photo_name = [user_info objectForKey:@"screen_photo"];
		if (photo_name && ![photo_name isEqualToString:@""]) {
			[userPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",pre, photo_name]]
						 placeholderImage:IMGRESOURCE(@"default_user")];
		}
		userPhoto.userInteractionEnabled = NO;

	} else {
		userPhoto.userInteractionEnabled = YES;
		
		NSDictionary *info_owner = [service_info objectForKey:kAYBrandArgsSelf];
		
		NSString *userNameStr = [info_owner objectForKey:kAYBrandArgsName];
		if (userNameStr.length != 0) {
			userName.text = userNameStr;
			userJob.text = [userNameStr stringByAppendingString:@"老师"];
		}
		
		NSString *tag = [info_owner objectForKey:kAYBrandArgsTag];
//		userPhoto.image = [self createImageContext:tag];
		
		brandTagLabel.text = tag;
		
//		NSString *screen_photo = [info_owner objectForKey:kAYProfileArgsScreenPhoto];
//		if (screen_photo && ![screen_photo isEqualToString:@""]) {
//			[userPhoto sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", pre, screen_photo]]
//						 placeholderImage:IMGRESOURCE(@"default_user") /*options:SDWebImageRefreshCached*/];
//		}
		
	}
	
    return nil;
}

- (UIImage *)createImageContext:(NSString *)text {
	
	CGSize imageSize = userPhoto.bounds.size; //画的背景 大小
	
	UIGraphicsBeginImageContextWithOptions(imageSize, YES, SCREEN_SCALE);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawPath(context, kCGPathStroke);
	
	NSDictionary *attributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
	
	CGRect sizeToFit = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil];
	
	NSLog(@"图片: %f %f",imageSize.width,imageSize.height);
	NSLog(@"sizeToFit: %f %f",sizeToFit.size.width,sizeToFit.size.height);
	
	CGContextSetFillColorWithColor(context, [UIColor white].CGColor);
	
	[text drawAtPoint:CGPointMake((imageSize.width - sizeToFit.size.width)/2, 0) withAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
	//返回绘制的新图形
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	return newImage;
}

@end
