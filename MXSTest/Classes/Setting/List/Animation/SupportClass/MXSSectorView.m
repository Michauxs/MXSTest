//
//  MXSSectorView.m
//  MXSTest
//
//  Created by Sunfei on 2018/6/22.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "MXSSectorView.h"

@implementation MXSSectorView {
    UIColor *colorFill;
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color {
    if (self = [super initWithFrame:frame]) {
        colorFill = color;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //设置路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //第一个参数是起点，是圆形的圆心
    //第二个参数是半径
    //第三个参数是起始弧度
    //第四个参数是结束弧度
    //第五个参数是传入yes是顺时针,no为顺时针
    
    CGFloat widthUnit = rect.size.width;
    CGFloat heightUnit = rect.size.height;
    
    [path addArcWithCenter:CGPointMake(widthUnit*0.5, heightUnit) radius:widthUnit*0.5 startAngle:M_PI endAngle:M_PI * 2 clockwise:YES];
    
    [path addLineToPoint:CGPointMake(widthUnit*0.5, heightUnit)];
    
    [colorFill setFill];
    [path fill];
}

@end
