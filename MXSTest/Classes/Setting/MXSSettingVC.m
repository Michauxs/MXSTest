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
	
	MXSTableView *tableView;
	NSArray *itemArr;
}

- (void)ReceiveCmdArgsActionBack:(id)args {
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	tableView = [[MXSTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain andDelegate:nil];
	[self.view addSubview:tableView];
	[tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	itemArr = @[@"Animetion", @"Animetion", @"Animetion"];
	tableView.dlg.dlgData = itemArr;
	
	[tableView registerClsaaWithName:@"MXSTableViewCell" andController:self];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}



- (id)tableViewDidSelectRowAtIndexPath:(id)args {
	NSNumber *row = args;
	NSLog(@"%ld", row.integerValue);
	[[MXSVCExchangeCmd shared] fromVC:self pushVC:[[@"MXS" stringByAppendingString:[itemArr objectAtIndex:row.intValue]] stringByAppendingString:@"VC"] withArgs:@1];
	
	return nil;
}

- (id)cellDeleteFromTable:(id)args {
	
	return nil;
}

#pragma mark - UIWebdelegate
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
