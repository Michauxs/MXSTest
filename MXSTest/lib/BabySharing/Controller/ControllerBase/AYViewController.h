//
//  AYViewController.h
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AYControllerBase.h"
#import "AYResourceManager.h"
#import "DongDaTabBar.h"
#import "AYViewBase.h"
#import "AYFactoryManager.h"
#import "AYControllerActionDefines.h"

#import "AYBtmTipView.h"

@protocol AYViewBase;
@interface AYViewController : UIViewController <AYControllerBase>
@property (nonatomic, weak) id<AYViewBase> loading;

- (void)clearController;
- (void)BtmAlertOtherBtnClick;
- (void)tabBarVCSelectIndex:(NSInteger)index;

- (id)HideBtmAlert:(id)args;
- (id)startRemoteCall:(id)obj;
- (id)endRemoteCall:(id)ob;
@end
