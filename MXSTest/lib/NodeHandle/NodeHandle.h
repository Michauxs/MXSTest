//
//  NodeHandle.h
//  MXSTest
//
//  Created by Alfred Yang on 23/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MXSCity58Handle.h"

@interface NodeHandle : NSObject


#pragma mark -- common

+ (HTMLParser*)getHTMLParserWithHTMLString:(NSString*)htmlStr;

+ (NSString *)searchContentWithSuperNode:(HTMLNode*)superNode andPathArray:(NSArray*)array ;
+ (HTMLNode*)searchNodeWithSuperNode:(HTMLNode*)superNode andPathArray:(NSArray*)array ;


+ (NSString *)replacingOccurrencesString:(NSString*)string;
+ (NSString*)extractionStringFromString:(NSString*)string;
+ (NSString*)requestHtmlStringWith:(NSString*)url;
+ (NSString *)delHTMLTag:(NSString *)html;


@end
