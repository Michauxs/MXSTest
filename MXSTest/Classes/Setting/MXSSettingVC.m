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
	
	UIWebView *DZWebView;
	UIButton *getElementBtn;
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	DZWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	DZWebView.delegate = self;
	DZWebView.allowsLinkPreview = YES;
	DZWebView.scalesPageToFit = YES;
	[self.view addSubview:DZWebView];
	
	NSString *urlStr;
	urlStr = @"https://www.dianping.com/search/category/2/70/g188";	//教育
	
//托班	http://www.dianping.com/search/category/2/70/g20009
//才艺	http://www.dianping.com/search/category/2/70/g27763
	
//	urlStr = @"https://www.dianping.com/shop/76974050";
//	urlStr = @"http://m.dianping.com/shop/76974050";
//	urlStr = @"https://www.baidu.com";
	NSURL *url = [NSURL URLWithString:urlStr];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[DZWebView loadRequest:request];
	
	getElementBtn = [Tools creatUIButtonWithTitle:@"Go Parsering!" andTitleColor:[Tools whiteColor] andFontSize:313.f andBackgroundColor:[UIColor redColor]];
	[self.view addSubview:getElementBtn];
	[getElementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.view).offset(-20);
		make.bottom.equalTo(self.view).offset(-30-49);
		make.size.mas_equalTo(CGSizeMake(120, 40));
	}];
//	getElementBtn.hidden = YES;
	[getElementBtn addTarget:self action:@selector(didGetEBtn) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)didGetEBtn {
	
	//	获取所有html:
	NSString *js_html = @"document.documentElement.innerHTML";
	NSString *htmlStr = [DZWebView stringByEvaluatingJavaScriptFromString:js_html];
//	NSLog(@"%@", htmlStr);
	
//	获取网页title:
	NSString *js_title = @"document.title";
	NSString *titleStr = [DZWebView stringByEvaluatingJavaScriptFromString:js_title];
	NSLog(@"michauxs:%@", titleStr);
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	
	if (error) {
		NSLog(@"Error: %@", error);
		return;
	}
	
	HTMLNode *bodyNode = [parser body];
	
//	NSArray *inputNodes = [bodyNode findChildTags:@"input"];
//	for (HTMLNode *inputNode in inputNodes) {
//		if ([[inputNode getAttributeNamed:@"name"] isEqualToString:@"input2"]) {
//			NSLog(@"%@", [inputNode getAttributeNamed:@"value"]);
//		}
//	}
	
	NSArray *liNodes = [bodyNode findChildTags:@"div"];
	for (HTMLNode *liNode in liNodes) {
		
		if ([[liNode getAttributeNamed:@"class"] isEqualToString:@"info baby-info"]) {
//			NSLog(@"%@", [liNode rawContents]);
			
			NSArray *nameNodes = [liNode findChildTags:@"a"];
			for (HTMLNode *nameNode in nameNodes) {
				if ([[nameNode getAttributeNamed:@"class"] isEqualToString:@"shopname"]) {
					NSString *href = [nameNode getAttributeNamed:@"href"];
					href = [@"https://www.dianping.com" stringByAppendingString:href];
					NSLog(@"href:%@", href);
					
					NSString *nameStr = [nameNode getAttributeNamed:@"title"];
					NSLog(@"name:%@\n", nameStr);
				}
			}
			
			NSArray *addrNodes = [liNode findChildTags:@"span"];
			for (HTMLNode *addrNode in addrNodes) {
				if ([[addrNode getAttributeNamed:@"class"] isEqualToString:@"key-list"]) {
					NSString *realAddr = [NodeHandle extractionStringFromString:[addrNode rawContents]];
					realAddr = [realAddr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
					realAddr = [realAddr stringByReplacingOccurrencesOfString:@" " withString:@""];
					NSLog(@"addr:%@\n", realAddr);
				}
			}
			
		}
	}
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
	
	[self didGetEBtn];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error { }


@end
