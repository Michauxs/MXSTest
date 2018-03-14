//
//  AYBOrderTimeDelegate.h
//  BabySharing
//
//  Created by Alfred Yang on 27/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYCommand.h"
#import "AYViewBase.h"
#import "AYViewController.h"
#import "AYCalendarDate.h"

@interface AYBOrderTimeDelegate : NSObject <AYDelegateBase, UICollectionViewDelegate, UICollectionViewDataSource>

/** 公历某个月的天数 */
@property (nonatomic, assign) NSInteger monthNumber;
/** 某天是星期几 */
@property (nonatomic, assign) NSInteger dayOfWeek;
/** 月日，星期几 */
@property (nonatomic, strong) NSMutableArray *monthNumberAndWeek;
@property (nonatomic, strong) AYCalendarDate *useTime;

@end
