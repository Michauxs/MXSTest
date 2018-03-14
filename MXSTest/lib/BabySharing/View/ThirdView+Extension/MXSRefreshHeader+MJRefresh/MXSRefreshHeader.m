//
//  MXSRefreshHeader.m
//  BabySharing
//
//  Created by Alfred Yang on 8/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "MXSRefreshHeader.h"
#import "NSBundle+MJRefresh.h"

@interface MXSRefreshHeader()

@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@property (nonatomic, weak) UIView *progressIndicatorView;
@end

@implementation MXSRefreshHeader {
	CAShapeLayer *progressLayer;
}
#pragma mark - 懒加载子控件

- (UIActivityIndicatorView *)loadingView
{
	if (!_loadingView) {
		UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:self.activityIndicatorViewStyle];
		loadingView.hidesWhenStopped = YES;
		[self addSubview:_loadingView = loadingView];
	}
	return _loadingView;
}

- (UIView*)progressIndicatorView {
	if (!_progressIndicatorView) {
		
		CGFloat Width = 20;
		UIView *indicator = [[UIView alloc] init];
		
		progressLayer = [CAShapeLayer layer];
		UIBezierPath *path_cir = [[UIBezierPath alloc] init];
		[path_cir addArcWithCenter:CGPointMake(Width*0.5, Width*0.5) radius:Width*0.5 startAngle:-M_PI_2 endAngle:M_PI*2+M_PI_2 clockwise:YES];
		progressLayer.path = path_cir.CGPath;
		progressLayer.fillColor = [UIColor clearColor].CGColor;
		progressLayer.strokeColor = [UIColor gary].CGColor;
		progressLayer.lineWidth = 2;
		progressLayer.lineCap = kCALineCapRound;
		progressLayer.lineJoin = kCALineJoinRound;
		
		[indicator.layer addSublayer:progressLayer];
		[self addSubview:_progressIndicatorView = indicator];
	}
	return _progressIndicatorView;
}

#pragma mark - 公共方法
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
	_activityIndicatorViewStyle = activityIndicatorViewStyle;
	
	self.loadingView = nil;
	[self setNeedsLayout];
}

#pragma mark - 重写父类的方法
- (void)prepare
{
	[super prepare];
	
	self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
	[super placeSubviews];
//	self.backgroundColor = [UIColor gary];
	// indicator的中心点
	
	
	CGRect subFrame = CGRectMake((self.mj_w-20)*0.5, (MJRefreshHeaderHeight-20)-self.scrollViewOriginalInset.top, 20, 20);
	self.progressIndicatorView.frame = subFrame;
	
	// 圈圈
	self.loadingView.frame = subFrame;
}

- (void)setState:(MJRefreshState)state
{
	MJRefreshCheckState
	
	// 根据状态做事情
	if (state == MJRefreshStateIdle) {
		if (oldState == MJRefreshStateRefreshing) {
//			self.progressIndicatorView.transform = CGAffineTransformIdentity;
			
			[UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
				self.loadingView.alpha = 0.0;
			} completion:^(BOOL finished) {
				// 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
				if (self.state != MJRefreshStateIdle) return;
				
				self.loadingView.alpha = 1.0;
				[self.loadingView stopAnimating];
				self.progressIndicatorView.hidden = NO;
			}];
		} else {
			[self.loadingView stopAnimating];
			self.progressIndicatorView.hidden = NO;
//			[UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//				self.progressIndicatorView.transform = CGAffineTransformIdentity;
//			}];
		}
	} else if (state == MJRefreshStatePulling) {
		[self.loadingView stopAnimating];
		self.progressIndicatorView.hidden = NO;
//		[UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
//			self.progressIndicatorView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
//		}];
	} else if (state == MJRefreshStateRefreshing) {
		self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
		[self.loadingView startAnimating];
		self.progressIndicatorView.hidden = YES;
	}
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
	[super scrollViewContentOffsetDidChange:change];
	
	CGPoint new = [change[@"new"] CGPointValue];
	CGFloat off_set_y = new.y + 20;
	CGFloat toValue = 0;
	if (off_set_y < 0) {
		
		toValue = -off_set_y / (MJRefreshHeaderHeight-20);
		if (toValue > 1) {
			toValue = 1;
		}
	}
//	NSLog(@"%f",toValue);
	progressLayer.strokeStart = 0.f;
	progressLayer.strokeEnd = toValue;
	
//	[self animatWitnKey:@"strokeEnd" OnLayer:progressLayer From:0 to:toValue duration:0];
	
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
@end

