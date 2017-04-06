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
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	
	UIButton *ComeOnBtn = [Tools creatUIButtonWithTitle:@"GO!" andTitleColor:[Tools whiteColor] andFontSize:14.f andBackgroundColor:[Tools themeColor]];
	ComeOnBtn.layer.cornerRadius = 20.f;
	ComeOnBtn.clipsToBounds = YES;
	[self.view addSubview:ComeOnBtn];
	[ComeOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
		make.size.mas_equalTo(CGSizeMake(80, 40));
	}];
	[ComeOnBtn addTarget:self action:@selector(didComeOnBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}


- (void)didComeOnBtnClick {
	
	NSString *urlStr;
	
	//	//托班
	NSString *categaryUrlStr = @"http://www.dianping.com/search/category/2/70/g20009";
	NSString *fileName = @"urlList_nursery";
	
	NSMutableArray *courseList = [NSMutableArray array];
	for (int i = 1; i < 11; ++i) {
		urlStr = [NSString stringWithFormat:@"%@p%d", categaryUrlStr, i];
		NSArray *subServArr_p = [MXSWebDianpingHandle handUrlListFromCategoryUrl:urlStr];
		[courseList addObjectsFromArray:subServArr_p];
	}
	
	[MXSFileHandle writeToJsonFile:courseList withFileName:fileName];
	
	//待存入课程 arr
	NSMutableArray *nurseryArr = [NSMutableArray array];
	
	for (NSDictionary *course in courseList) {
		NSString *course_href = [course valueForKey:@"href"];
		
		//课程参数 ：需mutable 追加参数
		NSMutableDictionary *course_args = [[MXSWebDianpingHandle handNodeWithNurseryUrl:course_href] mutableCopy];
		[nurseryArr addObject:[course_args copy]];
		
	}
	
	[MXSFileHandle writeToPlistFile:[nurseryArr copy] withFileName:[NSString stringWithFormat:@"courses_%@", [[fileName componentsSeparatedByString:@"_"] lastObject]]];
	
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
