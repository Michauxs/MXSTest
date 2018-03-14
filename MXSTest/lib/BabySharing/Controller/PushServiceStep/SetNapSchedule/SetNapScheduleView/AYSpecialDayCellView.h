//
//  AYSpecialDayCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 12/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : int {
	AYTMDayStateNull = -9,
	AYTMDayStateGone = -1,
	AYTMDayStateNormal = 0,
	AYTMDayStateNoServ = 1,
	AYTMDayStateInServ = 2,
	AYTMDayStateSpecial = 3,
	AYTMDayStateOpenDay = 4,
	AYTMDayStateSelect = 10,
} AYTMDayState;

@interface AYSpecialDayCellView : UICollectionViewCell

@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSTimeInterval timeSpan;
@property (nonatomic, assign) AYTMDayState state;

- (void)isToday;

@end
