//
//  MXSFileHandle.h
//  MXSTest
//
//  Created by Alfred Yang on 30/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NodeHandle.h"

@interface MXSFileHandle : NSObject

+ (void)writeToPlistFile:(id)info withFileName:(NSString*)fileName ;
+ (void)writeToJsonFile:(id)info withFileName:(NSString*)fileName ;

+ (void)transPlistToJsonWithPlistFile:(NSString*)plistName andJsonFile:(NSString*)jsonName;

@end
