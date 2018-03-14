//
//  AYNursaryListDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 2/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYCommand.h"
#import "AYViewBase.h"
#import "AYFactoryManager.h"
#import "AYProfileHeadCellView.h"
#import "Notifications.h"
#import "AYModelFacade.h"

@interface AYNursaryListDelegate : NSObject <AYDelegateBase, UITableViewDelegate, UITableViewDataSource>

@end
