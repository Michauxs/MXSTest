//
//  MXSWebPekingPeopleHandle.m
//  MXSTest
//
//  Created by Alfred Yang on 6/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSWebPekingPeopleHandle.h"

@implementation MXSWebPekingPeopleHandle

+ (NSArray*)handNodeWithSimple {
//	http://beijing.baixing.com/tiyupeixun/
//	http://beijing.baixing.com/wentipeixun/ 	?page=1
//	http://beijing.baixing.com/youerpeixun/m36088/		xueqian jiaoyu
	
	NSArray *catUrlArr = @[@"http://beijing.baixing.com/youerpeixun/m36088/", @"http://beijing.baixing.com/tiyupeixun/", @"http://beijing.baixing.com/wentipeixun/"];
	NSMutableArray *categArr = [NSMutableArray array];
	for (NSString *catUrlString in catUrlArr) {
		
		NSMutableArray *listArr = [NSMutableArray array];
		for (int i = 1; i <= 10; ++i) {
			NSString *urlStr = [NSString stringWithFormat:@"%@?page=%d",catUrlString, i];
			NSArray *pageList = [MXSWebPekingPeopleHandle getShopListWithUrlString:urlStr];
			if (pageList.count != 0) {
				[listArr addObjectsFromArray:pageList];
			} else {
				pageList = [MXSWebPekingPeopleHandle getShopListWithUrlString:urlStr];
				if (pageList != 0) {
					[listArr addObjectsFromArray:pageList];
				}
			}
		}
		
		NSMutableArray *shopArgsArr = [NSMutableArray array];
		for (NSString *urlstring in listArr) {
			NSDictionary *shopArgs = [MXSWebPekingPeopleHandle getShopArgsWithUrlString:urlstring];
			
			if (shopArgs.count != 0) {
				[shopArgsArr addObject:shopArgs];
			} else {
				NSLog(@"URLString: \n%@", urlstring);
				shopArgs = [MXSWebPekingPeopleHandle getShopArgsWithUrlString:urlstring];
				if (shopArgs.count != 0) {
					[shopArgsArr addObject:shopArgs];
				}
			}
		}
		[categArr addObject:shopArgsArr];
	}
	
	[MXSFileHandle writeToJsonFile:categArr withFileName:@"BeijingBaixing"];
	
	return nil;
}

+ (NSArray*)getShopListWithUrlString:(NSString*)urlStr {
	
	NSMutableArray *listArr = [NSMutableArray array];
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	if (htmlStr.length < 500) {
		NSLog(@"HTML is NULL");
	}
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	HTMLNode *ulNode = [bodyNode findChildOfClass:@"list-ad-items"];
	
	NSArray *items_pinned = [ulNode findChildrenOfClass:@" item-pinned "];
	NSArray *items_regular = [ulNode findChildrenOfClass:@" item-regular "];
	
	for (HTMLNode *liNode in items_pinned) {
		HTMLNode *aNode = [NodeHandle searchNodeWithSuperNode:liNode andPathArray:@[@"media-body", @"media-body-title", @"ad-title"]];
		NSString *href = [aNode getAttributeNamed:@"href"];
		if (href) {
			NSLog(@"href: %@", href);
			[listArr addObject:href];
		}
	}
			
	for (HTMLNode *liNode in items_regular) {
		HTMLNode *aNode = [NodeHandle searchNodeWithSuperNode:liNode andPathArray:@[@"media-body", @"media-body-title", @"ad-title"]];
		NSString *href = [aNode getAttributeNamed:@"href"];
		if (href) {
			NSLog(@"href: %@", href);
			[listArr addObject:href];
		}
	}
	
	return [listArr copy];
}

+ (NSDictionary *)getShopArgsWithUrlString:(NSString*)urlStr {
	
	NSMutableDictionary *dic_args = [[NSMutableDictionary alloc] init];
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	if (htmlStr.length < 500) {
		NSLog(@"HTML is NULL");
	}
	
	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
	if (!parser) {
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	
	NSString *title = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"viewad-header", @"viewad-title "]];
	[dic_args setValue:title forKey:@"title"];
	
	HTMLNode *spanNode = [[[bodyNode findChildOfClass:@"viewad-header"] findChildOfClass:@"viewad-actions"] firstChild];
	NSString *date_release = [spanNode getAttributeNamed:@"title"];
	date_release = [date_release stringByReplacingOccurrencesOfString:@"首次发布于：" withString:@""];
	[dic_args setValue:date_release forKey:@"date_release"];
	
	NSArray *liNodes = [[[bodyNode findChildOfClass:@"viewad-topMeta"] findChildTag:@"ul"] findChildTags:@"li"];
	for (HTMLNode *liNode in liNodes) {
		NSString *key, *value;
		key = [NodeHandle delHTMLTag:[[liNode findChildTag:@"label"] rawContents]];
		value = [NodeHandle delHTMLTag:[[liNode findChildTag:@"span"] rawContents]];
		if (key && value) {
			if ([key containsString:@"费"]) {
				key = @"price";
			} else if ([key containsString:@"类"]) {
				key = @"class_type";
			} else if ([key containsString:@"校"]) {
				key = @"shop_name";
			} else if ([key containsString:@"联"]) {
				key = @"contacter";
			} else if ([key containsString:@"址"]) {
				key = @"addr";
			}
			[dic_args setValue:value forKey:key];
		}
	}
	
	NSString *phoneNo = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"viewad-contact", @"contact-btn-box", @"contact-no"]];
	[dic_args setValue:phoneNo forKey:@"phone_no"];
	
	NSString *addr_class = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"viewad-detail", @"viewad-meta2", @"viewad-meta2-item "]];
	[dic_args setValue:addr_class forKey:@"addr_class"];
	
	NSString *detail = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"viewad-detail", @"viewad-text-hide"]];
	[dic_args setValue:detail forKey:@"detail"];
	
	HTMLNode *photoNode = [bodyNode findChildOfClass:@"photo-gallery"];
	if (photoNode) {
		NSArray *divNodes = [[photoNode findChildOfClass:@"featured-height"] findChildTags:@"div"];
		NSMutableArray *srcArr = [NSMutableArray array];
		for (HTMLNode *divNode in divNodes) {
			HTMLNode *aNode = [divNode findChildTag:@"a"];
			NSString *src_img = [aNode getAttributeNamed:@"style"];
			src_img = [MXSWebPekingPeopleHandle extractionStringFromString:src_img];
    
			if (src_img) {
				[srcArr addObject:src_img];
			}
		}
		[dic_args setValue:srcArr forKey:@"imgs_src"];
	}
	
	return [dic_args copy];
}

+ (NSString*)extractionStringFromString:(NSString*)string {
	
	NSArray *subArrH = [string componentsSeparatedByString:@"("];
	NSArray *subArrE = [string componentsSeparatedByString:@")"];
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

@end
