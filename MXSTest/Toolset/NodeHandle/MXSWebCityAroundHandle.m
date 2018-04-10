//
//  MXSWebCityAroundHandle.m
//  MXSTest
//
//  Created by Alfred Yang on 7/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSWebCityAroundHandle.h"

@implementation MXSWebCityAroundHandle {
//	NSArray *predArr;
}

+ (NSArray*)handNodeWithSimple {
//	http://www.weichengs.com/Cities/SearchGroupTag.aspx?page=2&CityID=1&TagID=0	//p69
	//	舞蹈、武术、球类、运动、音乐、书画
//	http://www.weichengs.com/Cities/SearchTeacher.aspx?page=3&CityID=1	//p586/2
	
	NSArray *predArr = @[@"摩登舞",	@"拉丁舞", @"广场舞", @"街舞", @"爵士舞", @"现代舞", @"芭蕾舞", @"民族舞", @"古典舞", @"中国舞", @"肚皮舞", @"钢管舞", @"交谊舞", @"莎莎舞", @"踢踏舞", @"散打", @"少林", @"武当", @"长拳", @"南拳", @"太极", @"形意", @"八卦", @"咏春", @"空手道", @"柔道", @"跆拳道", @"泰拳", @"自由搏击", @"拳击", @"摔跤", @"击剑", @"足球", @"篮球", @"排球", @"乒乓球", @"网球", @"羽毛球", @"高尔夫", @"保龄球", @"冰球", @"曲棍球", @"水球", @"桌球", @"壁球", @"棒球", @"垒球", @"板球", @"跑步", @"游泳", @"跳水", @"轮滑", @"滑冰", @"骑行", @"骑马", @"射箭", @"滑雪", @"潜水", @"徒步", @"登山", @"攀岩", @"跳伞", @"热气球", @"飘流", @"探险", @"冲浪", @"风帆", @"滑板", @"蹦极", @"极限运动", @"声乐", @"钢琴", @"口琴", @"吉他", @"小提琴", @"中提琴", @"大提琴", @"手风琴", @"电子琴", @"小号", @"圆号", @"长号", @"长笛", @"单簧管", @"双簧管", @"萨克斯", @"二胡", @"琵琶", @"笛箫", @"古筝", @"扬琴", @"唢呐", @"葫芦丝", @"听音乐", @"打击乐", @"硬笔书法", @"书法", @"篆刻", @"国画", @"油画", @"素描", @"版画", @"水彩画", @"水墨画", @"水粉画", @"漫画", @"连环画", @"沙画", @"卡通画"];
	
	
	NSMutableArray *g_list = [NSMutableArray array];
	for (int i = 0; i <= 69; ++i) {
		NSString *urlStr = [NSString stringWithFormat:@"http://www.weichengs.com/Cities/SearchGroupTag.aspx?page=%d&CityID=1&TagID=0", i];
		NSArray *arr = [MXSWebCityAroundHandle getGroupListWithUrlString:urlStr];
		if (arr) {
			[g_list addObjectsFromArray:arr];
		}
	}
	
	NSMutableArray *groupArr = [NSMutableArray array];
	for (NSString *href in g_list) {
		NSDictionary *dic = [MXSWebCityAroundHandle getGroupArgsWithUrlString:href];
		if (dic) {
			[groupArr addObject:dic];
		}
	}
	
	[MXSFileHandle writeToJsonFile:groupArr withFileName:@"weicheng_g"];
	[groupArr removeAllObjects];
	
	NSMutableArray *t_list = [NSMutableArray array];
	for (int i = 0; i <= 290; ++i) {
		NSString *urlStr = [NSString stringWithFormat:@"http://www.weichengs.com/Cities/SearchTeacher.aspx?page=%d&CityID=1", i];
		NSArray *arr_t = [MXSWebCityAroundHandle getTeacherListWithUrlString:urlStr andPreArray:predArr];
		if (arr_t) {
			[t_list addObjectsFromArray:arr_t];
		}
	}
	
	NSMutableArray *teacherArr = [NSMutableArray array];
	for (NSString *href in t_list) {
		NSDictionary *dic = [MXSWebCityAroundHandle getTeacherArgsWithUrlString:href];
		if (dic) {
			[teacherArr addObject:dic];
		}
	}
	
	[MXSFileHandle writeToJsonFile:teacherArr withFileName:@"weicheng_t"];
	[teacherArr removeAllObjects];
	
	return nil;
}


+ (NSArray*)getGroupListWithUrlString:(NSString*)urlStr {
	NSMutableArray *listArr = [NSMutableArray array];
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
	if (!parser) {
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	HTMLNode *ulNode = [NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"summary author-list", @"bd", @"list-col list-col2 summary-list"]];
	NSArray *liNodes = [ulNode findChildTags:@"li"];
	NSString *baseUrlStr = @"http://www.weichengs.com";
	
	for (HTMLNode *liNode in liNodes) {
		HTMLNode *aNode = [[NodeHandle searchNodeWithSuperNode:liNode andPathArray:@[@"border-wrap", @"name"]] findChildTag:@"a"];
		NSString *href = [aNode getAttributeNamed:kMXSNodeAttrArgsHref];
		href = [NSString stringWithFormat:@"%@%@", baseUrlStr, href];
		NSLog(@"href:%@", href);
		[listArr addObject:href];
	}
	
	return [listArr copy];
}

+ (NSArray*)getTeacherListWithUrlString:(NSString*)urlStr andPreArray:(NSArray*)arr {
	NSMutableArray *listArr = [NSMutableArray array];
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
	if (!parser) {
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	NSArray *liNodes = [[NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"article", @"doulist-items"]] findChildTags:@"li"];
	NSString *baseUrlStr = @"http://www.weichengs.com";
	for (HTMLNode *liNode in liNodes) {
		
		NSString *tag = [NodeHandle searchContentWithSuperNode:liNode andPathArray:@[@"item-hd", @"meta"]];
		NSPredicate *pre_contains = [NSPredicate predicateWithFormat:@"SELF=%@", tag];
		NSArray *result = [arr filteredArrayUsingPredicate:pre_contains];
		
		if (result.count != 0) {
			HTMLNode *aNode = [[NodeHandle searchNodeWithSuperNode:liNode andPathArray:@[@"item-hd", @"title"]] findChildTag:@"a"];
			NSString *href = [aNode getAttributeNamed:kMXSNodeAttrArgsHref];
			href = [NSString stringWithFormat:@"%@%@", baseUrlStr, href];
			NSLog(@"href:%@", href);
			[listArr addObject:href];
		}
		
	}
	
	return [listArr copy];
}

+ (NSDictionary*)getGroupArgsWithUrlString:(NSString*)urlStr {
	NSMutableDictionary *dic_args = [[NSMutableDictionary alloc] init];
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
	if (!parser) {
		return  nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	
	HTMLNode *titleNode = [[[bodyNode findChildWithAttribute:@"id" matchingName:@"content" allowPartial:NO] findChildTag:@"h1"] findChildTag:@"span"];
	NSString *title = [NodeHandle delHTMLTag:[titleNode rawContents]];
	[dic_args setValue:title forKey:@"title"];
	
	NSArray *tagsNode = [[NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"mix-info", @"brief-info"]] findChildrenOfClass:@"taglink-price"];
	NSMutableArray *tags = [NSMutableArray array];
	for (HTMLNode *tagNode in tagsNode) {
		NSString *tag = [NodeHandle delHTMLTag:[tagNode rawContents]];
		if (tag) {
			[tags addObject:tag];
		}
	}
	[dic_args setValue:tags forKey:@"tags"];
	
	//
	NSString *addr = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"mix-info", @"brief-info", @"address"]];
	[dic_args setValue:addr forKey:@"addr"];
	
	NSString *cate = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"mix-info", @"brief-info", @"desc "]];
	[dic_args setValue:cate forKey:@"categary"];
	
	NSString *phone = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"mix-info", @"brief-info", @"phone", @"item"]];
	[dic_args setValue:phone forKey:@"phone"];
	
	NSString *intru = [NodeHandle searchContentWithSuperNode:bodyNode andPathArray:@[@"related-info", @"indent"]];
	[dic_args setValue:intru forKey:@"intru"];
	
	return [dic_args copy];
}

+ (NSDictionary*)getTeacherArgsWithUrlString:(NSString*)urlStr {
	NSMutableDictionary *dic_args = [[NSMutableDictionary alloc] init];
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	HTMLParser *parser = [NodeHandle getHTMLParserWithHTMLString:htmlStr];
	if (!parser) {
		return  nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	
	HTMLNode *infoNode= [[bodyNode findChildWithAttribute:@"id" matchingName:@"basic-info" allowPartial:NO] findChildWithAttribute:@"id" matchingName:@"meta-panel" allowPartial:NO];
	
	HTMLNode *nameNode= [infoNode findChildWithAttribute:@"id" matchingName:@"songlist-title" allowPartial:NO];
	NSString *name = [NodeHandle delHTMLTag:[nameNode rawContents]];
	[dic_args setValue:name forKey:@"name"];
	
	NSString *status = [NodeHandle searchContentWithSuperNode:infoNode andPathArray:@[@"taglink-orange"]];
	[dic_args setValue:status forKey:@"status"];
	
	HTMLNode *sexNode = [infoNode findChildWithAttribute:@"id" matchingName:@"Span1" allowPartial:NO];
	NSString *sex = [NodeHandle delHTMLTag:[sexNode rawContents]];
	[dic_args setValue:sex forKey:@"sex"];
	
	HTMLNode *addrNode = [infoNode findChildWithAttribute:@"id" matchingName:@"intro" allowPartial:NO];
	NSString *addr = [NodeHandle delHTMLTag:[addrNode rawContents]];
	[dic_args setValue:addr forKey:@"addr"];
	
	NSString *bookNo = [NodeHandle searchContentWithSuperNode:infoNode andPathArray:@[@"collect-share", @"bn-flat"]];
	[dic_args setValue:bookNo forKey:@"book_count"];
	
	HTMLNode *intruNode = [[bodyNode findChildWithAttribute:@"id" matchingName:@"broadcast" allowPartial:NO] findChildOfClass:@"aboutme"];
	NSString *intru = [NodeHandle delHTMLTag:[intruNode rawContents]];
	[dic_args setValue:intru forKey:@"intru"];
	
	HTMLNode *speciNode = [[NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"mod-quan-lists", @"quan-left"]] findChildWithAttribute:@"id" matchingName:@"hlCategoryName" allowPartial:NO];
	NSString *speci = [NodeHandle delHTMLTag:[speciNode rawContents]];
	[dic_args setValue:speci forKey:@"spec"];
	
	HTMLNode *belongNode = [[NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"photoin", @"ll"]] findChildTag:@"a"];
	NSString *belong = [NodeHandle delHTMLTag:[belongNode rawContents]];
	[dic_args setValue:belong forKey:@"belong_group"];
	
	HTMLNode *preNode = [[bodyNode findChildWithAttribute:@"id" matchingName:@"courseDiv" allowPartial:NO] findChildWithAttribute:@"style" matchingName:@"width:840px;overflow:hidden;font-size:large" allowPartial:NO];
	NSString *content = [NodeHandle delHTMLTag:[preNode rawContents]];
//	NSString *ttt = [preNode allContents];
	[dic_args setValue:content forKey:@"content"];
	
	NSArray *imgsSrc = [preNode findChildTags:@"img"];
	if (imgsSrc.count != 0) {
		NSMutableArray *srcs = [NSMutableArray array];
		NSString *baseUrlStr = @"http://www.weichengs.com";
		for (HTMLNode *imgNode in imgsSrc) {
			NSString *src = [imgNode getAttributeNamed:kMXSNodeAttrArgsSrc];
			src = [NSString stringWithFormat:@"%@%@",baseUrlStr, src];
			[srcs addObject:src];
		}
		[dic_args setValue:srcs forKey:@"imgs_src"];
	}
	
	HTMLNode *phoneNode = [bodyNode findChildWithAttribute:@"style" matchingName:@"float: left; margin-top: -2px; margin-left: 10px; font-size: 15px; font-weight: bold;" allowPartial:YES];
	NSString *phone = [NodeHandle delHTMLTag:[phoneNode rawContents]];
	[dic_args setValue:phone forKey:@"phone"];
	
	HTMLNode *commentNode = [NodeHandle searchNodeWithSuperNode:bodyNode andPathArray:@[@"article", @"related_info"]];
	NSArray *cNodeArr = [commentNode findChildrenOfClass:@"status-item"];
	
	NSMutableArray *comments = [NSMutableArray array];
	for (HTMLNode *cNode in cNodeArr) {
		NSString *name = [NodeHandle searchContentWithSuperNode:cNode andPathArray:@[@"hd", @"text"]];
		NSString *com_text = [NodeHandle searchContentWithSuperNode:cNode andPathArray:@[@"bd", @"content"]];
		NSDictionary *dic_comment = @{ @"name":name, @"com_text":com_text};
		[comments addObject:dic_comment];
	}
	[dic_args setValue:comments forKey:@"comments"];
	
	return [dic_args copy];
}

@end
