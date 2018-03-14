//
//  AYTabBarServiceController.h
//  BabySharing
//
//  Created by Alfred Yang on 11/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYControllerBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "DongDaTabBar.h"
#import "AYViewController.h"
#import "AYCommand.h"
#import "AYViewBase.h"
#import "DongDaTabBarItem.h"

@interface AYTabBarServiceController : UITabBarController  <AYControllerBase, UITabBarDelegate, UITabBarControllerDelegate>
@property (nonatomic, assign) DongDaAppMode mode;
@property (nonatomic, strong) DongDaTabBar* dongda_tabbar;

- (void)setCurrentIndex:(NSNumber*)index;
@end
