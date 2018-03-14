//
//  AYProfileHeadCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 6/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYProfileHeadCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"
#import "QueryContent.h"
#import "QueryContentItem.h"

@implementation AYProfileHeadCellView {
	UIImageView *user_screen;
	UILabel *user_name;
	UILabel *editEnter;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		user_name = [Tools creatLabelWithText:@"User Name" textColor:[Tools black] fontSize:630.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:user_name];
		[user_name mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self).offset(20);
			make.left.equalTo(self).offset(20);
		}];
		
		editEnter = [Tools creatLabelWithText:@"查看并编辑个人资料" textColor:[Tools black] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:editEnter];
		[editEnter mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(user_name);
			make.top.equalTo(user_name.mas_bottom).offset(8);
		}];
		
		user_screen = [[UIImageView alloc] init];
		[self addSubview:user_screen];
		[user_screen mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(user_name);
			make.right.equalTo(self).offset(-20);
			make.size.mas_equalTo(CGSizeMake(64, 64));
		}];
		user_screen.layer.cornerRadius = 32.f;
		user_screen.clipsToBounds = YES;
		user_screen.layer.borderColor = [UIColor colorWithWhite:1.f alpha:0.25].CGColor;
		user_screen.layer.borderWidth = 2.f;
		user_screen.layer.rasterizationScale = [UIScreen mainScreen].scale;
		
//		CALayer *separtor = [CALayer layer];
//		separtor.frame = CGRectMake(15, 79.5, SCREEN_WIDTH - 30, 0.5);
//		separtor.backgroundColor = [Tools garyLineColor].CGColor;
//		[self.layer addSublayer:separtor];
		
		if (reuseIdentifier != nil) {
			[self setUpReuseCell];
		}
	}
	
	return self;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"ProfileHeadCell", @"ProfileHeadCell");
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
}

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

-(id)setCellInfo:(NSDictionary*)args{
	
	NSString *screen_photo = [args objectForKey:kAYProfileArgsScreenPhoto];
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	[dic setValue:screen_photo forKey:@"key"];
	[dic setValue:user_screen forKey:@"imageView"];
	[dic setValue:@228 forKey:@"wh"];
	id tmp = [dic copy];
	id<AYFacadeBase> oss_f = DEFAULTFACADE(@"AliyunOSS");
	id<AYCommand> cmd_oss_get = [oss_f.commands objectForKey:@"OSSGet"];
	[cmd_oss_get performWithResult:&tmp];
	
	if (tmp) {
		user_screen.image = tmp;
	} else {
		
	}
	
//	id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//	AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//	NSString *prefix = cmd.route;
//	[user_screen sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", prefix, screen_photo]] placeholderImage:IMGRESOURCE(@"default_user")];
	
    NSString *name = [args objectForKey:@"screen_name"];
    if (name && ![name isEqualToString:@""]) {
        user_name.text = name;
    }
    
    return nil;
}
@end
