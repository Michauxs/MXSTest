//
//  AYLandingAreaCodeCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingAreaCodeCommand.h"
#import "AYCommandDefines.h"
#import <UIKit/UIKit.h>


@implementation AYLandingAreaCodeCommand

@synthesize para = _para;

- (void)postPerform {

}

- (void)performWithResult:(NSObject**)obj {
    [[[UIAlertView alloc]initWithTitle:@"提示" message:@"现只支持中国地区电话短信服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
