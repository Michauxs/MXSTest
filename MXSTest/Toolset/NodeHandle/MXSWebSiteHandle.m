//
//  MXSWebSiteHandle.m
//  MXSTest
//
//  Created by Alfred Yang on 26/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "MXSWebSiteHandle.h"

@implementation MXSWebSiteHandle

+ (NSArray *)handNodeWithSimple {
	
	NSMutableArray *list = [NSMutableArray array];
	
	NSURL *url = [NSURL URLWithString:@"http://site.baidu.com/"];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	request.HTTPMethod = @"GET";
	NSURLResponse *response;
	NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:nil];
	TFHpple *parser = [[TFHpple alloc] initWithHTMLData:returnData];
	if (!parser) {
		return  nil;
	}
	
	TFHppleElement *bodyElem = [parser peekAtSearchWithXPathQuery:@"//body"];
	
	NSInteger sum = 0;
	NSArray *liNodes = [[NodeHandle searchElemWithSuperElem:bodyElem andPathArray:@[@"content", @"clearfix content-top page-width", @"main ovh", @"cools mod clearfix mt10"]] childrenWithTagName:@"div"];
	for (TFHppleElement *liNode in liNodes) {
		
		NSArray *divNodes = [liNode childrenWithTagName:@"div"];
		for (TFHppleElement *divNode in divNodes) {
			NSArray *spanNodes = [divNode childrenWithTagName:@"span"];
			
			NSMutableDictionary *dic_site = [[NSMutableDictionary alloc] init];
			
			NSMutableArray *list_sub = [NSMutableArray array];
			[dic_site setValue:list_sub forKey:@"list"];
			
			for (TFHppleElement *spanNode in spanNodes) {
				NSString *key = [spanNode objectForKey:@"class"];
				if ([key isEqualToString:@"fl"]) {
					TFHppleElement *aNode = [spanNode firstChildWithTagName:@"a"];
					NSString *name = [NodeHandle delHTMLTag:aNode.raw];
					[dic_site setValue:name forKey:@"name"];
					
				} else if ([key isEqualToString:@"more"]) {
					
				} else {
					
					TFHppleElement *aNode = [spanNode firstChildWithTagName:@"a"];
					NSString *href = [aNode objectForKey:kMXSNodeAttrArgsHref];
					NSString *site_name = [NodeHandle delHTMLTag:aNode.raw];
					if (href && site_name) {
						NSDictionary *dic = @{ @"href":href, @"site":site_name};
						[list_sub addObject:dic];
						NSLog(@"sum:%ld", sum);
					}
				}
			}
			[list addObject:[dic_site copy]];
		}
	}
	
	return [list copy];
}

@end
