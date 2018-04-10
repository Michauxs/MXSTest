//
//  MXSAnimetionVC.m
//  MXSTest
//
//  Created by Alfred Yang on 2/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSAnimetionVC.h"

@interface MXSAnimetionVC ()

@end

@implementation MXSAnimetionVC {
	
	UIView *animtDisplay;
	
	CAShapeLayer *leftLayer;
	CAShapeLayer *rightLayer;
	CAShapeLayer *cirTopLayer;
	CAShapeLayer *cirBtmLayer;
	
	CGFloat animatDuration;
}

- (void)ReceiveCmdArgsActionPost:(id)args {
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	animatDuration = 4;
	animtDisplay = [[UIView alloc] init];
	[self.view addSubview:animtDisplay];
	[animtDisplay mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
	}];
	
	CGFloat Width = SCREEN_WIDTH;
	leftLayer = [CAShapeLayer layer];
	UIBezierPath *path = [[UIBezierPath alloc] init];
	[path moveToPoint:CGPointMake(Width*0.2, Width*0.8)];
	[path addLineToPoint:CGPointMake(Width*0.2, Width*0.2)];
	leftLayer.path = path.CGPath;
	leftLayer.fillColor = [UIColor clearColor].CGColor;
	leftLayer.strokeColor = [Tools theme].CGColor;
	leftLayer.lineWidth = 4;
	leftLayer.lineCap = kCALineCapRound;
	leftLayer.lineJoin = kCALineJoinRound;
	leftLayer.strokeEnd = 0;
	[animtDisplay.layer addSublayer:leftLayer];
	
	rightLayer = [CAShapeLayer layer];
	UIBezierPath *path_r = [[UIBezierPath alloc] init];
	[path_r moveToPoint:CGPointMake(Width*0.8, Width*0.2)];
	[path_r addLineToPoint:CGPointMake(Width*0.8, Width*0.8)];
	rightLayer.path = path_r.CGPath;
	rightLayer.fillColor = [UIColor clearColor].CGColor;
	rightLayer.strokeColor = [Tools theme].CGColor;
	rightLayer.lineWidth = 4;
	rightLayer.lineCap = kCALineCapRound;
	rightLayer.lineJoin = kCALineJoinRound;
	rightLayer.strokeEnd = 1;
	[animtDisplay.layer addSublayer:rightLayer];
	
	cirTopLayer = [CAShapeLayer layer];
	UIBezierPath *path_cir = [[UIBezierPath alloc] init];
//	[path_cir moveToPoint:CGPointMake(Width*0.8, Width*0.8)];
	[path_cir addArcWithCenter:CGPointMake(Width*0.5, Width*0.2) radius:Width*0.3 startAngle:M_PI endAngle:M_PI*2 clockwise:YES];
	cirTopLayer.path = path_cir.CGPath;
	cirTopLayer.fillColor = [UIColor clearColor].CGColor;
	cirTopLayer.strokeColor = [Tools theme].CGColor;
	cirTopLayer.lineWidth = 4;
	cirTopLayer.lineCap = kCALineCapRound;
	cirTopLayer.lineJoin = kCALineJoinRound;
	[animtDisplay.layer addSublayer:cirTopLayer];
	
	cirBtmLayer = [CAShapeLayer layer];
	UIBezierPath *path_cir_b = [[UIBezierPath alloc] init];
//	UIBezierPath *path_cir_b = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Width*0.5, Width*0.8) radius:Width*0.3 startAngle:0 endAngle:M_PI clockwise:YES];
//	[path_cir_b moveToPoint:CGPointMake(Width*0.8, Width*0.8)];
	[path_cir_b addArcWithCenter:CGPointMake(Width*0.5, Width*0.8) radius:Width*0.3 startAngle:0 endAngle:M_PI clockwise:YES];
	cirBtmLayer.path = path_cir_b.CGPath;
	cirBtmLayer.fillColor = [UIColor clearColor].CGColor;
	cirBtmLayer.strokeColor = [Tools theme].CGColor;
	cirBtmLayer.lineWidth = 4;
	cirBtmLayer.lineCap = kCALineCapRound;
	cirBtmLayer.lineJoin = kCALineJoinRound;
	[animtDisplay.layer addSublayer:cirBtmLayer];
	
	cirTopLayer.strokeEnd = 0;
	cirBtmLayer.strokeEnd = 0;
	
	UIButton *ComeOnBtn = [Tools creatUIButtonWithTitle:@"ATK" andTitleColor:[Tools whiteColor] andFontSize:14.f andBackgroundColor:[Tools theme]];
	[self.view addSubview:ComeOnBtn];
	[ComeOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view);
		make.right.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(Width*0.5, 49));
	}];
	[ComeOnBtn addTarget:self action:@selector(didComeOnBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *otherBtn = [Tools creatUIButtonWithTitle:@"BAC" andTitleColor:[Tools whiteColor] andFontSize:14.f andBackgroundColor:[Tools darkBackgroundColor]];
	[self.view addSubview:otherBtn];
	[otherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view);
		make.left.equalTo(self.view);
		make.size.equalTo(ComeOnBtn);
	}];
	[otherBtn addTarget:self action:@selector(didOtherBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

#pragma mark - actions
- (void)animatWitnKey:(NSString*)key OnLayer:(CALayer*)layer From:(CGFloat)fromValue to:(CGFloat)toValue duration:(CGFloat)duration {
	CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:key];
	circleAnimation.duration = duration;
	circleAnimation.fromValue = @(fromValue);
	circleAnimation.toValue = @(toValue);
	circleAnimation.fillMode = kCAFillModeForwards;
	circleAnimation.removedOnCompletion = NO;
	[layer addAnimation:circleAnimation forKey:nil];
}

- (void)didComeOnBtnClick {
	CGFloat duration = 0.5;
	[self animatWitnKey:@"strokeEnd" OnLayer:cirBtmLayer From:0 to:1 duration:duration];
	[self animatWitnKey:@"strokeStart" OnLayer:rightLayer From:0 to:1 duration:duration];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self animatWitnKey:@"strokeStart" OnLayer:cirBtmLayer From:0 to:1 duration:duration];
		[self animatWitnKey:@"strokeEnd" OnLayer:leftLayer From:0 to:1 duration:duration];
	});
	
}

- (void)didOtherBtnBtnClick {
	[[MXSVCExchangeCmd shared] fromVC:self popToRootWithArgs:@1];
}


@end
