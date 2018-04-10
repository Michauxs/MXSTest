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
	for (int i = 1; i <= 84 ; ++i) {
		NSString *url = [NSString stringWithFormat:@"http://www.hdb.com/beijing/98-0-2-0-%d", i];
		NSArray *arr = [MXSTogetherBarHandle getListWithUrlString:url];
		if (arr) {
			[list addObjectsFromArray:arr];
		}
	}
	
	id togethers = [Tools creatMutableArray];
	for (NSDictionary *dic_href  in list) {
		NSDictionary *dic = [MXSTogetherBarHandle getActiveArgsWithUrlString:dic_href];
		if (dic) {
			[togethers addObject:dic];
		}
	}
	
	[MXSFileHandle writeToJsonFile:togethers withFileName:@"hudongbar"];
	
//	NSString *href = @"http://www.hdb.com/party/yibmb.html";
//	NSDictionary *dic = [MXSTogetherBarHandle getActiveArgsWithUrlString:href];
//	[MXSFileHandle writeToJsonFile:dic withFileName:@"hudongbar"];
	return nil;
}

+ (NSArray*)getListWithUrlString:(NSString*)urlStr {
	
//	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
//	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
	NSMutableArray *list = [NSMutableArray array];
	
	NSURL *url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	request.HTTPMethod = @"GET";
	NSURLResponse *response;
	NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:nil];
	TFHpple *parser = [[TFHpple alloc] initWithHTMLData:returnData];
	if (!parser) {
		return  nil;
	}
	
	TFHppleElement *bodyElem = [parser peekAtSearchWithXPathQuery:@"//body"];
	
	NSArray *liNodes = [[NodeHandle searchElemWithSuperElem:bodyElem andPathArray:@[@"find_outside find", @"find_main findList", @"find_main_ul"]] childrenWithTagName:@"li"];
	for (TFHppleElement *liNode in liNodes) {
		TFHppleElement *aNode = [liNode firstChildWithTagName:@"a"];
		NSString *href = [aNode objectForKey:kMXSNodeAttrArgsHref];
		NSLog(@"href:%@", href);

		TFHppleElement *priceElem = [NodeHandle searchElemWithSuperElem:liNode andPathArray:@[@"find_main_div", @"find_main_fixH", @"find_hd_p"]];
		NSString *price = [NodeHandle delHTMLTag:[priceElem raw]];
		NSLog(@"price:%@", price);
		
		if (href && price) {
			NSDictionary *dic = @{ @"href":href, @"price":price};
			[list addObject:dic];
		}
		
	}
	
//	HTMLNode *bodyNode = [parser body];
//
//	NSArray *liNodes = [[NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"find_main findList", @"find_main_ul"]] findChildTags:@"li"];
//	for (HTMLNode *liNode in liNodes) {
//		HTMLNode *aNode = [liNode findChildTag:@"a"];
//		NSString *href = [aNode getAttributeNamed:kMXSNodeAttrArgsHref];
//		NSLog(@"href:%@", href);
//		
//		NSString *price = [NodeHandle searchContentWithSuperNode:liNode andPathArray:@[@"find_main_div", @"find_main_fixH", @"find_hd_p"]];
//		NSLog(@"price:%@", price);
//		
//		if (href) {
//			[list addObject:href];
//		}
//	}
	
	return [list copy];
}

+ (NSDictionary*)getActiveArgsWithUrlString:(NSDictionary*)urlStr {
	NSMutableDictionary *dic_args = [[NSMutableDictionary alloc] init];
	[dic_args setValue:[urlStr objectForKey:@"price"] forKey:@"price"];
//	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
//	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
//	NSError *error = nil;
//	HTMLParser *parser = [[HTMLParser alloc] initWithData:returnData error:&error];
	
	NSURL *url = [NSURL URLWithString:[urlStr objectForKey:@"href"]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	request.HTTPMethod = @"GET";
	NSURLResponse *response;
	NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:nil];
	TFHpple *parser = [[TFHpple alloc] initWithHTMLData:returnData];
	if (!parser) {
		return  nil;
	}
	
	TFHppleElement *bodyElem = [parser peekAtSearchWithXPathQuery:@"//body"];
	TFHppleElement *headRElem = [NodeHandle searchElemWithSuperElem:bodyElem andPathArray:@[
																							@"content-body",
																							@"content-body_head",
																							@"content-body_head_wrap",
																							@"content-body_head_r"]];
	TFHppleElement *titleElem = [NodeHandle searchElemWithSuperElem:headRElem andPathArray:@[
																							 @"detail_title",
																							 @"detail_title_h1"]];
	NSString *title = [NodeHandle delHTMLTag:[titleElem raw]];
	[dic_args setValue:title forKey:@"title"];
	
	
	
//	HTMLNode *bodyNode = [parser body];
//	HTMLNode *headRNode = [bodyNode findChildOfClass:@"content-body_head_r"];
//	NSString *title = [NodeHandle searchContentWithSuperNode:headRNode andPathArray:@[@"detail_title", @"detail_title_h1"]];
	
//	HTMLNode *pNode = [[NodeHandle searchNodeWithSuperNode:headRNode andPathArray:@[@"detail_Time", @"detail_Time_t"]] findChildTag:@"p"];
//	NSString *date_avilabe = [pNode allContents];
//	[dic_args setValue:date_avilabe forKey:@"date_avilabe"];
//
	
	TFHppleElement *dateAble = [NodeHandle searchElemWithSuperElem:headRElem andPathArray:@[@"detail_time_attr_join", @"detail_time_attr_join_gray", @"detail_Time", @"detail_Time_t"]];
	NSString *date_avilabe = [NodeHandle delHTMLTag:dateAble.raw];
	[dic_args setValue:date_avilabe forKey:@"date_avilabe"];
	
//	NSString *date_release = [NodeHandle searchContentWithSuperNode:headRNode andPathArray:@[@"detail_user hdMan", @"hdman_r", @"yhName", @"fbTime"]];
//	[dic_args setValue:date_release forKey:@"date_release"];
	
	TFHppleElement *dateReleElem = [NodeHandle searchElemWithSuperElem:headRElem andPathArray:@[@"detail_user hdMan", @"hdman_r", @"yhName", @"fbTime"]];
	NSString *date_release = [dateReleElem text];
	[dic_args setValue:date_release forKey:@"date_release"];
//
//	NSString *addr = [NodeHandle searchContentWithSuperNode:headRNode andPathArray:@[@"detail_Attr", @"detail_attr_blue"]];
//	[dic_args setValue:addr forKey:@"addr"];
	
	TFHppleElement *addrElem = [NodeHandle searchElemWithSuperElem:headRElem andPathArray:@[@"detail_time_attr_join", @"detail_time_attr_join_gray", @"detail_Attr", @"detail_attr_blue"]];
	NSString *addr = [addrElem text];
	[dic_args setValue:addr forKey:@"addr"];
	
////	NSString *count_enter = [NodeHandle searchContentWithSuperNode:headRNode andPathArray:@[@"detail_Joinnum", @""]];
//	
//	HTMLNode *detailNode = [NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"detail_time_attr_det_con", @"dt_content"]];
//	NSString *detail = [NodeHandle delHTMLTag:[detailNode rawContents]];
//	[dic_args setValue:detail forKey:@"detail"];
//	
//	NSArray *imgNodes  = [detailNode findChildTags:@"img"];
//	id imgSrcArr = [Tools creatMutableArray];
//	for (HTMLNode *imgNode in imgNodes) {
//		NSString *src = [imgNode getAttributeNamed:kMXSNodeAttrArgsSrc];
//		if (src) {
//			[imgSrcArr addObject:src];
//		}
//	}
//	[dic_args setValue:imgSrcArr forKey:@"imgs_src"];
	
	TFHppleElement *detailElem = [NodeHandle searchElemWithSuperElem:bodyElem andPathArray:@[@"content-body", @"detail_main_outside", @"detail_time_attr_det_con", @"dt_content"]];
	NSString *detail = [NodeHandle delHTMLTag:detailElem.raw];
	[dic_args setValue:detail forKey:@"detail"];
	
	NSArray *imgNodes  = [detailElem searchWithXPathQuery:@"//img"];
	id imgSrcArr = [Tools creatMutableArray];
	for (TFHppleElement *imgNode in imgNodes) {
		NSString *src = [imgNode objectForKey:@"data-src"];
		if (src) {
			[imgSrcArr addObject:src];
		}
	}
	[dic_args setValue:imgSrcArr forKey:@"imgs_src"];
	
//	
//	HTMLNode *instANode = [NodeHandle searchNodeWithSuperNode:headRNode andPathArray:@[@"detail_user hdMan", @"hdman_r", @"yhName", @"subinfo_name"]];
//	NSString *name_inst = [instANode allContents];
//	[dic_args setValue:name_inst forKey:@"name_inst"];
//
	TFHppleElement *nameElem = [NodeHandle searchElemWithSuperElem:headRElem andPathArray:@[@"detail_user hdMan", @"hdman_r", @"yhName", @"subinfo_name"]];
	NSString *name_inst = [nameElem text];
	[dic_args setValue:name_inst forKey:@"name_inst"];
	
//	NSString *href_inst = [instANode getAttributeNamed:kMXSNodeAttrArgsHref];
//	NSDictionary *dic_inst = [MXSTogetherBarHandle getInstArgsWithUrlString:href_inst];
//	[dic_args setValue:dic_inst forKey:@"inst_args"];
//
	NSString *href_inst = [nameElem objectForKey:kMXSNodeAttrArgsHref];
	NSDictionary *dic_inst = [MXSTogetherBarHandle getInstArgsWithUrlString:href_inst];
	[dic_args setValue:dic_inst forKey:@"inst_args"];
	
	return [dic_args copy];
}

+ (NSDictionary*)getInstArgsWithUrlString:(NSString*)urlStr {
	
	NSURL *url = [NSURL URLWithString:urlStr];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	request.HTTPMethod = @"GET";
	NSURLResponse *response;
	NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse:&response error:nil];
	TFHpple *parser = [[TFHpple alloc] initWithHTMLData:returnData];
	if (!parser) {
		return  nil;
	}
	
	TFHppleElement *bodyElem = [parser peekAtSearchWithXPathQuery:@"//body"];
	NSMutableDictionary *dic_args = [[NSMutableDictionary alloc] init];
	
//	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
//	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
//	if (!parser) {
//		return  nil;
//	}
//	HTMLNode *bodyNode = [parser body];
//
//	HTMLNode *topNode = [NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"timeoutSide", @"jiluTop", @"jiluTop_outK"]];
//	
//	HTMLNode *namespanNode = [topNode findChildWithAttribute:@"id" matchingName:@"tl_nick" allowPartial:NO];
//	NSString *name = [namespanNode allContents];
//	[dic_args setValue:name forKey:@"name_inst"];
//
	
	TFHppleElement *topElem = [NodeHandle searchElemWithSuperElem:bodyElem andPathArray:@[@"timeoutSide", @"jiluTop", @"jiluTop_outK"]];
	NSArray *divElems = [topElem childrenWithTagName:@"div"];
	for (TFHppleElement *divElem in divElems) {
		if ([[divElem objectForKey:@"id"] isEqualToString:@"info_con"]) {
			TFHppleElement *spanElem = [divElem firstChildWithTagName:@"span"];
			NSString *name = [spanElem text];
			[dic_args setValue:name forKey:@"name_inst"];
			
			TFHppleElement *cerElem = [divElem firstChildWithTagName:@"a"];
			BOOL is_cer = cerElem ? YES : NO;
			[dic_args setValue:[NSNumber numberWithBool:is_cer] forKey:@"is_cer"];
		}
		else if ([[divElem objectForKey:@"id"] isEqualToString:@"info_join"]) {
			
			TFHppleElement *lElem = [[divElem firstChildWithClassName:@"l"] firstChildWithTagName:@"span"];
			[dic_args setValue:[lElem text] forKey:@"count_active"];
			TFHppleElement *rElem = [[divElem firstChildWithClassName:@"r"] firstChildWithTagName:@"span"];
			[dic_args setValue:[rElem text] forKey:@"count_people"];
		}
		else if ([[divElem objectForKey:@"class"] isEqualToString:@"jilu_jj"]) {
			NSString *inst_desc = [NodeHandle delHTMLTag:divElem.raw];
			[dic_args setValue:inst_desc forKey:@"inst_desc"];
		}
	}
	
//	HTMLNode *cerNode = [topNode findChildOfClass:@"rz_icon_a"];
//	BOOL is_cer = cerNode ? YES : NO;
//	[dic_args setValue:[NSNumber numberWithBool:is_cer] forKey:@"is_cer"];
//
//	HTMLNode *countNode = [topNode findChildOfClass:@"timeline_K_tit"];
//	NSString *count_active = [[[countNode findChildOfClass:@"l"] findChildTag:@"span"] allContents];
//	[dic_args setValue:count_active forKey:@"count_active"];
//	
//	NSString *count_people = [[[countNode findChildOfClass:@"r"] findChildTag:@"span"] allContents];
//	[dic_args setValue:count_people forKey:@"count_people"];
//	
//	NSString *inst_desc = [NodeHandle searchContentWithSuperNode:topNode andPathArray:@[@"jilu_jj"]];
//	[dic_args setValue:inst_desc forKey:@"inst_desc"];
	
	return [dic_args copy];
}

@end
