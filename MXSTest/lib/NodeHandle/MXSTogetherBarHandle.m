//
//  MXSTogetherBarHandle.m
//  MXSTest
//
//  Created by Alfred Yang on 10/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSTogetherBarHandle.h"

@implementation MXSTogetherBarHandle

+ (NSArray*)handNodeWithSimple {
//	http://www.hdb.com/beijing/98-0-2-0-1/
//	http://www.hdb.com/beijing/98-0-2-0-3/
	
	NSMutableArray *list = [NSMutableArray array];
	for (int i = 1; i <= 10 ; ++i) {
		NSString *url = [NSString stringWithFormat:@"http://www.hdb.com/beijing/98-0-2-0-%d", i];
		NSArray *arr = [MXSTogetherBarHandle getListWithUrlString:url];
		if (arr) {
			[list addObjectsFromArray:arr];
		}
	}
	
	return nil;
}

+ (NSArray*)getListWithUrlString:(NSString*)urlStr {
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
	if (!parser) {
		return  nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	NSMutableArray *list = [NSMutableArray array];
	
	NSArray *liNodes = [[NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"find_main findList", @"find_main_ul"]] findChildTags:@"li"];
	for (HTMLNode *liNode in liNodes) {
		HTMLNode *aNode = [liNode findChildTag:@"a"];
		NSString *href = [aNode getAttributeNamed:kMXSNodeAttrArgsHref];
		NSLog(@"href:%@", href);
		if (href) {
			[list addObject:href];
		}
	}
	
	return [list copy];
}

@end
