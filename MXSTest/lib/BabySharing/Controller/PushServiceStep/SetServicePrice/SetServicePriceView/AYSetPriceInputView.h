//
//  AYSetPriceInputView.h
//  BabySharing
//
//  Created by Alfred Yang on 11/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYSetPriceInputView : UIView

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, assign) BOOL isHideSep;

- (instancetype)initWithSign:(NSString*)sign;

@end
