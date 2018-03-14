//
//  AYInsetLabel.h
//  BabySharing
//
//  Created by Alfred Yang on 31/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYInsetLabel : UILabel
@property (nonatomic, assign) UIEdgeInsets textInsets;

- (instancetype)initWithTitle:(NSString*)title andTextColor:(UIColor*)textColor andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor;
@end
