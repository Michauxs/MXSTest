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
	
	NSString *baseUrlStr= @"https://bj.nuomi.com/375";
	NSMutableArray *listArr = [NSMutableArray array];
	for (int i = 1; i <= 10; ++i) {
		
		NSString *urlStr= [NSString stringWithFormat:@"%@-page%d", baseUrlStr, i];
		NSArray *list = [MXSNuomiHandle getShopListWithUrlString:urlStr];
		[listArr addObjectsFromArray:list];
	}
	
	NSMutableArray *devoArr = [NSMutableArray array];
	for (NSDictionary *dic_href in listArr) {
		NSDictionary *shopArgs =[MXSNuomiHandle getShopArgsWithUrlString:[dic_href valueForKey:@"href"]];
		NSMutableDictionary *extend_args = [[NSMutableDictionary alloc] initWithDictionary:shopArgs];
		[extend_args setValue:[dic_href valueForKey:@"price_real"] forKey:@"price_real"];
		
		NSMutableArray *others = [NSMutableArray array];
		NSArray *otherProds = [shopArgs valueForKey:@"others"];
		for (NSDictionary *otherhref in otherProds) {
			NSDictionary *dic_another = [MXSNuomiHandle getOtherArgsWithUrlArgs:otherhref];
			[others addObject:dic_another];
		}
		[extend_args setValue:others forKey:@"others"];
		[devoArr addObject:extend_args];
	}
	
	[MXSFileHandle writeToJsonFile:devoArr withFileName:@"nuoni"];
	
//	NSDictionary *aaa;
//	aaa = [MXSNuomiHandle getShopArgsWithUrlString:@"https://www.nuomi.com/deal/s00pvisj8.html"];
	
	return nil;
}

+ (NSArray*)getShopListWithUrlString:(NSString*)urlStr {
	
	NSMutableArray *listArr = [NSMutableArray array];
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
//	NSLog(@"%@", htmlStr);
	
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
		href = [NSString stringWithFormat:@"https:%@", href];
		NSString *price_real = [NodeHandle searchContentWithSuperNode:linode andPathArray:@[@"pinfo clearfix", @"price"]];
		
		if (href && price_real) {
			NSDictionary *args = @{@"href":href, @"price_real":price_real};
			NSLog(@"%@", args);
			[listArr addObject:args];
		} else {
			NSLog(@"error nil");
		}
	}
	
	return [listArr copy];
}

+ (NSDictionary*)getShopArgsWithUrlString:(NSString*)urlStr {
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
//	NSLog(@"%@", htmlStr);
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
	}
	
	NSMutableDictionary *dic_args = [[NSMutableDictionary alloc] init];
	
	HTMLNode *bodyNode = [parser body];
	
	HTMLNode *headNode = [bodyNode findChildOfClass:@"w-item-info clearfix"];
	HTMLNode *h2Node = [headNode findChildTag:@"h2"];
	NSString *shopname = [NodeHandle extractionStringFromString:[h2Node rawContents]];
	[dic_args setValue:shopname forKey:@"shopname"];
	
	HTMLNode *titleNode = [bodyNode findChildOfClass:@"text-main"];
	NSString *title = [NodeHandle extractionStringFromString:[titleNode rawContents]];
	[dic_args setValue:title forKey:@"title"];
	
	NSString *realPrice = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"market-price-area", @"price"]];
	[dic_args setValue:realPrice forKey:@"price_ori"];
	
	NSString *sales_count = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"item-bought-num", @"intro-strong"]];
	[dic_args setValue:sales_count forKey:@"sales_count"];
	
	NSString *comm_count = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"ug-num", @"intro-strong"]];
	[dic_args setValue:comm_count forKey:@"comm_count"];
	
	NSString *validate = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"item-countdown-row clearfix", @"value"]];
	[dic_args setValue:validate forKey:@"validate"];
	
	NSArray *liNodes = [[bodyNode findChildOfClass:@"sg-wrapper"] findChildTags:@"li"];
	NSMutableArray *othersArr = [NSMutableArray array];
	for (HTMLNode *liNode in liNodes) {
		
		HTMLNode *aNode = [liNode findChildTag:@"a"];
		NSString *otherHref = [aNode getAttributeNamed:@"href"];
		otherHref = [NSString stringWithFormat:@"https:%@", otherHref];
		NSString *realPrice = [NodeHandle searchContentWithSuperNode:liNode andPathArray:@[@"sg-col sg-price"]];
		
		NSDictionary *args = @{@"href":otherHref, @"price_real":realPrice};
		[othersArr addObject:args];
	}
	[dic_args setValue:othersArr forKey:@"others"];
	
	NSString *desc = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"w-package-deal", @"ext-info", @"ext-info"]];
	[dic_args setValue:desc forKey:@"desc"];
	
	HTMLNode *tableNode = [NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"consume"]];
	NSArray *trNodes = [tableNode findChildTags:@"tr"];
//	HTMLNode *first = [tableNode findChildWithAttribute:@"select" matchingName:@"tr:nth-child(1)" allowPartial:NO];
	for (HTMLNode *trNode in trNodes) {
		NSString *key, *value;
		HTMLNode *thNode = [trNode findChildTag:@"th"];
		key = [NodeHandle delHTMLTag:[thNode rawContents]];
		HTMLNode *tdNode = [trNode findChildTag:@"td"];
		value = [NodeHandle delHTMLTag:[tdNode rawContents]];
		
		if (key && value) {
			if ([key containsString:@"效"]) {
				key = @"tips_date";
			} else if ([key containsString:@"用"]) {
				key = @"tips_avliabletime";
			} else if ([key containsString:@"预"]) {
				key = @"tips_book";
			} else if ([key containsString:@"使"]) {
				key = @"tips_userule";
			} else if ([key containsString:@"温"]) {
				key = @"tips_other";
			}
			[dic_args setValue:value forKey:key];
		}
	}
//	HTMLNode *handNode = [[tableNode firstChild] nextSibling];
//	if (handNode) {
//		
//		NSString *tips_date = [NodeHandle searchContentWithSuperNode:[handNode findChildTag:@"td"] andPathArray:@[@"multi-lines"]];
//		[dic_args setValue:tips_date forKey:@"tips_date"];
//		
//		handNode = [[handNode nextSibling]nextSibling];
//		NSString *tips_avliabletime = [NodeHandle searchContentWithSuperNode:[handNode findChildTag:@"td"] andPathArray:@[@"multi-lines"]];
//		[dic_args setValue:tips_avliabletime forKey:@"tips_avliabletime"];
//		
//		handNode = [[handNode nextSibling]nextSibling];
//		NSString *tips_book = [NodeHandle searchContentWithSuperNode:[handNode findChildTag:@"td"] andPathArray:@[@"multi-lines"]];
//		[dic_args setValue:tips_book forKey:@"tips_book"];
//		
//		handNode = [[handNode nextSibling]nextSibling];
//		NSString *tips_userule = [NodeHandle searchContentWithSuperNode:[handNode findChildTag:@"td"] andPathArray:@[@"multi-lines"]];
//		[dic_args setValue:tips_userule forKey:@"tips_userule"];
//		
//		handNode = [[handNode nextSibling]nextSibling];
//		NSString *tips_other = [NodeHandle searchContentWithSuperNode:[handNode findChildTag:@"td"] andPathArray:@[@"multi-lines"]];
//		[dic_args setValue:tips_other forKey:@"tips_other"];
//		
//	} else {
//		NSLog(@"MXS:");
//	}
	
	HTMLNode *d = [[bodyNode findChildWithAttribute:@"id" matchingName:@"j-info-intro" allowPartial:NO] findChildOfClass:@"rt-content"];
	NSString *shopintru = [NodeHandle delHTMLTag:[d rawContents]];
	shopintru = [NodeHandle replacingOccurrencesString:shopintru];
	[dic_args setValue:shopintru forKey:@"shopintru"];
	
	NSArray *imgNodes = [bodyNode findChildrenOfClass:@"wrap-img"];
	NSMutableArray *imgSrcArr = [NSMutableArray array];
	for (HTMLNode *imgNode in imgNodes) {
		NSString *scr = [[imgNode findChildTag:@"img"] getAttributeNamed:@"src"];
		[imgSrcArr addObject:scr];
	}
	[dic_args setValue:imgSrcArr forKey:@"images"];
	
	return [dic_args copy];
}

+ (NSDictionary*)getOtherArgsWithUrlArgs:(id)args {
	
	NSString *urlStr= [args valueForKey:@"href"];
	NSString *realPrice = [args valueForKey:@"price_real"];
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	NSLog(@"%@", htmlStr);
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
	}
	
	NSMutableDictionary *dic_args = [[NSMutableDictionary alloc] init];
	
	[dic_args setValue:realPrice forKey:@"price_real"];
	HTMLNode *bodyNode = [parser body];
	
	HTMLNode *headNode = [bodyNode findChildOfClass:@"w-item-info clearfix"];
	HTMLNode *h2Node = [headNode findChildTag:@"h2"];
	NSString *shopname = [NodeHandle extractionStringFromString:[h2Node rawContents]];
	[dic_args setValue:shopname forKey:@"shopname"];
	
	HTMLNode *titleNode = [bodyNode findChildOfClass:@"text-main"];
	NSString *title = [NodeHandle extractionStringFromString:[titleNode rawContents]];
	[dic_args setValue:title forKey:@"title"];
	
	NSString *oriPrice = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"market-price-area", @"price"]];
	[dic_args setValue:oriPrice forKey:@"price_ori"];
	
	NSString *sales_count = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"item-bought-num", @"intro-strong"]];
	[dic_args setValue:sales_count forKey:@"sales_count"];
	
	NSString *comm_count = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"ug-num", @"intro-strong"]];
	[dic_args setValue:comm_count forKey:@"comm_count"];
	
	NSString *validate = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"item-countdown-row clearfix", @"value"]];
	[dic_args setValue:validate forKey:@"validate"];
	
	NSString *desc = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"w-package-deal", @"ext-info", @"ext-info"]];
	[dic_args setValue:desc forKey:@"desc"];
	
	HTMLNode *tableNode = [NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"consume"]];
	NSArray *trNodes = [tableNode findChildTags:@"tr"];
	//	HTMLNode *first = [tableNode findChildWithAttribute:@"select" matchingName:@"tr:nth-child(1)" allowPartial:NO];
	
	for (HTMLNode *trNode in trNodes) {
		NSString *key, *value;
		HTMLNode *thNode = [trNode findChildTag:@"th"];
		key = [NodeHandle delHTMLTag:[thNode rawContents]];
		HTMLNode *tdNode = [trNode findChildTag:@"td"];
		value = [NodeHandle delHTMLTag:[tdNode rawContents]];
		
		if (key && value) {
			if ([key containsString:@"效"]) {
				key = @"tips_date";
			} else if ([key containsString:@"用"]) {
				key = @"tips_avliabletime";
			} else if ([key containsString:@"预"]) {
				key = @"tips_book";
			} else if ([key containsString:@"使"]) {
				key = @"tips_userule";
			} else if ([key containsString:@"温"]) {
				key = @"tips_other";
			}
			[dic_args setValue:value forKey:key];
		}
	}
	
//	HTMLNode *handNode = [[tableNode firstChild] nextSibling];
//	if (handNode) {
//		
//		NSString *tips_date = [NodeHandle searchContentWithSuperNode:[handNode findChildTag:@"td"] andPathArray:@[@"multi-lines"]];
//		[dic_args setValue:tips_date forKey:@"tips_date"];
//		
//		handNode = [[handNode nextSibling]nextSibling];
//		NSString *tips_avliabletime = [NodeHandle searchContentWithSuperNode:[handNode findChildTag:@"td"] andPathArray:@[@"multi-lines"]];
//		[dic_args setValue:tips_avliabletime forKey:@"tips_avliabletime"];
//		
//		handNode = [[handNode nextSibling]nextSibling];
//		NSString *tips_book = [NodeHandle searchContentWithSuperNode:[handNode findChildTag:@"td"] andPathArray:@[@"multi-lines"]];
//		[dic_args setValue:tips_book forKey:@"tips_book"];
//		
//		handNode = [[handNode nextSibling]nextSibling];
//		NSString *tips_userule = [NodeHandle searchContentWithSuperNode:[handNode findChildTag:@"td"] andPathArray:@[@"multi-lines"]];
//		[dic_args setValue:tips_userule forKey:@"tips_userule"];
//		
//		handNode = [[handNode nextSibling]nextSibling];
//		NSString *tips_other = [NodeHandle searchContentWithSuperNode:[handNode findChildTag:@"td"] andPathArray:@[@"multi-lines"]];
//		[dic_args setValue:tips_other forKey:@"tips_other"];
//		
//	} else {
//		NSLog(@"MXS:");
//	}
	
	HTMLNode *d = [[bodyNode findChildWithAttribute:@"id" matchingName:@"j-info-intro" allowPartial:NO] findChildOfClass:@"rt-content"];
	NSString *shopintru = [NodeHandle delHTMLTag:[d rawContents]];
	shopintru = [NodeHandle replacingOccurrencesString:shopintru];
	[dic_args setValue:shopintru forKey:@"shopintru"];
	
	NSArray *imgNodes = [bodyNode findChildrenOfClass:@"wrap-img"];
	NSMutableArray *imgSrcArr = [NSMutableArray array];
	for (HTMLNode *imgNode in imgNodes) {
		NSString *scr = [[imgNode findChildTag:@"img"] getAttributeNamed:@"src"];
		[imgSrcArr addObject:scr];
	}
	[dic_args setValue:imgSrcArr forKey:@"images"];
	
	return [dic_args copy];
}
@end
