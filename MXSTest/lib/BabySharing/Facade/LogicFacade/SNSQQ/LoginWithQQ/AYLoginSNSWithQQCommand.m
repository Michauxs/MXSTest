//
//  AYLoginWithQQCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoginSNSWithQQCommand.h"
// qq sdk
#import "TencentOAuth.h"
#import "AYFacade.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYSNSQQFacade.h"
#import "AYNotifyDefines.h"

@interface AYLoginSNSWithQQCommand () 

@end

@implementation AYLoginSNSWithQQCommand {
//    TencentOAuth* qq_oauth;
//    NSArray* permissions;
}
@synthesize para = _para;

- (void)postPerform {

}

- (void)performWithResult:(NSObject**)obj {
    AYSNSQQFacade* qq_facade = FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"SNSQQ");
    TencentOAuth* qq_oauth = qq_facade.qq_oauth;
    NSArray* permissions = qq_facade.permissions;
    [qq_oauth authorize:permissions inSafari:YES];

    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyStartLogin forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [qq_facade performWithResult:&notify];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
