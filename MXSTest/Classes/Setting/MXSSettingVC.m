//
//  MXSSettingVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSSettingVC.h"

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
	[self.view addSubview:DZWebView];
	
	NSString *urlStr;
	urlStr = @"https://www.dianping.com/search/category/2/70/g188p1";
//	urlStr = @"https://www.dianping.com/shop/76974050";
	NSURL *url = [NSURL URLWithString:urlStr];
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
	
}

- (void)didGetEBtn {
	
	//	获取所有html:
	NSString *js_html = @"document.documentElement.innerHTML";
	NSString *htmlStr = [DZWebView stringByEvaluatingJavaScriptFromString:js_html];
//	NSLog(@"%@", htmlStr);
	
//	获取网页title:
	NSString *js_title = @"document.title";
	NSString *titleStr = [DZWebView stringByEvaluatingJavaScriptFromString:js_title];
	NSLog(@"%@", titleStr);
	
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
					NSLog(@"name:%@\n", [nameNode rawContents]);
				}
			}
			
			
			NSArray *addrNodes = [liNode findChildTags:@"span"];
			for (HTMLNode *addrNode in addrNodes) {
				if ([[addrNode getAttributeNamed:@"class"] isEqualToString:@"key-list"]) {
					NSLog(@"addr:%@\n", [addrNode rawContents]);
				}
			}
			
		}
	}
}

#pragma mark -- UIWebdelegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//	
//	//判断是否是单击
//	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//		NSURL *url = [request URL];
//		NSURLRequest *request = [NSURLRequest requestWithURL:url];
//		[DZWebView loadRequest:request];
//		
////		iPhone自带Safari
////		if([[UIApplication sharedApplication]canOpenURL:url]) {
////			[[UIApplication sharedApplication]openURL:url];
////		}
//		return NO;
//	}
//	return YES;
//}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	getElementBtn.hidden = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	getElementBtn.hidden = NO;
	[self didGetEBtn];
}


/*-----------------------------------------------------------------------------------------------------------*/

- (void)requestDataWithNameAndPsw {
	
	NSString *userName = @"mymadeupuser";
	NSString *password = @"1234";
	NSString *url = @"https://www.dianping.com/search/category/2/70/g188p1";
	
	NSString *postString = [[NSString alloc] initWithFormat:@"bor_id=%@&bor_verification=%@&url=%@",userName, password, url];
	NSLog (@"NSString postString = %@\n\n", postString);
	
	// Create the URL request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:@"https://mywebsite.com/somthing/"]];
	NSLog (@"NSString NSMutableURLRequest = %@\n\n", request);
	
	NSData *requestData = [postString dataUsingEncoding:NSASCIIStringEncoding];
	[request setHTTPBody: requestData];  // apply the post data to be sent
	NSLog (@"NSData requestData = %@\n\n", requestData);
	
	NSURLResponse *response;  // holds the response from the server
	NSLog (@"NSURLResponse response = %@\n\n", response);
	
	NSError *error;   // holds any errors
	NSLog (@"NSError error = %@\n\n", error);
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&error];  // call the URL
//	NSData *returnData = [NSURLSession ]
	NSLog (@"NSData returnedData = %@\n\n", returnData);
	
	NSString *dataReturned = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
	NSLog(@"returned htmlASCII is:  %@\n\n", dataReturned);
	
	NSString *dataReturned2 = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	NSLog(@"returned htmlUTF8 is:  %@\n\n", dataReturned2);
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
