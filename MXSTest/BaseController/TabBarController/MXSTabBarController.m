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

@interface MXSTabBarController ()

@end

@implementation MXSTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UINavigationController *nav_home = [[UINavigationController alloc]init];
	UINavigationController *nav_con = [[UINavigationController alloc]init];
	UINavigationController *nav_set = [[UINavigationController alloc]init];
	
	MXSHomeVC *view_home = [[MXSHomeVC alloc]init];
	MXSContentVC *view_con = [[MXSContentVC alloc]init];
	MXSSettingVC *view_set = [[MXSSettingVC alloc]init];
	
	[nav_home pushViewController:view_home animated:NO];
	[nav_con pushViewController:view_con animated:NO];
	[nav_set pushViewController:view_set animated:NO];
	
	view_home.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"001" image:IMGRESOURE(@"tab_home") selectedImage:IMGRESOURE(@"tab_home_selected")];
	view_con.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"002" image:IMGRESOURE(@"tab_friends") selectedImage:[UIImage imageNamed:@"tab_friends_selected"]];
	view_set.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"003" image:IMGRESOURE(@"tab_found") selectedImage:[UIImage imageNamed:@"tab_found_selected"]];
	
	view_con.tabBarItem.badgeColor = [UIColor redColor];
	
	self.viewControllers = @[nav_home, nav_con, nav_set];
	
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
