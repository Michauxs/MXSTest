//
//  AYSetCapacityOptView.h
//  BabySharing
//
//  Created by Alfred Yang on 19/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYSetCapacityOptView : UIView

- (instancetype)initWithTitle:(NSString*)titleStr andSubTitle:(NSString*)subTitle andtionArgs:(NSString*)args;

- (void)setSubTitleWithString:(NSString*)subString;

@end
