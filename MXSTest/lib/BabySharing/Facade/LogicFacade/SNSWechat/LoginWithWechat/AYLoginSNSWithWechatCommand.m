//
//  AYLoginSNSWithWechatCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoginSNSWithWechatCommand.h"
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "AYNotifyDefines.h"
#import "AYFacade.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

static NSString* const kWechatUserInfo = @"snsapi_userinfo,snsapi_base";
static NSString* const kWechatAuthState = @"0744";

@interface AYLoginSNSWithWechatCommand () <WXApiDelegate>

@end

@implementation AYLoginSNSWithWechatCommand

@synthesize para = _para;

- (void)postPerform {
}

- (void)performWithResult:(NSObject**)obj {
    
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = kWechatUserInfo;
    req.state = kWechatAuthState;
    [WXApi sendReq:req];
    
    AYFacade* f = FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"SNSWechat");
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyStartLogin forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [f performWithResult:&notify];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
