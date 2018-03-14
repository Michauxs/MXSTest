//
//  AYShadowRadiusView.h
//  BabySharing
//
//  Created by Alfred Yang on 10/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYShadowRadiusView : UIView

@property (nonatomic, strong) UIView *radiusBGView;

- (instancetype)initWithRadius:(CGFloat)radius;

@end
