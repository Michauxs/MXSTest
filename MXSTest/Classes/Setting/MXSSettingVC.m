//
//  MXSSettingVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSSettingVC.h"
#import "MXSAboutVC.h"

@interface MXSSettingVC () <UIWebViewDelegate>

@end

@implementation MXSSettingVC {
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSString *urlStr;
	
	//	//托班
	NSString *categaryUrlStr = @"http://www.dianping.com/search/category/2/70/g20009";
	NSString *fileName = @"urlList_nursery";
	
	NSMutableArray *courseList = [NSMutableArray array];
	for (int i = 1; i < 11; ++i) {
		urlStr = [NSString stringWithFormat:@"%@p%d", categaryUrlStr, i];
		NSArray *subServArr_p = [NodeHandle handUrlListFromCategoryUrl:urlStr];
		[courseList addObjectsFromArray:subServArr_p];
	}
	
	[self writeToPlistFile:courseList withFileName:fileName];
	
	//待存入课程 arr
	NSMutableArray *nurseryArr = [NSMutableArray array];
	
	for (NSDictionary *course in courseList) {
		NSString *course_href = [course valueForKey:@"href"];
		
		//课程参数 ：需mutable 追加参数
		NSMutableDictionary *course_args = [[NodeHandle handNodeWithNurseryUrl:course_href] mutableCopy];
		[nurseryArr addObject:[course_args copy]];
		
	}
	
	[self writeToPlistFile:[nurseryArr copy] withFileName:[NSString stringWithFormat:@"courses_%@", [[fileName componentsSeparatedByString:@"_"] lastObject]]];
	
}

- (void)writeToPlistFile:(id)info withFileName:(NSString*)fileName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path = [paths objectAtIndex:0];
	NSString *filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
	[info writeToFile:filename atomically:YES];
	
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
