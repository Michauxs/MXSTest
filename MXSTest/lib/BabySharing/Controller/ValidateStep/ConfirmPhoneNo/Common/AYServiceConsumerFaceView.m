//
//  AYServiceConsumerFaceView.m
//  BabySharing
//
//  Created by BM on 29/09/2016.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYServiceConsumerFaceView.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "PhotoTagEnumDefines.h"

@implementation AYServiceConsumerFaceView {
    UILabel* title;
    UIImageView* lhs;
    UIImageView* rhs;
    UIImageView* logo;
    UILabel* des;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
	
	self.bounds = CGRectMake(0, 0, 0, 200);
	
    title = [Tools creatLabelWithText:@"手机号验证" textColor:[Tools black] fontSize:320.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self);
    }];
	
	//    我们要求每一位妈妈在预订服务前验证手机号码\n您只需要验证一次
	des = [Tools creatLabelWithText:@"第一次预订服务需要您验证手机号码\n以便和服务者及时沟通" textColor:[Tools black] fontSize:16.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	des.numberOfLines = 0;
	[self addSubview:des];
	[des mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(title.mas_bottom).offset(10);
		make.left.equalTo(title);
	}];
	
    lhs = [[UIImageView alloc]init];
    lhs.layer.borderWidth = 2.f;
    lhs.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    lhs.layer.cornerRadius = 75 * 0.5;
    lhs.clipsToBounds = YES;
    lhs.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:lhs];
    [lhs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-50);
        make.top.equalTo(des.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    rhs = [[UIImageView alloc]init];
    rhs.layer.borderWidth = 2.f;
    rhs.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
    rhs.layer.cornerRadius = 75 * 0.5;
    rhs.clipsToBounds = YES;
    rhs.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self addSubview:rhs];
    [rhs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(50);
        make.centerY.equalTo(lhs);
        make.size.equalTo(lhs);
    }];
    
    logo = [[UIImageView alloc]init];
//    logo.layer.borderWidth = 2.f;
//    logo.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
//    logo.layer.cornerRadius = 24;
//    logo.clipsToBounds = YES;
//    logo.layer.rasterizationScale = [UIScreen mainScreen].scale;
    logo.image = IMGRESOURCE(@"contact_user_logo");
    [self addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(lhs);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
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

#pragma mark -- messages
- (void)selfClicked {
    @throw [[NSException alloc]initWithName:@"error" reason:@"cannot call base view" userInfo:nil];
}


#pragma mark -- actions
- (id)lhsImage:(id)args {
	UIImage *img = (UIImage*)args;
	if (!img) {
		img = IMGRESOURCE(@"default_user");
	}
	lhs.image = img;
    return nil;
}

- (id)rhsImage:(id)args {
	UIImage *img = (UIImage*)args;
	if (!img) {
		img = IMGRESOURCE(@"default_user");
	}
    rhs.image = img;
    return nil;
}

- (id)resetTitle:(id)args {
    return nil;
}

- (id)queryHintHight {
    return [NSNumber numberWithInt:100];
}
@end
