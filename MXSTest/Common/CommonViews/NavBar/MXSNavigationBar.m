//
//  MXSNavigationBar.m
//  MXSTest
//
//  Created by Alfred Yang on 14/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSNavigationBar.h"

#define BtnWidthHeight              40

@implementation MXSNavigationBar

- (instancetype)initWithVC:(id)vc {
    self = [super init];
    if (self) {
        
        _controller = vc;
        [((MXSViewController*)_controller).view addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(((MXSViewController*)_controller).view).offset(kStatusBarH);
//            make.centerX.equalTo(((MXSViewController*)_controller).view);
            make.left.equalTo(((MXSViewController*)_controller).view);
            make.right.equalTo(((MXSViewController*)_controller).view);
            make.height.mas_equalTo(kNavBarH);
        }];
        
        _statusBg = [[UIView alloc] init];
        [self addSubview:_statusBg];
        [_statusBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_top).offset(0);
            make.centerX.equalTo(self);
            make.right.equalTo(self);
            make.left.equalTo(self);
            make.height.mas_equalTo(kStatusBarH);
        }];
        
        _rightBtn = [UIButton creatBtnWithTitle:@"Set" titleColor:[UIColor theme] fontSize:314 backgroundColor:nil];
        [self addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-5);
            make.centerY.equalTo(self).offset(0);
            make.size.mas_equalTo(CGSizeMake(BtnWidthHeight, BtnWidthHeight));
        }];
        
        _leftBtn = [UIButton creatBtnWithImgName:@"chat_time_label" backgroundColor:nil policy:0];
        [self addSubview:_leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5);
            make.centerY.equalTo(self).offset(0);
            make.size.mas_equalTo(CGSizeMake(BtnWidthHeight, BtnWidthHeight));
        }];
        
        [_leftBtn addTarget:self action:@selector(leftClicked) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn addTarget:self action:@selector(rightClicked) forControlEvents:UIControlEventTouchUpInside];
        
        _titleLabel = [UILabel creatLabelWithText:@"Title" textColor:[UIColor black] fontSize:314 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [self setBackground:[UIColor lightGary]];
        
    }
    return self;
}


- (void)setBackground:(UIColor *)color {
    self.backgroundColor = _statusBg.backgroundColor = color;
}


- (void)leftClicked {
    [self controllerInvokeMethed:@"navBarLeftClick" Args:nil];
}

- (void)rightClicked {
    [self controllerInvokeMethed:@"navBarRightClick" Args:nil];
}

- (void)controllerInvokeMethed:(NSString*)selector Args:(id)args {
    SEL sel = NSSelectorFromString(selector);
    Method m = class_getInstanceMethod([_controller class], sel);
    
    id result = nil;
    if (args != nil) {
        id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
        result = func(_controller, sel, args);
//        args = result;
    } else {
        id (*func)(id, SEL) = (id (*)(id, SEL))method_getImplementation(m);
        result = func(_controller, sel);
    }
}
@end
