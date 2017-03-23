//
//  NodeHandle.m
//  MXSTest
//
//  Created by Alfred Yang on 23/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "NodeHandle.h"

@implementation NodeHandle

+ (NSDictionary *)handNodeWithServiceUrl:(NSString*)urlStr {
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
	}
	
	NSMutableDictionary *dic_service = [[NSMutableDictionary alloc] init];
	
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
	
	
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//	NSString *path = [paths objectAtIndex:0];
//	NSString *filename = [path stringByAppendingPathComponent:@"serviceinfo.plist"];
//	
//	//	写到plist文件里
//	[dic_service writeToFile:filename atomically:YES];
	
	return dic_service;
}

+ (NSDictionary *)handNodeWithPromoteUrl:(NSString*)urlStr {
	
	NSString *htmlStr = [self requestHtmlStringWith:urlStr];
//	NSLog(@"%@", htmlStr);
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
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
	
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//	NSString *path = [paths objectAtIndex:0];
//	NSString *filename = [path stringByAppendingPathComponent:@"promote.plist"];
	//	写到plist文件里
//	[dic_promote writeToFile:filename atomically:YES];
	
	return dic_promote;
}

#pragma mark -- methed
+ (NSString*)extractionStringFromString:(NSString*)string {
	
	NSArray *subArrH = [string componentsSeparatedByString:@">"];
	NSArray *subArrE = [string componentsSeparatedByString:@"<"];
	if (subArrH.count == 0 || subArrE.count ==0) {
		return string;
	}
	
	NSInteger index_f = [subArrH.firstObject length];
	NSInteger index_l = string.length - [subArrE.lastObject length];
	
	NSRange realRang = NSMakeRange(index_f + 1, index_l - index_f - 2);
	NSString *extraction = [string substringWithRange:realRang];
	return extraction;
}

+ (NSString*)requestHtmlStringWith:(NSString*)urlStr {
	
	NSURL *url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	// 设置请求方法（默认就是GET请求）
	request.HTTPMethod = @"GET";
	NSURLResponse *response;  // holds the response from the server
	NSError *error;   // holds any errors
	NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&error];  // call the URL
	
	//	NSString *dataReturned = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
	//	NSLog(@"returned htmlASCII is:  %@\n\n", dataReturned);
	
	NSString *dataReturned2 = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	return dataReturned2;
}


+ (NSArray *)getUrlListFromCategoryUrl:(NSString*)url {
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:url];
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
	}
	
	NSMutableArray *listArr = [NSMutableArray array];
	
	HTMLNode *bodyNode = [parser body];
	NSArray *liNodes = [bodyNode findChildTags:@"div"];
	for (HTMLNode *liNode in liNodes) {
		
		if ([[liNode getAttributeNamed:@"class"] isEqualToString:@"info baby-info"]) {
			
			NSArray *nameNodes = [liNode findChildTags:@"a"];
			for (HTMLNode *nameNode in nameNodes) {
				if ([[nameNode getAttributeNamed:@"class"] isEqualToString:@"shopname"]) {
					NSString *href = [nameNode getAttributeNamed:@"href"];
					href = [@"https://www.dianping.com" stringByAppendingString:href];
					NSLog(@"href:%@", href);
					
					NSString *nameStr = [nameNode getAttributeNamed:@"title"];
					NSLog(@"name:%@\n", nameStr);
					
					NSMutableDictionary *dic_info = [[NSMutableDictionary alloc] init];
					[dic_info setValue:href forKey:@"href"];
					[dic_info setValue:nameStr forKey:@"name"];
					[listArr addObject:dic_info];
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
	return listArr;
}

@end
