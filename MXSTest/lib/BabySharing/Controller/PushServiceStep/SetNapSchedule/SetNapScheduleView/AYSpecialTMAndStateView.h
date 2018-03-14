//
//  AYSpecialTMAndStateView.h
//  BabySharing
//
//  Created by Alfred Yang on 13/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"
#import "AYSpecialDayCellView.h"

@interface AYSpecialTMAndStateView : UIView <AYViewBase, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSCalendar *calendar;

@end
