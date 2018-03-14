//
//  AYAdvanceOptView.h
//  BabySharing
//
//  Created by Alfred Yang on 24/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AYFactoryManager.h"
#import "AYResourceManager.h"

@interface AYAdvanceOptView : UIView

@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *access;

- (instancetype)initWithTitle:(UILabel*)titleLabel;

@end
