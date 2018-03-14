//
//  OrderTimesOptionView.h
//  BabySharing
//
//  Created by Alfred Yang on 13/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//




#import <UIKit/UIKit.h>

@interface OrderTimesOptionView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, assign) int states;

- (instancetype)initWithTitle:(NSString*)title;

@end
