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
		
		
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"block_right "]) {
			
			HTMLNode *intruNode = [divNode findChildTag:@"span"];
			NSString *intru = [NodeHandle extractionStringFromString:[intruNode rawContents]];
			intru = [NodeHandle replacingOccurrencesString:intru];
			NSLog(@"intru:%@\n", intru);
			[dic_service setValue:intru forKey:@"intru"];
			
		} //end: class = block_right
		
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
				NSLog(@"promote_href__:%@", href);
				
				NSString *title = [aNode getAttributeNamed:@"title"];
				NSLog(@"promote_course:%@", title);
				
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
					comment = [NodeHandle replacingOccurrencesString:comment];
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

+ (NSDictionary *)handNodeWithNurseryUrl:(NSString*)urlStr {
	
	NSString *htmlStr = [self requestHtmlStringWith:urlStr];
	//	NSLog(@"%@", htmlStr);
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
	}
	
	//dic Nursery
	NSMutableDictionary *dic_nursery = [[NSMutableDictionary alloc] init];
	
	HTMLNode *bodyNode = [parser body];
	
	NSMutableArray *commentsArr = [NSMutableArray array];
	NSArray *liNodes = [bodyNode findChildTags:@"li"];
	for (HTMLNode *liNode in liNodes) {
		NSMutableDictionary *dic_comm = [[NSMutableDictionary alloc] init];
		
		if ([[liNode getAttributeNamed:@"class"] isEqualToString:@"comment-list-item"]) {
			NSArray *aNodes = [liNode findChildTags:@"a"];
			for (HTMLNode *aNode in aNodes) {
				if ([[aNode getAttributeNamed:@"class"] isEqualToString:@"J_card"]) {
					NSString *user = [NodeHandle extractionStringFromString:[aNode rawContents]];
					NSLog(@"user:%@", user);
					[dic_comm setValue:user forKey:@"comment_user"];
				}
			}
			
			
			NSArray *commentNodes = [liNode findChildTags:@"div"];
			for (HTMLNode *commentNode in commentNodes) {
				if ([[commentNode getAttributeNamed:@"class"] isEqualToString:@"comment-entry"]) {
					
					HTMLNode *comtextNode = [commentNode findChildTag:@"div"];
					NSString *comtext = [NodeHandle extractionStringFromString:[comtextNode rawContents]];
					NSLog(@"comm:%@", comtext);
					[dic_comm setValue:comtext forKey:@"comment_cont"];
					
				}
			}
			
			[commentsArr addObject:dic_comm];
			
		}
	}
	[dic_nursery setValue:commentsArr forKey:@"comments"];
	
	NSArray *divNodes = [bodyNode findChildTags:@"div"];
	for (HTMLNode *divNode in divNodes) {
		
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"shop-name"]) {
			HTMLNode *hNode = [divNode findChildTag:@"h1"];
			NSString *name = [self extractionStringFromString:[hNode rawContents]];
			NSLog(@"name:%@", name);
			[dic_nursery setValue:name forKey:@"name"];
		}
		
		NSArray *spanNodes = [divNode findChildTags:@"span"];
		for (HTMLNode *spanNode in spanNodes) {
			if ([[spanNode getAttributeNamed:@"itemprop"] isEqualToString:@"street-address"]) {
				NSString *addr = [self extractionStringFromString:[spanNode rawContents]];
				NSLog(@"addr:%@", addr);
				[dic_nursery setValue:addr forKey:@"address"];
			}
		}
		
		
		NSArray *ddNodes = [divNode findChildTags:@"strong"];
		for (HTMLNode *ddNode in ddNodes) {
			if ([[ddNode getAttributeNamed:@"itemprop"] isEqualToString:@"tel"]) {
				NSString *phone = [self extractionStringFromString:[ddNode rawContents]];
				NSLog(@"phon:%@", phone);
				[dic_nursery setValue:phone forKey:@"phone"];
			}
		}
		
	}
	
	return [dic_nursery copy];
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
	
	//dic 推荐课
	NSMutableDictionary *dic_promote = [[NSMutableDictionary alloc] init];
	
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
		
		NSMutableDictionary *dic_property = [[NSMutableDictionary alloc] init];
		if ([[divNode getAttributeNamed:@"id"] isEqualToString:@"J_boxAgraph"]) {
			NSArray *tdNodes = [divNode findChildTags:@"td"];
			
			if (tdNodes.count != 0) {
				for (int i = 0; i < tdNodes.count ; ++i) {
					
					NSArray *contDivNodes = [[tdNodes objectAtIndex:i] findChildTags:@"div"];
					
					if (contDivNodes.count != 0) {
						for (HTMLNode *contDivNode in contDivNodes) {
							if ([[contDivNode getAttributeNamed:@"class"] isEqualToString:@"cont"]) {
								NSString *property = [NodeHandle extractionStringFromString:[contDivNode rawContents]];
								NSLog(@"property:%@", property);
								if (property) {
									NSString *key_value ;
									if (i == 0) {
										key_value = @"course_cat";
									} else if (i == 1) {
										key_value = @"boundary";
									} else if (i == 2) {
										key_value = @"work_type";
									} else if (i == 3) {
										key_value = @"ishas_tesing";
									} else if (i == 4) {
										key_value = @"course_numb";
									} else if (i == 5) {
										key_value = @"course_length";
									} else if (i == 6) {
										key_value = @"area";
									} else if (i == 7) {
										key_value = @"course_intru";
									} else if (i == 8) {
										key_value = @"techer_info";
									}
									[dic_property setValue:property forKey:key_value];
									//							[propertyArr addObject:property];
								}
							}
						}
					} //end  ? contDivs.cont == 0
					
				}	//end for(i++)
				
			}	//end .count ? == 0
			
			
			NSArray *liNodes = [divNode findChildTags:@"li"];
			NSMutableArray *imgSrcArr = [NSMutableArray array];
			if (liNodes.count != 0) {
				for (HTMLNode *liNode in liNodes) {
					HTMLNode *imgNode = [liNode findChildTag:@"img"];
					NSString *img_src = [imgNode getAttributeNamed:@"data-lazyload"];
					img_src = [@"https:" stringByAppendingString:img_src];
					NSLog(@"%@", img_src);
					
					if (img_src) {
						[imgSrcArr addObject:img_src];
					}
				}
				
			} //end .count ? == 0
			
			[dic_property setValue:imgSrcArr forKey:@"imgs_src"];
			[dic_promote setValue:dic_property forKey:@"properties"];
			
		}
		
	}
	
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//	NSString *path = [paths objectAtIndex:0];
//	NSString *filename = [path stringByAppendingPathComponent:@"promote.plist"];
	//	写到plist文件里
//	[dic_promote writeToFile:filename atomically:YES];
	
	return dic_promote;
}

+ (NSArray *)handUrlListFromCategoryUrl:(NSString*)url {
	
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
					realAddr = [NodeHandle replacingOccurrencesString:realAddr];
					NSLog(@"addr:%@\n", realAddr);
				}
			}
			
		}
	}
	return listArr;
}


#pragma mark -- methed
+ (NSString *)replacingOccurrencesString:(NSString*)string {
	string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	return string;
}

+ (NSString*)extractionStringFromString:(NSString*)string {
	
	NSArray *subArrH = [string componentsSeparatedByString:@">"];
	NSArray *subArrE = [string componentsSeparatedByString:@"<"];
	if (subArrH.count == 0 || subArrE.count ==0) {
		return string;
	}
	
	NSInteger index_f = [subArrH.firstObject length];
	NSInteger index_l = string.length - [subArrE.lastObject length];
	
	NSInteger length = index_l - index_f - 2;
	if (length <= 0) {
		length = string.length - index_f - 1;
	}
	
	NSRange realRang = NSMakeRange(index_f + 1, length);
	NSString *extraction = [string substringWithRange:realRang];
	return extraction;
}

+ (NSString *)delHTMLTag:(NSString *)html {
	
	NSScanner *theScanner;
	NSString *text = nil;
	
	theScanner = [NSScanner scannerWithString:html];
	
	while ([theScanner isAtEnd] == NO) {
		// find start of tag
		[theScanner scanUpToString:@"<" intoString:NULL];
		// find end of tag
		[theScanner scanUpToString:@">" intoString:&text];
		// replace the found tag with a space
		
		html = [html stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@>", text] withString:@""];
	}
	
	NSLog(@"HTML-Contents:%@\n",html);
	return html;
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

+ (void)writeToPlistFile:(id)info withFileName:(NSString*)fileName {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path = [paths objectAtIndex:0];
	NSString *filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", fileName]];
	[info writeToFile:filename atomically:YES];
	
}

+ (void)writeToJsonFile:(id)info withFileName:(NSString*)fileName {
	
	NSData *data = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *path = [paths objectAtIndex:0];
	NSString *filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", fileName]];
	[data writeToFile:filename atomically:YES];
	
}

@end
