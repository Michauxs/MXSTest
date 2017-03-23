//
//  MXSHomeVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSHomeVC.h"

@implementation MXSHomeVC {
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSString *urlStr;
	urlStr = @"https://www.dianping.com/shop/38050801/wedding/product/1406471";
	NSURL *url = [NSURL URLWithString:urlStr];
	NSString *htmlStr = [self requestHtmlStringWith:url];
	NSLog(@"%@", htmlStr);
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return;
	}
	
	//创建一个dic
	NSMutableDictionary *dic_promote = [[NSMutableDictionary alloc] init];
	
	//读文件
	//	NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
	//	NSLog(@"dic is:%@",dic2);
	
	HTMLNode *bodyNode = [parser body];
	NSArray *divNodes = [bodyNode findChildTags:@"div"];
	for (HTMLNode *divNode in divNodes) {
		
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"textshow"]) {
			
			HTMLNode *nameNode = [divNode findChildTag:@"h3"];
			NSString *nameStr = [nameNode rawContents];
			nameStr = [NodeHandle extractionStringFromString:nameStr];
			NSLog(@"name:%@\n", nameStr);
			[dic_promote setValue:nameStr forKey:@"name"];
			
			NSArray *spanNodes = [divNode findChildTags:@"span"];
			for (HTMLNode *spanNode in spanNodes) {
				if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"priceDisplay"]) {
					NSString *price = [NodeHandle extractionStringFromString:[spanNode rawContents]];
					price = [[price componentsSeparatedByString:@">"] lastObject];
					NSLog(@"%@", price);
					[dic_promote setValue:price forKey:@"price"];
				}
			}
			
		} //end: id = J_box
		
		if ([[divNode getAttributeNamed:@"id"] isEqualToString:@"J_boxAgraph"]) {
			NSArray *contDivNodes = [divNode findChildTags:@"div"];
			NSMutableArray *propertyArr = [NSMutableArray array];
			for (HTMLNode *contDivNode in contDivNodes) {
				if ([[contDivNode getAttributeNamed:@"class"] isEqualToString:@"cont"]) {
					NSString *property = [NodeHandle extractionStringFromString:[contDivNode rawContents]];
					NSLog(@"property:%@", property);
						
					if (property) {
						[propertyArr addObject:property];
					}
				}
			}
			[dic_promote setValue:propertyArr forKey:@"properties"];
			
			NSArray *liNodes = [divNode findChildTags:@"li"];
			NSMutableArray *imgSrcArr = [NSMutableArray array];
			for (HTMLNode *liNode in liNodes) {
				HTMLNode *imgNode = [liNode findChildTag:@"img"];
				NSString *img_src = [imgNode getAttributeNamed:@"data-lazyload"];
				img_src = [@"https:" stringByAppendingString:img_src];
				NSLog(@"%@", img_src);
					
				if (img_src) {
					[imgSrcArr addObject:img_src];
				}
			}
			[dic_promote setValue:imgSrcArr forKey:@"imgs_src"];
			
		}
		
	}
	
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path = [paths objectAtIndex:0];
	NSString *filename = [path stringByAppendingPathComponent:@"promote.plist"];
	//	写到plist文件里
	[dic_promote writeToFile:filename atomically:YES];
	
}

- (void)didGetEBtnClick {
	
}

/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
	
}
/// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
	
}
/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
	
}
/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
	
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//	
//	[self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//	
//	UITouch *touch = [[touches allObjects] firstObject];
//	CGPoint centerP = [touch locationInView:[touch view]];
//	
//	NSString *title = @"You have a new message 002";
//	UILabel *tipsLabel = [Tools creatUILabelWithText:title andTextColor:[Tools themeColor] andFontSize:18.f andBackgroundColor:nil andTextAlignment:1];
//	[self.view addSubview:tipsLabel];
//	tipsLabel.bounds = CGRectMake(0, 0, 300, 30);
//	tipsLabel.center = centerP;
//	
//	MXSViewController *actVC = [self.tabBarController.viewControllers objectAtIndex:1];
//	actVC.tabBarItem.badgeValue = @"2";
//}

- (NSString*)requestHtmlStringWith:(NSURL*)url {
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	// 设置请求方法（默认就是GET请求）
	request.HTTPMethod = @"GET";
	NSURLResponse *response;  // holds the response from the server
	NSError *error;   // holds any errors
	NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&error];  // call the URL
	
	//	NSString *dataReturned = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
	//	NSLog(@"returned htmlASCII is:  %@\n\n", dataReturned);
	
	NSString *dataReturned2 = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	//	NSLog(@"returned htmlUTF8 is:  %@\n\n", dataReturned2);
	return dataReturned2;
}

@end
