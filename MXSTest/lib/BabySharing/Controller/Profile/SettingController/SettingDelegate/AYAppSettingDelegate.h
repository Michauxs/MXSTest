//
//  AYAppSettingDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYCommand.h"
#import "AYViewBase.h"
#import <UIKit/UIKit.h>
#import "AYViewController.h"

#import <StoreKit/StoreKit.h>

@interface AYAppSettingDelegate : NSObject <AYDelegateBase, UITableViewDelegate, UITableViewDataSource, SKStoreProductViewControllerDelegate>

@end
