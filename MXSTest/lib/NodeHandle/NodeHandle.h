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

+ (NSDictionary *)handNodeWithServiceUrl:(NSString*)urlStr;
+ (NSDictionary *)handNodeWithNurseryUrl:(NSString*)urlStr;

+ (NSDictionary *)handNodeWithPromoteUrl:(NSString*)urlStr;
+ (NSArray *)handUrlListFromCategoryUrl:(NSString*)url;

+ (NSString *)replacingOccurrencesString:(NSString*)string;
+ (NSString*)extractionStringFromString:(NSString*)string;
+ (NSString*)requestHtmlStringWith:(NSString*)url;
+ (NSString *)delHTMLTag:(NSString *)html;


@end
