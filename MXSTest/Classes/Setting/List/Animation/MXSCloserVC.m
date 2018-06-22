//
//  MXSCloserVC.m
//  MXSTest
//
//  Created by Sunfei on 2018/6/22.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "MXSCloserVC.h"
#import "MXSSectorView.h"

@interface MXSCloserVC ()

@end

@implementation MXSCloserVC {
    UIView *animtDisplay;
    
//    CAShapeLayer *leftLayer;
//    CAShapeLayer *rightLayer;
//    CAShapeLayer *topLayer;
//    CAShapeLayer *btmLayer;
    CALayer *leftLayer;
    CALayer *rightLayer;
    CALayer *topLayer;
    CALayer *btmLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CGFloat unitWidth = 50;
//    CGPoint centerPoint = CGPointMake(SCREEN_WIDTH*0.5, SCREEN_HEIGHT*0.5);
    
    CGFloat Width = SCREEN_WIDTH;
    CGFloat radius = Width*0.5;
    
    animtDisplay = [[UIView alloc] init];
    [self.view addSubview:animtDisplay];
    [animtDisplay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(Width, Width));
    }];
    animtDisplay.layer.cornerRadius = radius;
    animtDisplay.clipsToBounds = YES;
    animtDisplay.backgroundColor = [UIColor theme];
    
    topLayer = [CAShapeLayer layer];
    {
//        UIBezierPath *path = [[UIBezierPath alloc] init];
//        [path addArcWithCenter:CGPointMake(0,0) radius:radius startAngle:M_PI endAngle:M_PI * 2 clockwise:YES];
//        [path moveToPoint:CGPointMake(radius, 0)];
//        [path addQuadCurveToPoint:CGPointMake(-radius, 0) controlPoint:CGPointMake(0, -radius)];
//        [path addLineToPoint:CGPointMake(radius,0)];
//        topLayer.path = path.CGPath;
//        topLayer.fillColor = [UIColor random].CGColor;
        topLayer.anchorPoint = CGPointMake(1, 1);
        topLayer.frame = CGRectMake(-radius, -radius, Width, radius);
        topLayer.backgroundColor = [UIColor random].CGColor;
        
    }
    [animtDisplay.layer addSublayer:topLayer];
    
    
    leftLayer = [CAShapeLayer layer];
    {
//        UIBezierPath *path = [[UIBezierPath alloc] init];
//        [path addArcWithCenter:CGPointMake(0,Width) radius:radius startAngle:M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES];
//        [path addLineToPoint:CGPointMake(0,Width)];
//        leftLayer.path = path.CGPath;
//        leftLayer.fillColor = [UIColor random].CGColor;
        leftLayer.anchorPoint = CGPointMake(1, 0);
        leftLayer.frame = CGRectMake(-radius, radius, radius, Width);
        leftLayer.backgroundColor = [UIColor random].CGColor;
        
    }
    [animtDisplay.layer addSublayer:leftLayer];
    
    btmLayer = [CAShapeLayer layer];
    {
//        UIBezierPath *path = [[UIBezierPath alloc] init];
//        [path addArcWithCenter:CGPointMake(Width, Width) radius:radius startAngle:0 endAngle:M_PI clockwise:YES];
////        [path addLineToPoint:CGPointMake(0,0)];
//        btmLayer.path = path.CGPath;
//        btmLayer.fillColor = [UIColor random].CGColor;
        btmLayer.anchorPoint = CGPointMake(0, 0);
        btmLayer.frame = CGRectMake(radius, Width, Width, radius);
        btmLayer.backgroundColor = [UIColor random].CGColor;
        
    }
    [animtDisplay.layer addSublayer:btmLayer];
    
    rightLayer = [CAShapeLayer layer];
    {
//        UIBezierPath *path = [[UIBezierPath alloc] init];
//        [path addArcWithCenter:CGPointMake(Width,0) radius:radius startAngle:-M_PI_2 endAngle:M_PI_2 clockwise:YES];
////        [path addLineToPoint:CGPointMake(0,0)];
//        rightLayer.path = path.CGPath;
//        rightLayer.fillColor = [UIColor random].CGColor;
        rightLayer.anchorPoint = CGPointMake(0, 1);
        rightLayer.frame = CGRectMake(Width, -radius, radius, Width);
        rightLayer.backgroundColor = [UIColor random].CGColor;
        
    }
    [animtDisplay.layer addSublayer:rightLayer];
    
//    MXSSectorView *sectorTop = [[MXSSectorView alloc] initWithFrame:CGRectMake(50, 150, 100, 50) color:[UIColor random]];
//    [self.view addSubview:sectorTop];
    
    UIButton *ComeOnBtn = [Tools creatBtnWithTitle:@"ATK" titleColor:[Tools whiteColor] fontSize:14.f backgroundColor:[Tools theme]];
    [self.view addSubview:ComeOnBtn];
    [ComeOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(Width*0.5, 49));
    }];
    [ComeOnBtn addTarget:self action:@selector(didComeOnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *otherBtn = [Tools creatBtnWithTitle:@"BAC" titleColor:[Tools whiteColor] fontSize:14.f backgroundColor:[Tools darkBackgroundColor]];
    [self.view addSubview:otherBtn];
    [otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.size.equalTo(ComeOnBtn);
    }];
    [otherBtn addTarget:self action:@selector(didOtherBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
}


- (void)didComeOnBtnClick {
    for (int i = 0; i < 4; ++i) {
        CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = 2.5f;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        
        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
        if (i == 0) {
            animation.fromValue = [NSNumber numberWithFloat:0.f];
            animation.toValue = [NSNumber numberWithFloat:-M_PI_2];
            [topLayer addAnimation:animation forKey:nil];
        } else if (i == 1) {
            animation.fromValue = [NSNumber numberWithFloat:0.f];
            animation.toValue = [NSNumber numberWithFloat:-M_PI_2];
            [leftLayer addAnimation:animation forKey:nil];
        } else if (i == 2) {
            animation.fromValue = [NSNumber numberWithFloat:0.f];
            animation.toValue = [NSNumber numberWithFloat:-M_PI_2];
            [btmLayer addAnimation:animation forKey:nil];
        } else if (i == 3) {
            animation.fromValue = [NSNumber numberWithFloat:0.f];
            animation.toValue = [NSNumber numberWithFloat:-M_PI_2];
            [rightLayer addAnimation:animation forKey:nil];
        }
        
    }
    
}

- (void)didOtherBtnBtnClick {
    for (int i = 0; i < 4; ++i) {
        CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.duration = 2.5f;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        
        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
        if (i == 0) {
            animation.fromValue = [NSNumber numberWithFloat:-M_PI_2];
            animation.toValue = [NSNumber numberWithFloat:0.f];
            [topLayer addAnimation:animation forKey:nil];
        } else if (i == 1) {
            animation.fromValue = [NSNumber numberWithFloat:-M_PI_2];
            animation.toValue = [NSNumber numberWithFloat:0.f];
            [leftLayer addAnimation:animation forKey:nil];
        } else if (i == 2) {
            animation.fromValue = [NSNumber numberWithFloat:-M_PI_2];
            animation.toValue = [NSNumber numberWithFloat:0.f];
            [btmLayer addAnimation:animation forKey:nil];
        } else if (i == 3) {
            animation.fromValue = [NSNumber numberWithFloat:-M_PI_2];
            animation.toValue = [NSNumber numberWithFloat:0.f];
            [rightLayer addAnimation:animation forKey:nil];
        }
        
    }
    
}
@end
