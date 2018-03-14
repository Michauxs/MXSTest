//
//  AYLoginSNSWechatCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoginSNSWithWeiboCommand.h"
#import "AYNotifyDefines.h"
#import "AYFacade.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "WeiboSDK.h"
// weibo sdk
#import "WBHttpRequest+WeiboUser.h"
#import "WBHttpRequest+WeiboShare.h"

@interface AYLoginSNSWithWeiboCommand ()

@end

@implementation AYLoginSNSWithWeiboCommand

@synthesize para = _para;

- (void)postPerform {

}

- (void)performWithResult:(NSObject**)obj {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://192.168.0.101";
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
    AYFacade* f = FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"SNSWeibo");
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
