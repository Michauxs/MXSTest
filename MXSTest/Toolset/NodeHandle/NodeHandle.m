//
//  NodeHandle.m
//  MXSTest
//
//  Created by Alfred Yang on 23/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "NodeHandle.h"

@implementation NodeHandle
+(HTMLParser *)getHTMLParserWithHTMLString:(NSString *)htmlStr {
	
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlStr error:&error];
	if (error) {
		NSLog(@"HTMLParser Error: %@", error);
		return nil;
	} else
		return parser;
	
}

+ (NSString *)searchContentWithSuperNode:(HTMLNode*)superNode andPathArray:(NSArray*)array {
	
	NSString *string;
	HTMLNode *subNode;
	
	for (NSString *classP in array) {
		subNode = [superNode findChildOfClass:classP];
		superNode = subNode;
	}
	string = [NodeHandle delHTMLTag:[subNode rawContents]];
	string = [NodeHandle replacingOccurrencesString:string];
	return string;
}

+ (HTMLNode*)searchNodeWithSuperNode:(HTMLNode*)superNode andPathArray:(NSArray*)array {
	
	HTMLNode *subNode;
	
	for (NSString *classP in array) {
		subNode = [superNode findChildOfClass:classP];
		superNode = subNode;
	}
	
	return subNode;
}

+ (TFHppleElement*)searchElemWithSuperElem:(TFHppleElement*)superElem andPathArray:(NSArray*)array {
	
	TFHppleElement *subElem;
	
	for (NSString *className in array) {
		subElem = [superElem firstChildWithClassName:className];
		superElem = subElem;
	}
	
	return subElem;
}

#pragma mark -- methed
+ (NSString *)replacingOccurrencesString:(NSString*)string {
	string = [string stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
	string = [string stringByReplacingOccurrencesOfString:@"\n \n" withString:@"\n"];
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
	html = [NodeHandle replacingOccurrencesString:html];
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
	
//	NSString *dataReturned1 = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
//	NSLog(@"returned htmlASCII is:  %@\n\n", dataReturned);
//	return dataReturned1;
	
//	kCFStringEncodingGB_18030_2000
//	NSUTF8StringEncoding

	NSString *dataReturned4 = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
//	NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//	NSString *dataReturned4 = [[NSString alloc] initWithData:returnData encoding:gbkEncoding];
	
	return dataReturned4;
}

@end
