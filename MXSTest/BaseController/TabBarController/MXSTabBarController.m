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

@implementation MXSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UINavigationController *nav_home = [[UINavigationController alloc]init];
	UINavigationController *nav_con = [[UINavigationController alloc]init];
	UINavigationController *nav_set = [[UINavigationController alloc]init];
	UINavigationController *nav_profile = [[UINavigationController alloc]init];
	
	MXSHomeVC *vc_home = [[MXSHomeVC alloc]init];
	MXSContentVC *vc_con = [[MXSContentVC alloc]init];
	MXSSettingVC *vc_set = [[MXSSettingVC alloc]init];
	MXSProfileVC *vc_profile = [[MXSProfileVC alloc] init];
	
	[nav_home pushViewController:vc_home animated:NO];
	[nav_con pushViewController:vc_con animated:NO];
	[nav_set pushViewController:vc_set animated:NO];
	[nav_profile pushViewController:vc_profile animated:NO];
	
	vc_home.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"HOME" image:IMGRESOURE(@"tab_home") selectedImage:IMGRESOURE(@"tab_home_selected")];
	vc_con.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"CONT" image:IMGRESOURE(@"tab_found") selectedImage:[UIImage imageNamed:@"tab_found_selected"]];
	vc_set.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"CENT" image:IMGRESOURE(@"tab_friends") selectedImage:[UIImage imageNamed:@"tab_friends_selected"]];
	vc_profile.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"PROF" image:IMGRESOURE(@"tab_friends") selectedImage:IMGRESOURE(@"tab_friends_selected")];
	
	vc_con.tabBarItem.badgeColor = [UIColor redColor];
	
	self.viewControllers = @[nav_home, nav_con, nav_set, nav_profile];
	self.selectedIndex = 1;
	
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
