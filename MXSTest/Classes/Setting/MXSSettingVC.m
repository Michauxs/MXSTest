//
//  MXSSettingVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSSettingVC.h"
#import "MXSAboutVC.h"
#import "MXSWebDianpingHandle.h"

@interface MXSSettingVC () <UIWebViewDelegate>

@end

@implementation MXSSettingVC {
	UIView *animtDisplay;
	CAShapeLayer *animtLayer;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	animtDisplay = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_WIDTH)];
	[self.view addSubview:animtDisplay];
//	[animtDisplay mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.center.equalTo(self.view);
//		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH));
//	}];
	
	UIBezierPath *path = [[UIBezierPath alloc] init];
	[path moveToPoint:CGPointMake(SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.2)];
	[path addLineToPoint:CGPointMake(SCREEN_WIDTH*0.2, SCREEN_WIDTH*0.8)];
	
	animtLayer = [CAShapeLayer layer];
	animtLayer.path = path.CGPath;
	animtLayer.fillColor = [UIColor clearColor].CGColor;
	animtLayer.strokeColor = [Tools themeColor].CGColor;
	animtLayer.lineWidth = 2.f;
	animtLayer.lineCap = kCALineCapRound;
	animtLayer.lineJoin = kCALineJoinRound;
	[animtDisplay.layer addSublayer:animtLayer];
	
	UIButton *ComeOnBtn = [Tools creatUIButtonWithTitle:@"ATK" andTitleColor:[Tools whiteColor] andFontSize:14.f andBackgroundColor:[Tools themeColor]];
	[self.view addSubview:ComeOnBtn];
	[ComeOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.view);
		make.right.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*0.5, 40));
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


- (void)didComeOnBtnClick {
	
}
- (void)didOtherBtnBtnClick {
	
}

#pragma mark -- UIWebdelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	//判断是否是单击
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		
		NSLog(@"%@", [[request URL] absoluteString]);
		
		if ([[[request URL] absoluteString] hasPrefix:@"https://www.dianping.com/shop/"]) {
			
			MXSAboutVC *aboutVC = [[MXSAboutVC alloc] init];
			aboutVC.hidesBottomBarWhenPushed = YES;
			
			NSMutableDictionary *dic_push_args = [[NSMutableDictionary alloc] init];
			[dic_push_args setValue:[request URL] forKey:@"url"];
			aboutVC.push_args = [dic_push_args copy];
			[self.navigationController pushViewController:aboutVC animated:YES];
			
			return NO;
			
		} else {
			return YES;
		}
		
//		iPhone自带Safari
//		if([[UIApplication sharedApplication]canOpenURL:url]) {
//			[[UIApplication sharedApplication]openURL:url];
//		}
	} else
		return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
//	getElementBtn.hidden = YES;
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error { }


@end
