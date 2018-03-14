//
//  AYScheduleView.h
//  BabySharing
//
//  Created by Alfred Yang on 2/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"
#import "AYCalendarCellView.h"
#import "AYCommandDefines.h"
#import "AYCalendarCellView.h"
#import "AYCalendarDate.h"
#import "AYDayCollectionCellView.h"

@interface AYScheduleView : UIView <AYViewBase,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic,assign) int year;
@property(nonatomic,assign) int month;
@property(nonatomic,assign) int day;

@property (nonatomic, strong) UICollectionView *calendarContentView;

//@property(nonatomic,copy) NSMutableArray *registerArr;

/** 公历某个月的天数 */
@property (nonatomic, assign) NSInteger monthNumber;
/** 某天是星期几 */
@property (nonatomic, assign) NSInteger dayOfWeek;
/** 月日，星期几 */
@property (nonatomic, strong) NSMutableArray *monthNumberAndWeek;
/** 处理时间的方法 */
@property (nonatomic, strong) AYCalendarDate *useTime;

@end
