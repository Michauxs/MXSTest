//
//  MXSHuiLongGuanHandle.m
//  MXSTest
//
//  Created by Alfred Yang on 10/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSHuiLongGuanHandle.h"

static NSString *const baseUrlStr	=	@"http://baby.hlgnet.com";

@implementation MXSHuiLongGuanHandle

+ (NSArray*)handNodeWithSimple {
	
//	http://baby.hlgnet.com/teach/1/9/0/				*/teach/%d/*
//	http://baby.hlgnet.com/teach/1/518/0/
//	http://baby.hlgnet.com/teach/1/3/0/
//	http://baby.hlgnet.com/teach/1/6/0/
//	http://baby.hlgnet.com/teach/1/8/0/
//	http://baby.hlgnet.com/teach/1/5/0/
//	http://baby.hlgnet.com/teach/1/7/0/
//	http://baby.hlgnet.com/teach/1/4/0/
	
	NSArray *sufixArr = @[@"/9/0/", @"/518/0/", @"/3/0/", @"/6/0/", @"/8/0/", @"/5/0/", @"/7/0/", @"/4/0/"];
	NSArray *keyArr = @[@"kid_garden", @"nursary", @"afterclass", @"misic_dance", @"sports", @"art_draw", @"brain", @"test"];
	NSString *urlstr = @"http://baby.hlgnet.com/teach/";
	
	NSMutableArray *allArr = [NSMutableArray array];
	for (NSString *sufix in sufixArr) {
		NSMutableArray *cateArr = [NSMutableArray array];
		for (int i = 1; i <= 6 ; ++i) {
			NSString *url = [NSString stringWithFormat:@"%@%d%@", urlstr, i, sufix];
			NSArray *arr = [MXSHuiLongGuanHandle getListWithUrlString:url];
			[cateArr addObjectsFromArray:arr];
		}
		[allArr addObject:cateArr];
	}
	
	NSMutableArray *shopArr = [NSMutableArray array];
	for (int i = 0; i < allArr.count; ++i) {
		
		NSArray *cateArr = [allArr objectAtIndex:i];
		NSString *value = [keyArr objectAtIndex:i];
		for (NSString  *href in cateArr) {
			NSMutableDictionary *dic = [MXSHuiLongGuanHandle getShopArgsWithUrlString:href];
			[dic setValue:value forKey:@"cate"];
			[shopArr addObject:dic];
		}
		
	}
	
	[MXSFileHandle writeToJsonFile:shopArr withFileName:@"huilongguan"];
	
	return nil;
}


+ (NSArray*)getListWithUrlString:(NSString *)urlStr {
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
	if (!parser) {
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	
	NSMutableArray *listHref = [NSMutableArray array];
	NSArray *listNodes = [[NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"nljy_c", @"cjyjg"]] findChildrenOfClass:@"cjyjgc_c"];
	for (HTMLNode *linode in listNodes) {
		HTMLNode *aNode = [[NodeHandle searchNodeWithSuperNode:linode andPathArray:@[@"jyli_r", @"jydzt"]] findChildTag:@"a"];
		NSString *href = [aNode getAttributeNamed:kMXSNodeAttrArgsHref];
		href = [NSString stringWithFormat:@"%@%@", baseUrlStr, href];
		NSLog(@"href:%@", href);
		[listHref addObject:href];
	}
	
	return [listHref copy];
}

+ (NSMutableDictionary *)getShopArgsWithUrlString:(NSString*)urlStr {
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
	if (!parser) {
		return nil;
	}
	
	NSMutableDictionary *dic_args = [[NSMutableDictionary alloc] init];
	
	HTMLNode *bodyNode = [parser body];
	NSString *name = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"t_jgName", @"f_le"]];
	[dic_args setValue:name forKey:@"name"];
	
	NSString *url_about = [NSString stringWithFormat:@"%@%@", urlStr, @"instinfo/about/"];
	NSString *about = [MXSHuiLongGuanHandle getSubArgsWithUrlString:url_about];
	[dic_args setValue:about forKey:@"about"];
	
	NSString *url_tese = [NSString stringWithFormat:@"%@%@", urlStr, @"instinfo/tese/"];
	NSString *tese = [MXSHuiLongGuanHandle getSubArgsWithUrlString:url_tese];
	[dic_args setValue:tese forKey:@"spesic"];
	
	NSString *url_course = [NSString stringWithFormat:@"%@%@", urlStr, @"instinfo/curriculum/"];
	NSString *course = [MXSHuiLongGuanHandle getSubArgsWithUrlString:url_course];
	[dic_args setValue:course forKey:@"course_intru"];
	
	NSString *url_contact = [NSString stringWithFormat:@"%@%@", urlStr, @"instinfo/contact/"];
	NSString *contact = [MXSHuiLongGuanHandle getSubArgsWithUrlString:url_contact];
	[dic_args setValue:contact forKey:@"contact"];
	
	
	NSMutableArray *enrollments = [NSMutableArray array];
	NSArray *enrollHrefs = [MXSHuiLongGuanHandle getEnrollHrefsWithUrlString:[urlStr stringByAppendingString:@"list/2/"]];
	for (NSString *enrollhref in enrollHrefs) {
		NSDictionary *enrollInfo = [MXSHuiLongGuanHandle getEnrollInfoWithUrlString:enrollhref];
		[enrollments addObject:enrollInfo];
	}
	[dic_args setValue:enrollments forKey:@"enrollments"];
	
	return dic_args;
}

+ (NSString *)getSubArgsWithUrlString:(NSString*)urlStr {
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
	if (!parser) {
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	
	NSString *args = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"nrr_c", @"nrrc_js"]];
//	if ([urlStr hasSuffix:@"about/"]) {
//		args = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"nrr_c", @"nrrc_js"]];
//	} else if ([urlStr hasSuffix:@"tese/"]) {
//		args = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"nrr_c", @"nrrc_js"]];
//	} else if ([urlStr hasSuffix:@"curriculum/"]) {
//		
//	} else if ([urlStr hasSuffix:@"contact/"]) {
//		
//	}
	
	return args;
}


+ (NSArray *)getEnrollHrefsWithUrlString:(NSString*)urlStr {
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
	if (!parser) {
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	
	NSMutableArray *enrolls = [NSMutableArray array];
	NSArray *liNodes = [[NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"nr_ri", @"nrr_list"]] findChildTags:@"dl"];
	for (HTMLNode *liNode in liNodes) {
		HTMLNode *aNode = [[liNode findChildOfClass:@"nrrli_l"] findChildTag:@"a"];
		NSString *href = [aNode getAttributeNamed:kMXSNodeAttrArgsHref];
		href = [NSString stringWithFormat:@"%@%@", baseUrlStr, href];
		[enrolls addObject:href];
	}
	return [enrolls copy];
}

+ (NSDictionary *)getEnrollInfoWithUrlString:(NSString*)urlStr {
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
	if (!parser) {
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	
	NSString *enrollment = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"nrr_c", @"nrrc_js"]];
	
	NSMutableArray *images = [NSMutableArray array];
	NSArray *imgsNode = [[NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"nrr_c", @"nrrc_js"]] findChildTags:@"img"];
	for (HTMLNode *imgNode in imgsNode) {
		NSString *src = [imgNode getAttributeNamed:kMXSNodeAttrArgsSrc];
		[images addObject:src];
	}
	
	HTMLNode *countNode = [bodyNode findChildWithAttribute:@"style" matchingName:@"text-align:right; color:#F00;" allowPartial:NO];
	NSString *count = [[[countNode allContents] componentsSeparatedByString:@"："] lastObject];
	NSDictionary *dic_enroll = @{@"context":enrollment, @"imgs_src":images, @"count_apply":count};
	
	return dic_enroll;
}

@end
