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
    
//    tableView.backgroundColor = UIColorFromHex(0xdc8ddc);
//    [UIColor colorWithRed:(((0xdc8ddc & 0xFF0000) >> 16 )) / 255.0 green:((( 0xdc8ddc & 0xFF00 ) >> 8 )) / 255.0 blue:(( 0xdc8ddc & 0xFF )) / 255.0 alpha:1.0];
    
	itemArr = @[@"Animetion", @"Decoder", @"Waterfall", @"Page", @"Closer"];
	tableView.dlg.dlgData = itemArr;
	
	[tableView registerClsaaWithCellName:@"MXSTableViewCell" RowHeight:64 andController:self];
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
	NSNumber *row = [args objectForKey:@"row"];
	NSLog(@"%ld", row.integerValue);
	[[MXSVCExchangeCmd shared] fromVC:self pushVC:[[@"MXS" stringByAppendingString:[itemArr objectAtIndex:row.intValue]] stringByAppendingString:@"VC"] withArgs:nil];
	
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
