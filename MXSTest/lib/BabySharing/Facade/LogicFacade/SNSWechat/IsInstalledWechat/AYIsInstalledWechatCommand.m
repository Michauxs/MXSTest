//
//  AYLoginSNSWithWechatCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYIsInstalledWechatCommand.h"
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "AYNotifyDefines.h"
#import "AYFacade.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

static NSString* const kWechatUserInfo = @"snsapi_userinfo,snsapi_base";
static NSString* const kWechatAuthState = @"0744";

@interface AYIsInstalledWechatCommand () <WXApiDelegate>

@end

@implementation AYIsInstalledWechatCommand

@synthesize para = _para;

- (void)postPerform {
}

- (void)performWithResult:(NSObject**)obj {
    
    BOOL isWXAppInstalled = [WXApi isWXAppInstalled];
    
    *obj = [NSNumber numberWithBool:isWXAppInstalled];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
