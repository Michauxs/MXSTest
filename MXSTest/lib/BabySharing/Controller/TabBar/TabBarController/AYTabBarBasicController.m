//
//  AYTabBarBasicController.m
//  BabySharing
//
//  Created by Alfred Yang on 25/8/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYTabBarBasicController.h"

@interface AYTabBarBasicController ()

@end

@implementation AYTabBarBasicController

@synthesize para = _para;
@synthesize commands = _commands;
@synthesize facades = _facades;
@synthesize views = _views;
@synthesize delegates = _delegates;

#pragma mark -- commands
- (NSString*)getControllerName {
	return [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"TabBar"] stringByAppendingString:kAYFactoryManagerControllersuffix];
}

- (NSString*)getControllerType {
	return kAYFactoryManagerCatigoryController;
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCatigoryController;
}

- (void)postPerform {
	
	id<AYCommand> cmd_home_init = [self.commands objectForKey:@"HomeInit"];
	AYViewController* home = nil;
	[cmd_home_init performWithResult:&home];
	
	id<AYCommand> cmd_friends_init = [self.commands objectForKey:@"MessageInit"];
	AYViewController* friends = nil;
	[cmd_friends_init performWithResult:&friends];
	
	id<AYCommand> cmd_order_init = [self.commands objectForKey:@"OrderCommonInit"];
	AYViewController* order = nil;
	[cmd_order_init performWithResult:&order];
	
	id<AYCommand> cmd_profile_init = [self.commands objectForKey:@"ProfileInit"];
	AYViewController* profile = nil;
	[cmd_profile_init performWithResult:&profile];
	
	self.viewControllers = [NSArray arrayWithObjects:home, friends, order, profile, nil];
	
	home.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[IMGRESOURCE(@"tab_home") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[IMGRESOURCE(@"tab_home_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
	friends.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"消息" image:[IMGRESOURCE(@"tab_message") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[IMGRESOURCE(@"tab_message_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
	order.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"日程" image:[IMGRESOURCE(@"tab_order") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[IMGRESOURCE(@"tab_order_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
	profile.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[IMGRESOURCE(@"tab_profile") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[IMGRESOURCE(@"tab_profile_selected") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
	
	NSDictionary *attr_titleColor_normal = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10.f], NSFontAttributeName, [Tools garyColor], NSForegroundColorAttributeName, nil];
	NSDictionary *attr_titleColor_select = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10.f], NSFontAttributeName, [Tools theme], NSForegroundColorAttributeName, nil];
	[[UITabBarItem appearance] setTitleTextAttributes:attr_titleColor_normal forState:UIControlStateNormal];
	[[UITabBarItem appearance] setTitleTextAttributes:attr_titleColor_select forState:UIControlStateSelected];
	
	CALayer* shadow = [CALayer layer];
	shadow.borderColor = [UIColor colorWithRed:0.5922 green:0.5922 blue:0.5922 alpha:0.25].CGColor;
	shadow.borderWidth = 1.f;
	shadow.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
	[self.tabBar.layer addSublayer:shadow];
	
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
		[[UITabBar appearance] setShadowImage:[UIImage new]];
		[[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
	}
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
}

- (id)startRemoteCall:(id)obj {
	return nil;
}

- (id)endRemoteCall:(id)obj {
	return nil;
}

- (id)performForView:(id<AYViewBase>)from andFacade:(NSString*)facade_name andMessage:(NSString*)command_name andArgs:(NSDictionary*)args {
	@throw [[NSException alloc]initWithName:@"error" reason:@"不要在苹果自建Controller中调用Command函数" userInfo:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}




- (void)controller:(UIViewController *)controller Title:(NSString *)title tabBarItemImage:(NSString *)imageName {
	
	[controller.tabBarItem setTitle:title];
	NSDictionary *attr_color_normal = @{NSFontAttributeName:[UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName:[Tools garyColor]};
	[controller.tabBarItem setTitleTextAttributes:attr_color_normal forState:UIControlStateNormal];
	
	NSDictionary *attr_color_select = @{NSFontAttributeName:[UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName:[Tools theme]};
	[controller.tabBarItem setTitleTextAttributes:attr_color_select forState:UIControlStateSelected];
	
	UIImage *image = [UIImage imageNamed:imageName];
	image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	[controller.tabBarItem setImage:image];
	
	UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected", imageName]];
	selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	[controller.tabBarItem setSelectedImage:selectedImage];
	
}


@end
