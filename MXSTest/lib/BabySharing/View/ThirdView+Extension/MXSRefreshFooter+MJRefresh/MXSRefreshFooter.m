//
//  MXSRefreshFooter.m
//  BabySharing
//
//  Created by Alfred Yang on 6/2/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "MXSRefreshFooter.h"

@implementation MXSRefreshFooter

- (UIImageView*)loadingView {
	if (!_loadingView) {
		
		UIImageView *loading = [[UIImageView alloc] init];
		loading.image = IMGRESOURCE(@"loading_0");
		NSMutableArray *ary = [NSMutableArray new];
		for(int i = 0; i < 4; ++i){
			//通过for 循环,把我所有的 图片存到数组里面
			NSString *imageName = [NSString stringWithFormat:@"loading_%d", i];
			UIImage *image = [UIImage imageNamed:imageName];
			[ary addObject:image];
		}
		
		loading.animationImages = ary;
		loading.animationRepeatCount = 0;
		loading.animationDuration = 3.0;
//		loading.frame = CGRectMake((self.mj_w-34)*0.5, (self.mj_h-6)*0.5, 34, 6);
		
		[self addSubview:_loadingView = loading];
	}
	return _loadingView;
}

- (UIImageView*)noMoreDataSign {
	if (!_noMoreDataSign) {
		UIImageView *sign = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"icon_nomore_sign")];
//		sign.frame = CGRectMake((self.mj_w-344)*0.5, (self.mj_h-16)*0.5, 344, 16);
		
		[self addSubview:_noMoreDataSign = sign];
	}
	return  _noMoreDataSign;
}

#pragma mark - 初始化
- (void)willMoveToSuperview:(UIView *)newSuperview
{
	[super willMoveToSuperview:newSuperview];
	
	if (newSuperview) { // 新的父控件
		if (self.hidden == NO) {
			self.scrollView.mj_insetB += self.mj_h;
		}
		
		// 设置位置
		self.mj_y = _scrollView.mj_contentH;
	} else { // 被移除了
		if (self.hidden == NO) {
			self.scrollView.mj_insetB -= self.mj_h;
		}
	}
}

#pragma mark - 过期方法
- (void)setAppearencePercentTriggerAutoRefresh:(CGFloat)appearencePercentTriggerAutoRefresh
{
	self.triggerAutomaticallyRefreshPercent = appearencePercentTriggerAutoRefresh;
}

- (CGFloat)appearencePercentTriggerAutoRefresh
{
	return self.triggerAutomaticallyRefreshPercent;
}

#pragma mark - 实现父类的方法
- (void)prepare
{
	[super prepare];
	
	// 默认底部控件100%出现时才会自动刷新
	self.triggerAutomaticallyRefreshPercent = 0.1;
	
	// 设置为默认状态
	self.automaticallyRefresh = YES;
	self.noMoreDataSign.hidden = YES;
	self.loadingView.hidden = YES;
}

- (void)placeSubviews {
	
	[super placeSubviews];
	
	self.noMoreDataSign.frame = CGRectMake((self.mj_w-344)*0.5, (self.mj_h-16)*0.5, 344, 16);
	self.loadingView.frame = CGRectMake((self.mj_w-34)*0.5, (self.mj_h-6)*0.5, 34, 6);
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
	[super scrollViewContentSizeDidChange:change];
	
	// 设置位置
//	self.mj_y = self.scrollView.mj_contentH;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
	[super scrollViewContentOffsetDidChange:change];
	
	if ((self.state != MJRefreshStateIdle && self.state != MJRefreshStateResetIdle) || !self.automaticallyRefresh || self.mj_y == 0) return;
	
	if (_scrollView.mj_insetT + _scrollView.mj_contentH > _scrollView.mj_h) { // 内容超过一个屏幕
		// 这里的_scrollView.mj_contentH替换掉self.mj_y更为合理
		if (_scrollView.mj_offsetY >= _scrollView.mj_contentH - _scrollView.mj_h + self.mj_h * self.triggerAutomaticallyRefreshPercent + _scrollView.mj_insetB - self.mj_h) {
			// 防止手松开时连续调用
			CGPoint old = [change[@"old"] CGPointValue];
			CGPoint new = [change[@"new"] CGPointValue];
			if (new.y <= old.y) return;
			
			// 当底部刷新控件完全出现时，才刷新
			[self beginRefreshing];
		}
	}
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
	[super scrollViewPanStateDidChange:change];
	
	if (self.state == MJRefreshStateNoMoreData) {
		return;
	}
	
	if (self.state != MJRefreshStateIdle) return;
	
	if (_scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {// 手松开
		if (_scrollView.mj_insetT + _scrollView.mj_contentH <= _scrollView.mj_h) {  // 不够一个屏幕
			if (_scrollView.mj_offsetY >= - _scrollView.mj_insetT) { // 向上拽
				[self beginRefreshing];
			}
		} else { // 超出一个屏幕
			if (_scrollView.mj_offsetY >= _scrollView.mj_contentH + _scrollView.mj_insetB - _scrollView.mj_h) {
				[self beginRefreshing];
			}
		}
	}
}

@synthesize state = _state;
- (void)setState:(MJRefreshState)state {
	
	MJRefreshState oldState = _state;
	if (state == oldState) return;
	
	if (oldState == MJRefreshStateNoMoreData) {
		if (state != MJRefreshStateResetIdle) {
			return;
		}
	}
	_state = state;
	dispatch_async(dispatch_get_main_queue(), ^{
		[self setNeedsLayout];
	});
//	[super setState:state];
	
//	MJRefreshCheckState
	
	if (state == MJRefreshStateRefreshing) {
		self.loadingView.hidden = NO;
		[self.loadingView startAnimating];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self executeRefreshingCallback];
		});
	} else if (state == MJRefreshStateIdle) {
		self.loadingView.hidden = YES;
		[self.loadingView stopAnimating];
		if (MJRefreshStateRefreshing == oldState) {
			if (self.endRefreshingCompletionBlock) {
				self.endRefreshingCompletionBlock();
			}
		}
	} else if (state == MJRefreshStateNoMoreData) {
		self.noMoreDataSign.hidden = NO;
		self.loadingView.hidden = YES;
		[self.loadingView stopAnimating];
	} else if (state == MJRefreshStateResetIdle) {
		
		self.loadingView.hidden = NO;
		self.noMoreDataSign.hidden = YES;
	}
}

- (void)setHidden:(BOOL)hidden
{
	BOOL lastHidden = self.isHidden;
	
	[super setHidden:hidden];
	
	if (!lastHidden && hidden) {
		self.state = MJRefreshStateIdle;
		
		self.scrollView.mj_insetB -= self.mj_h;
	} else if (lastHidden && !hidden) {
		self.scrollView.mj_insetB += self.mj_h;
		
		// 设置位置
		self.mj_y = _scrollView.mj_contentH;
	}
}
@end

