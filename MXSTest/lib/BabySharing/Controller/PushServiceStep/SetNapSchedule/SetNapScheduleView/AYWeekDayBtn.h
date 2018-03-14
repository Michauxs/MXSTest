//
//  AYWeekDayBtnView.h
//  BabySharing
//
//  Created by Alfred Yang on 22/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : int {
	WeekDayBtnStateNormal = 0,
	WeekDayBtnStateSelected = 1,
	WeekDayBtnStateSeted = 2,
	WeekDayBtnStateSmall = 3,
	WeekDayBtnStateNormalAnimat = 4,
} WeekDayBtnState;

@interface AYWeekDayBtn : UIButton

@property(nonatomic, assign) WeekDayBtnState states;

- (instancetype)initWithTitle:(NSString*)title;

@end
