//
//  AYTabBarController.h
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYControllerBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "DongDaTabBar.h"
#import "AYViewController.h"
#import "AYCommand.h"
#import "AYViewBase.h"
#import "DongDaTabBarItem.h"

@interface AYTabBarController : UITabBarController <AYControllerBase, UITabBarDelegate, UITabBarControllerDelegate>

@property (nonatomic, strong) DongDaTabBar* dongda_tabbar;
@property (nonatomic, assign) DongDaAppMode mode;

- (void)setCurrentIndex:(NSNumber*)index;
@end
