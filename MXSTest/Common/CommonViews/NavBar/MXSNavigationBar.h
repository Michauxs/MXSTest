//
//  MXSNavigationBar.h
//  MXSTest
//
//  Created by Alfred Yang on 14/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXSNavigationBar : UIView

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIButton *rightBtnB;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *statusBg;

@property (nonatomic, weak) id controller;

- (instancetype)initWithVC:(id)vc;

- (void)setBackground:(UIColor*)color;

@end
