//
//  NodeHandle.h
//  MXSTest
//
//  Created by Alfred Yang on 23/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NodeHandle : NSObject

+ (NSDictionary *)handNodeWithServiceUrl:(NSString*)urlStr;
+ (NSDictionary *)handNodeWithPromoteUrl:(NSString*)urlStr;


+ (NSArray *)getUrlListFromCategoryUrl:(NSString*)url;

+ (NSString*)extractionStringFromString:(NSString*)string;
+ (NSString*)requestHtmlStringWith:(NSString*)url;

@end
