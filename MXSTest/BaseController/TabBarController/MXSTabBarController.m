//
//  MXSTabBarController.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSTabBarController.h"
#import "MXSHomeVC.h"
#import "MXSContentVC.h"
#import "MXSSettingVC.h"
#import "MXSProfileVC.h"

@interface MXSTabBarController ()

@end

@implementation MXSTabBarController {
	NSArray *NAVArr;
	NSArray *VCArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	VCArr = @[[[MXSHomeVC alloc]init], [[MXSContentVC alloc]init], [[MXSSettingVC alloc]init], [[MXSProfileVC alloc]init]];
	NSMutableArray *nav_temp_arr = [NSMutableArray array];
	for (MXSViewController *vc in VCArr) {
		UINavigationController *nav = [[UINavigationController alloc]init];
		[nav pushViewController:vc animated:NO];
		[nav setNavigationBarHidden:YES animated:NO];
		[nav_temp_arr addObject:nav];
	}
	NAVArr = [nav_temp_arr copy];
	
	self.viewControllers = NAVArr;
	
	NSArray *titleArr = @[@"HOME", @"CON", @"SET", @"PROF"];
	
	for (int i = 0; i < NAVArr.count; ++i) {
		UINavigationController *nav = [NAVArr objectAtIndex:i];
		[self controller:nav Title:titleArr[i] tabBarItemImageName:[NSString stringWithFormat:@"tab_icon_%d", i]];
		nav.tabBarItem.badgeColor = [UIColor redColor];
	}
	
	[[UITabBar appearance] setBarTintColor:[Tools darkBackgroundColor]];
	[UITabBar appearance].translucent = NO;
	
//	vc_con.tabBarItem.badgeColor = [UIColor redColor];
//	[vc_con.tabBarItem setBadgeValue:@"1"];
	
//	self.selectedIndex = 2;
	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controller:(UIViewController *)controller Title:(NSString *)title tabBarItemImageName:(NSString *)imageName {
	controller.tabBarItem = [[UITabBarItem alloc] init];
	
	[controller.tabBarItem setTitle:title];
	NSDictionary *attr_color_normal = @{NSFontAttributeName:[UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName:[Tools garyLineColor]};
	[controller.tabBarItem setTitleTextAttributes:attr_color_normal forState:UIControlStateNormal];
	
	NSDictionary *attr_color_select = @{NSFontAttributeName:[UIFont systemFontOfSize:10.f], NSForegroundColorAttributeName:[Tools theme]};
	[controller.tabBarItem setTitleTextAttributes:attr_color_select forState:UIControlStateSelected];
	
	UIImage *image = [UIImage imageNamed:imageName];
	image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	[controller.tabBarItem setImage:image];
	
	UIImage *selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_select", imageName]];
	selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	[controller.tabBarItem setSelectedImage:selectedImage];
	
}

@end
