//
//  MXSEMCmd.h
//  MXSTest
//
//  Created by Sunfei on 2018/4/13.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HyphenateLite/HyphenateLite.h>

@interface MXSEMCmd : NSObject <EMClientDelegate>

+ (MXSEMCmd*)shared;

- (void)registerUserWithName:(NSString*)name;
- (void)logoutEMClient;
- (void)loginEMWithName:(NSString*)name;

@end
