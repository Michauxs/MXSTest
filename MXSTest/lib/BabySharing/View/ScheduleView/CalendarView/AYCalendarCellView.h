//
//  AYCalendarCellView.h
//  BabySharing
//
//  Created by Alfred Yang on 2/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYViewBase.h"

@interface AYCalendarCellView : UIView <AYViewBase>
@property (nonatomic, copy) void (^CellDateBlock)(AYCalendarCellView *dateString);

@property(nonatomic,strong) UILabel *numLabel;
@property(nonatomic,strong) NSString *dateString;
@end
