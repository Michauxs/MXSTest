//
//  MXSAboutVC.m
//  MXSTest
//
//  Created by Alfred Yang on 21/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSAboutVC.h"

@implementation MXSAboutVC {
	UILabel *showInfoLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	showInfoLabel = [Tools creatUILabelWithText:nil andTextColor:[Tools blackColor] andFontSize:313.f andBackgroundColor:nil andTextAlignment:0];
	[self.view addSubview:showInfoLabel];
	[showInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self.view);
	}];
	
	NSURL *url = [_push_args objectForKey:@"url"];
	
	NSString *htmlStr = [self requestHtmlStringWith:url];
	[self getElementWithString:htmlStr];
	
	UIButton *popBtn = [Tools creatUIButtonWithTitle:@"🔙返回" andTitleColor:[Tools whiteColor] andFontSize:313.f andBackgroundColor:[UIColor redColor]];
	[self.view addSubview:popBtn];
	[popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.view).offset(20);
		make.bottom.equalTo(self.view).offset(-30-49);
		make.size.mas_equalTo(CGSizeMake(120, 40));
	}];
	[popBtn addTarget:self action:@selector(didPopBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didPopBtnClick {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)getElementWithString:(NSString*)tring {
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:tring error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return;
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path = [paths objectAtIndex:0];
	NSString *filename = [path stringByAppendingPathComponent:@"serviceinfo.plist"];
//	NSFileManager* fm = [NSFileManager defaultManager];
//	[fm createFileAtPath:filename contents:nil attributes:nil];
//	NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
	
	//创建一个dic
	NSMutableDictionary *dic_service = [[NSMutableDictionary alloc] init];
	
	//读文件
//	NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:filename];
//	NSLog(@"dic is:%@",dic2);
	
	HTMLNode *bodyNode = [parser body];
	NSArray *divNodes = [bodyNode findChildTags:@"div"];
	for (HTMLNode *divNode in divNodes) {
		
		if ([[divNode getAttributeNamed:@"id"] isEqualToString:@"J_boxDetail"]) {
			
			NSArray *nameNodes = [divNode findChildTags:@"h1"];
			for (HTMLNode *nameNode in nameNodes) {
				if ([[nameNode getAttributeNamed:@"itemprop"] isEqualToString:@"name itemreviewed"]) {
					NSString *nameStr = [nameNode rawContents];
					NSString *realName = [NodeHandle extractionStringFromString:nameStr];
					NSLog(@"name:%@\n", realName);
					[dic_service setValue:realName forKey:@"name"];
				}
			}
		} //end: id = J_box
		
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"mainpic J_large"]) {
			HTMLNode *aNode = [divNode findChildTag:@"a"];
			NSString *image = [aNode getAttributeNamed:@"href"];
			NSLog(@"img_:%@", image);
			[dic_service setValue:image forKey:@"image"];
		}
		//addr
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"shop-addr"]) {
			NSArray *shop_addr = [divNode findChildTags:@"span"];
			NSString *addr = [[shop_addr firstObject] getAttributeNamed:@"title"];
			NSLog(@"addr:%@", addr);
			[dic_service setValue:addr forKey:@"address"];
		}
		
		//phone
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"shopinfor"]) {
			NSArray *shop_addr = [divNode findChildTags:@"span"];
			NSString *phone = [[shop_addr firstObject] rawContents];
			phone = [NodeHandle extractionStringFromString:phone];
			NSLog(@"phon:%@", phone);
			[dic_service setValue:phone forKey:@"phone"];
		}
		
		//schedule
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"more-class Hide "]) {
			NSArray *g_p = [divNode findChildTags:@"p"];
			for (HTMLNode *pNode in g_p) {
				HTMLNode *aNode = [pNode findChildTag:@"span"];
				NSString *schedule = [NodeHandle extractionStringFromString:[aNode rawContents]];
				if (![schedule containsString:@"刷卡"]) {
					NSLog(@"user:%@", schedule);
					[dic_service setValue:schedule forKey:@"schedule"];
				}
			}
		}
	}
	
	/*
	 comment list
	 */
	NSMutableArray *commentArr = [NSMutableArray array];
	NSMutableArray *promoteArr = [NSMutableArray array];
	for (HTMLNode *divNode in divNodes) {
		
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"pic-tit"]) {
			NSArray *liNodes = [divNode findChildTags:@"li"];
			for (HTMLNode *liNode in liNodes) {
				HTMLNode *aNode = [liNode findChildTag:@"a"];
				NSString *href = [aNode getAttributeNamed:@"href"];
				href = [@"https://www.dianping.com" stringByAppendingString:href];
				NSLog(@"promote_href:%@", href);
				
				NSString *title = [aNode getAttributeNamed:@"title"];
				NSLog(@"promote_course:%@", href);
				
				NSMutableDictionary *dic_prom = [[NSMutableDictionary alloc] init];
				[dic_prom setValue:href forKey:@"promote_href"];
				[dic_prom setValue:title forKey:@"promote_course"];
				
				[promoteArr addObject:dic_prom];
			}
		}
		
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"content"]) {
			NSMutableDictionary *dic_comm = [[NSMutableDictionary alloc] initWithCapacity:2];
		
			NSArray *pNodes = [divNode findChildTags:@"p"];
			for (HTMLNode *pNode in pNodes) {
				if ([[pNode getAttributeNamed:@"class"] isEqualToString:@"name"]) {
					HTMLNode *aNode = [pNode findChildTag:@"a"];
					NSString *user_name = [NodeHandle extractionStringFromString:[aNode rawContents]];
					NSLog(@"user:%@", user_name);
					[dic_comm setValue:user_name forKey:@"user"];
				}
			}
			
			NSArray *contextArr = [divNode findChildTags:@"div"];
			for (HTMLNode *contNode in contextArr) {
				if ([[contNode getAttributeNamed:@"class"] isEqualToString:@"J_brief-cont"]) {
					NSString *comment = [contNode rawContents];
					comment = [NodeHandle extractionStringFromString:comment];
					comment = [comment stringByReplacingOccurrencesOfString:@"\n" withString:@""];
					comment = [comment stringByReplacingOccurrencesOfString:@"\t" withString:@""];
					comment = [comment stringByReplacingOccurrencesOfString:@"\r" withString:@""];
					NSLog(@"comm:%@", comment);
					[dic_comm setValue:comment forKey:@"context"];
				}
			}
			
			if (dic_comm.count != 0) {
				[commentArr addObject:dic_comm];
			}
			
		}
		
		
	}//end: list
	
	[dic_service setValue:commentArr forKey:@"comments"];
	[dic_service setValue:promoteArr forKey:@"promotes"];
	//	写到plist文件里
	[dic_service writeToFile:filename atomically:YES];
	
}

#pragma mark -- UIWebdelegate

/*-----------------------------------------------------------------------------------------------------------*/
//
- (NSString*)requestHtmlStringWith:(NSURL*)url {
	/*
	 *带请求体和url
	 */
	//	NSString *userName = @"mymadeupuser";
	//	NSString *password = @"1234";
	//	NSString *urlStr = @"https://www.dianping.com/search/category/2/70/g188p1";
	//
	//	NSString *postString = [[NSString alloc] initWithFormat:@"bor_id=%@&bor_verification=%@&url=%@",userName, password, urlStr];
	//	NSLog (@"NSString postString = %@\n\n", postString);
	//
	//	// Create the URL request
	//	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:@"https://mywebsite.com/somthing/"]];
	//	NSLog (@"NSString NSMutableURLRequest = %@\n\n", request);
	//
	//	NSData *requestData = [postString dataUsingEncoding:NSASCIIStringEncoding];
	//	[request setHTTPBody: requestData];  // apply the post data to be sent
	//	NSLog (@"NSData requestData = %@\n\n", requestData);
	
	/*
	 *不带请求体，纯url
	 */
//	NSString *urlStr = @"https://www.dianping.com/search/category/2/70/g188p1";
//	urlStr = @"http://www.dianping.com/shop/19568624";
//	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	// 创建URL
//	NSURL *url = [NSURL URLWithString:urlStr];
	
	// 创建请求
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	// 设置请求方法（默认就是GET请求）
	request.HTTPMethod = @"GET";
	
	NSURLResponse *response;  // holds the response from the server
//	NSLog (@"NSURLResponse response = %@\n\n", response);
	
	NSError *error;   // holds any errors
//	NSLog (@"NSError error = %@\n\n", error);
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&error];  // call the URL
//	[NSURLSession ]
//	NSLog (@"NSData returnedData = %@\n\n", returnData);
	
//	NSString *dataReturned = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
//	NSLog(@"returned htmlASCII is:  %@\n\n", dataReturned);
	
	NSString *dataReturned2 = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//	NSLog(@"returned htmlUTF8 is:  %@\n\n", dataReturned2);
	return dataReturned2;
}

@end
