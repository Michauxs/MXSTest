//
//  AYCourseSignView.h
//  BabySharing
//
//  Created by Alfred Yang on 14/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYCourseSignView : UIView

@property (nonatomic, strong) NSString *sign;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString*)title;

- (void)setSelectStatus;
- (void)setUnselectStatus;

@end
