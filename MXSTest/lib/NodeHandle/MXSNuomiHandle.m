//
//  MXSNuomiHandle.m
//  MXSTest
//
//  Created by Alfred Yang on 1/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSNuomiHandle.h"

@implementation MXSNuomiHandle


+ (NSArray*)handNodeWithSimple {
	
	NSString *urlStr= @"https://bj.nuomi.com/375-page2";
	NSArray *listArr = [MXSNuomiHandle getShopListWithUrlString:urlStr];
	for (NSString *hrefUrlStr in listArr) {
		NSDictionary *shopArgs =[MXSNuomiHandle getShopArgsWithUrlString:hrefUrlStr];
		NSMutableDictionary *extend_args = [[NSMutableDictionary alloc] initWithDictionary:shopArgs];
		
		NSMutableArray *others = [NSMutableArray array];
		NSArray *otherProds = [shopArgs valueForKey:@"others"];
		for (NSString *otherUrlStr in otherProds) {
			NSDictionary *dic_another = [MXSNuomiHandle getOtherArgsWithUrlString:otherUrlStr];
			[others addObject:dic_another];
		}
		[extend_args setValue:others forKey:@"others"];
	}
	
	return nil;
}

+ (NSArray*)getShopListWithUrlString:(NSString*)urlStr {
	NSMutableArray *listArr = [NSMutableArray array];
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	NSLog(@"%@", htmlStr);
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	
	HTMLNode *itemsNode = [bodyNode findChildOfClass:@"itemlist clearfix"];
	NSArray *linodes = [itemsNode findChildTags:@"li"];
	for (HTMLNode *linode in linodes) {
		HTMLNode *aNode = [linode findChildTag:@"a"];
		NSString *href = [aNode getAttributeNamed:kMXSNodeAttrArgsHref];
		NSLog(@"%@", href);
		[listArr addObject:href];
	}
	
	return [listArr copy];
}

+ (NSDictionary*)getShopArgsWithUrlString:(NSString*)urlStr {
	
	return nil;
}

+ (NSDictionary*)getOtherArgsWithUrlString:(NSString*)urlStr {
	
	return nil;
}
@end
