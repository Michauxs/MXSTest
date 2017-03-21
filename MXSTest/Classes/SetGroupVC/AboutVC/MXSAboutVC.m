//
//  MXSAboutVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSAboutVC.h"

@implementation MXSAboutVC {
	UIWebView *DZWebView;
	UIButton *getElementBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	DZWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	DZWebView.delegate = self;
	[self.view addSubview:DZWebView];
	
	
	NSURL *url = [_push_args objectForKey:@"url"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[DZWebView loadRequest:request];
	
	getElementBtn = [Tools creatUIButtonWithTitle:@"放爬虫！" andTitleColor:[Tools whiteColor] andFontSize:313.f andBackgroundColor:[UIColor redColor]];
	[self.view addSubview:getElementBtn];
	[getElementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.view).offset(-20);
		make.bottom.equalTo(self.view).offset(-30-49);
		make.size.mas_equalTo(CGSizeMake(120, 40));
	}];
	getElementBtn.hidden = YES;
	[getElementBtn addTarget:self action:@selector(didGetEBtn) forControlEvents:UIControlEventTouchUpInside];

	UIButton *popBtn = [Tools creatUIButtonWithTitle:@"🔙返回" andTitleColor:[Tools whiteColor] andFontSize:313.f andBackgroundColor:[UIColor redColor]];
	[self.view addSubview:popBtn];
	[popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(20);
		make.bottom.equalTo(self.view).offset(-30-49);
		make.size.mas_equalTo(CGSizeMake(120, 40));
	}];
	[popBtn addTarget:self action:@selector(didPopBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)didPopBtnClick {
	[self.navigationController popViewControllerAnimated:NO];
}

- (void)didGetEBtn {
	
	//	获取所有html:
	NSString *js_html = @"document.documentElement.innerHTML";
	NSString *htmlStr = [DZWebView stringByEvaluatingJavaScriptFromString:js_html];
	//	NSLog(@"%@", htmlStr);
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	
	if (error) {
		NSLog(@"Error: %@", error);
		return;
	}
	
	HTMLNode *bodyNode = [parser body];
	
	NSArray *liNodes = [bodyNode findChildTags:@"div"];
	for (HTMLNode *liNode in liNodes) {
		
		if ([[liNode getAttributeNamed:@"class"] isEqualToString:@"info baby-info"]) {
			//			NSLog(@"%@", [liNode rawContents]);
			
			NSArray *nameNodes = [liNode findChildTags:@"a"];
			for (HTMLNode *nameNode in nameNodes) {
				if ([[nameNode getAttributeNamed:@"class"] isEqualToString:@"shopname"]) {
					NSString *nameStr = [nameNode rawContents];
					NSString *realName = [self extractionStringFromString:nameStr];
					
					NSLog(@"name:%@\n", realName);
				}
			}
			
			
			NSArray *addrNodes = [liNode findChildTags:@"span"];
			for (HTMLNode *addrNode in addrNodes) {
				if ([[addrNode getAttributeNamed:@"class"] isEqualToString:@"key-list"]) {
					NSString *realAddr = [self extractionStringFromString:[addrNode rawContents]];
					realAddr = [realAddr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
					realAddr = [realAddr stringByReplacingOccurrencesOfString:@" " withString:@""];
					NSLog(@"addr:%@\n", realAddr);
				}
			}
			
		}
	}
}

- (NSString*)extractionStringFromString:(NSString*)string {
	
	NSArray *subArrH = [string componentsSeparatedByString:@">"];
	NSArray *subArrE = [string componentsSeparatedByString:@"<"];
	NSInteger index_f = [subArrH.firstObject length];
	NSInteger index_l = string.length - [subArrE.lastObject length];
	
	NSRange realRang = NSMakeRange(index_f + 1, index_l - index_f - 2);
	NSString *extraction = [string substringWithRange:realRang];
	return extraction;
}

#pragma mark -- UIWebdelegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//	
//	//判断是否是单击
//	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//		
//		MXSAboutVC *aboutVC = [[MXSAboutVC alloc] init];
//		
//		NSMutableDictionary *dic_push_args = [[NSMutableDictionary alloc] init];
//		[dic_push_args setValue:[request URL] forKey:@"url"];
//		aboutVC.push_args = nil;
//		[self.navigationController pushViewController:aboutVC animated:NO];
//		
//		return NO;
//	} else
//		return YES;
//}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	getElementBtn.hidden = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	getElementBtn.hidden = NO;
	[self didGetEBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
