//
//  AYScheduleWeekDaysView.h
//  BabySharing
//
//  Created by Alfred Yang on 22/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"
#import "AYWeekDayBtn.h"
#import "AYCalendarDate.h"

@interface AYScheduleWeekDaysView : UIView <AYViewBase, UICollectionViewDelegate, UICollectionViewDataSource>

/** 处理时间的方法 */
@property (nonatomic, strong) AYCalendarDate *useTime;

@end
