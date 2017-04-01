//
//  MXSCity58Handle.m
//  MXSTest
//
//  Created by Alfred Yang on 27/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSCity58Handle.h"

@implementation MXSCity58Handle

+ (NSArray*)handNodeWithSimple {
//	http://bj.58.com/pinbanpinke/pn4/?PGTID=0d35fbca-0000-11b2-c3ad-a61d737461b8&ClickID=1
//	http://bj.58.com/pinbanpinke/pn4/?PGTID=0d35fbca-0000-16e3-93b5-b3af60f39146&ClickID=1
//	http://bj.58.com/pinbanpinke/pn3/?PGTID=0d35fbca-0000-14ef-7af2-330c832dbc3c&ClickID=1
//	http://bj.58.com/pinbanpinke/pn2/?PGTID=0d35fbca-0000-1ef4-41f2-ab92e525292a&ClickID=1
//	http://bj.58.com/pinbanpinke/?PGTID=0d35fbca-0000-1b3e-962f-2c18a94f82d1&ClickID=1
	
//	http://bj.58.com/tiyu/pn9/pve_8547_599748/?PGTID=0d308613-0000-1cb2-0f99-4d5778f0dc3e&ClickID=1
	
//	http://bj.58.com/pn2/pve_11925_680977/
	
	NSString *webURL_City58 = @"http://bj.58.com/";
	
	NSString *url00 =  @"pve_11925_680977/"; //xueqian
	NSString *url01 =  @"pve_11925_681578/";  //xiaoxue
	NSString *url02 =  @"pve_11926_681589/"; 	//weiqi
	NSString *url03 =  @"pve_11926_681590/"; 	//huihua
	NSString *url04 =  @"pve_11926_681591/"; 	//jingju
	NSString *url05 =  @"pve_11926_681592/"; 	//kehoutuoguan
	NSString *url06 =  @"pve_11926_681594/"; 	//qita
	
	NSString *url07 = @"pve_8547_599748/";	//youer tiyu
	NSString *url08 = @"http://bj.58.com/youjiao/pn1/";	//youer jiaoyu
	NSString *url09 = @"http://bj.58.com/techang/pn1/";		//yishu
	
	NSArray *urlStrArr = @[url00, url01, url02, url03, url04, url05, url06, url07, url08, url09];
	NSArray *catStrArr = @[@"xueqian", @"xiaoxue", @"weiqi", @"huihua", @"jingju", @"kehoutuoguan", @"qita", @"tiyu", @"youjiao", @"yishu"];
	
//	NSMutableArray *hrefsArr_pinban = [NSMutableArray array];
	NSMutableArray *hrefsArr = [NSMutableArray array];
	for (int i = 0; i < urlStrArr.count; ++i) {
		NSMutableArray *arrayM = [NSMutableArray array];
		if (i == 7) {
			
			for (int j = 1; j < 11; ++j) {
				NSString *urlString = [NSString stringWithFormat:@"%@tiyu/pn%d/%@", webURL_City58, j, [urlStrArr objectAtIndex:i]];
				NSArray *hrefs = [self getHrefListFromCategary:urlString];
				[arrayM addObjectsFromArray:hrefs];
			}
			
		} else if (i == 8) {
			for (int j = 1; j < 11; ++j) {
				NSString *urlString = [NSString stringWithFormat:@"%@youjiao/pn%d", webURL_City58, j];
				NSArray *hrefs = [self getHrefListFromCategary:urlString];
				[arrayM addObjectsFromArray:hrefs];
			}
		} else if (i == 9) {
			for (int j = 1; j < 11; ++j) {
				NSString *urlString = [NSString stringWithFormat:@"%@techang/pn%d", webURL_City58, j];
				NSArray *hrefs = [self getHrefListFromCategary:urlString];
				[arrayM addObjectsFromArray:hrefs];
			}
		} else {
			
			for (int j = 1; j < 11; ++j) {
				NSString *urlString = [NSString stringWithFormat:@"%@pinbanpinke/pn%d/%@", webURL_City58, j,[urlStrArr objectAtIndex:i]];
				NSArray *hrefs = [self getHrefListFromCategary:urlString];
				[arrayM addObjectsFromArray:hrefs];
			}
			
		}
		
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
		[dic setValue:arrayM forKey:@"arr"];
		[dic setValue:[catStrArr objectAtIndex:i] forKey:@"arr_cat"];
		[hrefsArr addObject:dic];
		
	}
	
	NSMutableArray *courses = [NSMutableArray array];
//	for (NSDictionary *dic_href in hrefsArr_pinban) {
//		NSDictionary *dic_args = [self getArgsFromPinbanWithUrlStr:[dic_href valueForKey:@"href"]];
//		[courses addObject:dic_args];
//	}
	for (NSDictionary *dic in hrefsArr) {
		
		NSArray *array = [dic valueForKey:@"arr"];
		NSString *arr_cat = [dic valueForKey:@"arr_cat"];
		NSInteger index = [catStrArr indexOfObject:arr_cat];
			
		NSMutableArray *arrayM = [NSMutableArray array];
		if (index >= 7) {
			for (NSDictionary *dic_href in array) {
				NSDictionary *dic_args = [self getArgsFromYouerWithUrlStr:[dic_href valueForKey:@"href"]];
				[arrayM addObject:dic_args];
				
			}
		} else {
			for (NSDictionary *dic_href in array) {
				NSDictionary *dic_args = [self getArgsFromPinbanWithUrlStr:[dic_href valueForKey:@"href"]];
				[arrayM addObject:dic_args];
			}
		}
		
		NSMutableDictionary *dic_course = [[NSMutableDictionary alloc] init];
		[dic_course setValue:arrayM forKey:@"arr"];
		[dic_course setValue:arr_cat forKey:@"cat"];
		[courses addObject:dic_course];
	}
	
//	NSMutableDictionary *dic_hrefs = [[NSMutableDictionary alloc] init];
//	[dic_hrefs setValue:hrefsArr_pinban forKey:@"pinban"];
//	[dic_hrefs setValue:hrefsArr_youer forKey:@"youer"];
//	[MXSFileHandle writeToJsonFile:dic_hrefs withFileName:@"hrefs_58city"];
	[MXSFileHandle writeToJsonFile:[courses copy] withFileName:@"city58"];
	return nil;
}


+ (NSArray *)getHrefListFromCategary:(NSString*)catUrlStr {
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:catUrlStr];
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	
	NSArray *tableNodes = [bodyNode findChildTags:@"table"];
	NSMutableArray *ListArr = [NSMutableArray array];
	for (HTMLNode *tableNode in tableNodes) {
		NSArray *tdivNodes = [tableNode findChildTags:@"div"];
		
		for (HTMLNode *tdivNode in tdivNodes) {
			if ([[tdivNode getAttributeNamed:@"class"] isEqualToString:@"tdiv"]) {
				HTMLNode *aNode = [tdivNode findChildTag:@"a"];
				NSString *href = [aNode getAttributeNamed:@"href"];
				NSString *name = [NodeHandle extractionStringFromString:[aNode rawContents]];
				name = [NodeHandle replacingOccurrencesString:name];
				NSLog(@"name:%@\n", name);
				NSLog(@"href:%@\n", href);
				
				NSMutableDictionary *dic_href = [[NSMutableDictionary alloc] init];
				[dic_href setValue:href forKey:@"href"];
				[dic_href setValue:name forKey:@"name"];
				[ListArr addObject:dic_href];
				
			}
		}
		
	}
	
	return [ListArr copy];
}

+ (NSDictionary *)getArgsFromPinbanWithUrlStr:(NSString *)urlStr {
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	NSArray *divNodes = [bodyNode findChildTags:@"div"];
	NSMutableDictionary *dic_args = [[NSMutableDictionary alloc] init];
	for (HTMLNode *divNode in divNodes) {
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"mainTitle"]) {
			HTMLNode *hNode = [divNode findChildTag:@"h1"];
			NSString *name = [NodeHandle extractionStringFromString:[hNode rawContents]];
			name = [NodeHandle replacingOccurrencesString:name];
			name = [name stringByReplacingOccurrencesOfString:@"<!--{chengxinuser:''}-->" withString:@""];
			[dic_args setValue:name forKey:@"title"];
			
			NSArray *liNodes = [divNode findChildTags:@"li"];
			for (HTMLNode *liNode in liNodes) {
				if ([[liNode getAttributeNamed:@"class"] isEqualToString:@"time"]) {
					NSString *releaseDate = [NodeHandle extractionStringFromString:[liNode rawContents]];
					[dic_args setValue:releaseDate forKey:@"date_release"];
					
				}
			}
			
		}
		
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"descriptionBox"]) {
			HTMLNode *articleNode = [divNode findChildTag:@"article"];
			NSString *desc = [NodeHandle extractionStringFromString:[articleNode rawContents]];
			desc = [NodeHandle replacingOccurrencesString:desc];
//			desc = [desc stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
//			desc = [desc stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
			desc = [NodeHandle delHTMLTag:desc];
			[dic_args setValue:desc forKey:@"desc"];
		}
		
		if ([[divNode getAttributeNamed:@"id"] isEqualToString:@"img_player1"]) {
			NSArray *imgNodes = [divNode findChildTags:@"img"];
			NSMutableArray *imgSrcArr = [NSMutableArray array];
			for (HTMLNode *imgNode  in imgNodes) {
				NSString *img_src = [imgNode getAttributeNamed:@"src"];
				[imgSrcArr addObject:img_src];
			}
			[dic_args setValue:[imgSrcArr copy] forKey:@"img_src"];
		}
		
	}
	
	NSArray *ulNodes = [bodyNode findChildTags:@"ul"];
	for (HTMLNode *ulNode in ulNodes) {
		if ([[ulNode getAttributeNamed:@"class"] isEqualToString:@"suUl"]) {
			NSArray *liNodes = [ulNode findChildTags:@"li"];
			
			for (HTMLNode *liNode in liNodes) {
				
				NSString *value;
				NSString *key;
				
				NSArray*lidivNodes = [liNode findChildTags:@"div"];
				for (HTMLNode *lidivNode in lidivNodes) {
					if ([[lidivNode getAttributeNamed:@"class"] containsString:@"su_tit"]) {
						key = [NodeHandle extractionStringFromString:[lidivNode rawContents]];
					} else {
						NSArray  *spanNodes = [lidivNode findChildTags:@"span"];
						if (spanNodes.count == 1) {
							
							HTMLNode *aNode = [lidivNode findChildTag:@"a"];
							if (aNode) {
								value = [NodeHandle extractionStringFromString:[aNode rawContents]];
							} else {
								value = [NodeHandle extractionStringFromString:[spanNodes.firstObject rawContents]];
							}
							
						} else if(spanNodes.count > 1) {
							for (HTMLNode *spanNode in spanNodes) {
								if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"l_phone"]) {
									value = [NodeHandle extractionStringFromString:[spanNode rawContents]];
								}
							}
						}
					}
					
				}
//				"联 系 人：" : "刘先生",
//				"身       份：" : "个人教师 ",
//				"拼班人数：" : "6-10人 ",
//				"date_release" : "2016-12-23 发布",
//				"价格范围：" : "150-300元\/人\/小时",
//				"title" : "网络营销策划培训,包教包会（大学-其他）",
//				"辅导阶段：" : "大学 ",
//				"场       地：" : "老师\/机构提供 ",
				if (key && value) {
					if ([key containsString:@"辅"]) {
						key = @"stage_edu";
					} else if ([key containsString:@"场"]) {
						key = @"place";
					} else if ([key containsString:@"身"]) {
						key = @"ident";
					} else if ([key containsString:@"价"]) {
						key = @"price";
					} else if ([key containsString:@"咨"]) {
						key = @"contact_tel";
					} else if ([key containsString:@"拼"]) {
						key = @"capacity_numb";
					} else if ([key containsString:@"联"]) {
						key = @"cantact_user";
					}
					if ([value containsString:@"<em></em>"]) {
						value = [value stringByReplacingOccurrencesOfString:@"<em></em>" withString:@""];
					}
					[dic_args setValue:value forKey:key];
				}
				
			}
		}
	}
	
	NSLog(@"michauxs:%@", dic_args);
	
	return [dic_args copy];
}

#pragma mark -- youer
+ (NSDictionary *)getArgsFromYouerWithUrlStr:(NSString *)urlStr {
	
	NSString *htmlStr = [NodeHandle requestHtmlStringWith:urlStr];
//	NSLog(@"%@", htmlStr);
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return nil;
	}
	
	HTMLNode *bodyNode = [parser body];
	NSArray *divNodes = [bodyNode findChildTags:@"div"];
	
	NSMutableDictionary *dic_args = [[NSMutableDictionary alloc] init];
	NSMutableArray *comments = [NSMutableArray array];
	
	for (HTMLNode *divNode in divNodes) {
		
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"comentsBox pingjia_list"]) {
			NSArray *dlNodes = [divNode findChildTags:@"dl"];
			for (HTMLNode *dlNode in dlNodes) {
				
				if ([[dlNode getAttributeNamed:@"class"] isEqualToString:@"comentItem"]) {
					NSMutableDictionary *dic_comm = [[NSMutableDictionary alloc] init];
					
					HTMLNode *tdNode = [dlNode findChildTag:@"dt"];
					NSString *comment_user = [NodeHandle extractionStringFromString:[tdNode rawContents]];
					comment_user  = [[comment_user componentsSeparatedByString:@"<span"] firstObject];
					[dic_comm setValue:comment_user forKey:@"comm_user"];
					
					NSArray *dldivNodes = [dlNode findChildTags:@"div"];
					for (HTMLNode *dldivNode in dldivNodes) {
						if ([[dldivNode getAttributeNamed:@"comentCt"] isEqualToString:@"comentCt"]) {
							NSString *comment_text = [NodeHandle extractionStringFromString:[dldivNode rawContents]];
							comment_text = [NodeHandle replacingOccurrencesString:comment_text];
							[dic_comm setValue:comment_text forKey:@"comm_text"];
						}
					}
					[comments addObject:dic_comm];
				}
			}
			[dic_args setValue:comments forKey:@"comments"];
			
		}
		
		
		
		
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"mainTitle"]) {
			HTMLNode *hNode = [divNode findChildTag:@"h1"];
			NSString *name = [NodeHandle extractionStringFromString:[hNode rawContents]];
			name = [NodeHandle replacingOccurrencesString:name];
			name = [name stringByReplacingOccurrencesOfString:@"<!--{chengxinuser:''}-->" withString:@""];
			[dic_args setValue:name forKey:@"title"];
			
			NSArray *liNodes = [divNode findChildTags:@"li"];
			for (HTMLNode *liNode in liNodes) {
				if ([[liNode getAttributeNamed:@"class"] isEqualToString:@"time"]) {
					NSString *releaseDate = [NodeHandle extractionStringFromString:[liNode rawContents]];
					[dic_args setValue:releaseDate forKey:@"date_release"];
					
				}
			}
			
		}
		
		
		NSMutableArray *bookHistory = [NSMutableArray array];
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"transrecord"]) {
			HTMLNode *tableNode = [divNode findChildTag:@"table"];
			NSArray *trNodes = [tableNode findChildTags:@"tr"];
			
			for (HTMLNode *trNode in trNodes) {
				NSArray *tdNodes = [trNode findChildTags:@"td"];
				
				NSMutableDictionary *dic_book = [[NSMutableDictionary alloc] init];
				for (HTMLNode *tdNode in tdNodes) {
					NSString *yu = [NodeHandle extractionStringFromString:[tdNode rawContents]];
					NSString *key;
					if ([[tdNode getAttributeNamed:@ "class"] isEqualToString:@"td-fk"]) {
						key = @"book_user";
					} else {
						
						NSString *regex = @"[\u4e00-\u9fa5]+";
						NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
						if ([pred evaluateWithObject: yu]) {
							key = @"book_shop";
						} else {
							key = @"book_date";
						}
					}
					
					[dic_book setValue:yu forKey:key];
				}
				[bookHistory addObject:dic_book];
			}
		}
		[dic_args setValue:bookHistory forKey:@"book"];
		
		/*shuxing*/
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"sevparam-inner"]) {
			
			NSArray *tdNodes = [divNode findChildTags:@"td"];
//			NSMutableDictionary *dic_prop = [[NSMutableDictionary alloc] init];
			for (HTMLNode *tdNode in tdNodes) {
				
				NSArray *tddivNodes = [tdNode findChildTags:@"div"];
				NSString *value;
				NSString *key;
				for (HTMLNode *tddivNode in tddivNodes) {
					if ([[tddivNode getAttributeNamed:@"class"] isEqualToString:@"sevparam-item-t"]) {
						key = [NodeHandle extractionStringFromString:[tddivNode rawContents]];
					} else {
						HTMLNode *spanNode = [tddivNode findChildTag:@"span"];
						value = [NodeHandle extractionStringFromString:[spanNode rawContents]];
					}
				}
				if (value && key) {
					if ([key containsString:@"入"]) {
						key = @"capacity";
					} else if ([key containsString:@"服"]) {
						key = @"work_type";
					} else if ([key containsString:@"教"]) {
						key = @"stage_edu";
					} else if ([key containsString:@"办"]) {
						key = @"build_type";
					} else if ([key containsString:@"对"]) {
						key = @"applyto";
					}
					[dic_args setValue:value forKey:key];
				} else {
					
				}
				
			}
			
		} // end if
		
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"descriptionBox"]) {
			HTMLNode *articleNode = [divNode findChildTag:@"article"];
			NSString *desc = [NodeHandle extractionStringFromString:[articleNode rawContents]];
			desc = [NodeHandle replacingOccurrencesString:desc];
//			desc = [desc stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
//			desc = [desc stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
			desc = [NodeHandle delHTMLTag:desc];
			[dic_args setValue:desc forKey:@"desc"];
		}
		
		if ([[divNode getAttributeNamed:@"id"] isEqualToString:@"img_player1"]) {
			NSArray *imgNodes = [divNode findChildTags:@"img"];
			NSMutableArray *imgSrcArr = [NSMutableArray array];
			for (HTMLNode *imgNode  in imgNodes) {
				NSString *img_src = [imgNode getAttributeNamed:@"src"];
				[imgSrcArr addObject:img_src];
			}
			[dic_args setValue:[imgSrcArr copy] forKey:@"img_src"];
		}
		
		
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"userinfotit"]) {
			HTMLNode *h2Node = [divNode findChildTag:@"h2"];
			NSString *companyName = [NodeHandle extractionStringFromString:[h2Node rawContents]];
			[dic_args setValue:companyName forKey:@"company_name"];
		}
		
	}
	
	/*user info*/
	NSArray *ulNodes = [bodyNode findChildTags:@"ul"];
	for (HTMLNode *ulNode in ulNodes) {
		if ([[ulNode getAttributeNamed:@"class"] isEqualToString:@"suUl"]) {
			NSArray *liNodes = [ulNode findChildTags:@"li"];
			
			for (HTMLNode *liNode in liNodes) {
				
				NSString *value;
				NSString *key;
				
				NSArray*lidivNodes = [liNode findChildTags:@"div"];
				for (HTMLNode *lidivNode in lidivNodes) {
					if ([[lidivNode getAttributeNamed:@"class"] containsString:@"su_tit"]) {
						key = [NodeHandle extractionStringFromString:[lidivNode rawContents]];
					} else {
						
						HTMLNode *aNode = [lidivNode findChildTag:@"a"];
						if (!value) {
							value = [NodeHandle extractionStringFromString:[aNode rawContents]];
						}
							
						HTMLNode  *spanNode = [lidivNode findChildTag:@"span"];
						if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"adr"]) {
							value = [NodeHandle extractionStringFromString:[spanNode rawContents]];
							value = [NodeHandle replacingOccurrencesString:value];
							value = [value stringByReplacingOccurrencesOfString:@"-" withString:@""];
						}
						
					}
					
				}
				
				if (key && value) {
					if ([key containsString:@"教"]) {
						key = @"stage_edu";
					} else if ([key containsString:@"商"]) {
						key = @"addr";
					} else if ([key containsString:@"服"]) {
						key = @"service_area";
					} else if ([key containsString:@"联"]) {
						key = @"cantact_user";
					} else if ([key containsString:@"别"]) {
						key = @"course_cat";
					} else if ([key containsString:@"小"]) {
						key = @"course_cat_sub";
					}
					if ([value containsString:@"<em></em>"]) {
						value = [value stringByReplacingOccurrencesOfString:@"<em></em>" withString:@""];
					}
					[dic_args setValue:value forKey:key];
				}
				
			}
		}
		
		
		if ([[ulNode getAttributeNamed:@"class"] isEqualToString:@"uinfolist"]) {
			NSArray *spanNodes = [ulNode findChildTags:@"span"];
			for (HTMLNode *spanNode in spanNodes) {
				if ([[spanNode getAttributeNamed:@"class"] isEqualToString:@"ico-rzv-b"]) {
					NSString *authInfo = [spanNode getAttributeNamed:@"title"];
					[dic_args setValue:authInfo forKey:@"auth_info"];
				}
			}
		}
		
		
	}
	
	
	NSLog(@"michauxs:%@", dic_args);
	
	return [dic_args copy];
}

@end
