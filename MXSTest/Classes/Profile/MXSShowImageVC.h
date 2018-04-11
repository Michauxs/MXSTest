//
//  MXSShowImageVC.h
//  MXSTest
//
//  Created by Alfred Yang on 8/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSViewController.h"

@interface MXSShowImageVC : MXSViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *showImg;
@property (nonatomic, assign) CGRect popFrame;

@end
