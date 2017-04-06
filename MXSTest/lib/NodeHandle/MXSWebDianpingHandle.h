//
//  MXSWebDianpingHandle.h
//  MXSTest
//
//  Created by Alfred Yang on 5/4/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXSBaseHandle.h"

@interface MXSWebDianpingHandle : MXSBaseHandle

+ (NSDictionary *)handNodeWithServiceUrl:(NSString*)urlStr;
+ (NSDictionary *)handNodeWithNurseryUrl:(NSString*)urlStr;

+ (NSDictionary *)handNodeWithPromoteUrl:(NSString*)urlStr;
+ (NSArray *)handUrlListFromCategoryUrl:(NSString*)url;

@end
