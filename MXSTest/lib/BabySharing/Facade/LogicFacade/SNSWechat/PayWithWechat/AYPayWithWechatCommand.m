//
//  AYPayWithWechatCommand.m
//  BabySharing
//
//  Created by BM on 8/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPayWithWechatCommand.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "AYSNSWechatDefines.h"
#import "AYCommandDefines.h"

#import "AYWechatFuncHelper.h"

@implementation AYPayWithWechatCommand

@synthesize para = _para;

- (void)postPerform {
}

- (void)performWithResult:(NSObject**)obj {
    NSDictionary* args = (NSDictionary*)*obj;
	
    NSString *prepay_id = [args objectForKey:@"prepay_id"];
	if (!prepay_id || [prepay_id isEqualToString:@""]) {
		return;
	}
    NSString* nonce_str = [AYWechatFuncHelper randomNonceStr];
    UInt32 date = [[NSDate date] timeIntervalSince1970];
    
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = AYDONGDAPARTNERID;
    request.prepayId= prepay_id;
    request.package = AYPACKAGE;
    request.nonceStr= nonce_str;
    request.timeStamp= date;
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:AYDONGDAID forKey:@"appid"];
    [dic setValue:AYDONGDAPARTNERID forKey:@"partnerid"];
    [dic setValue:prepay_id forKey:@"prepayid"];
    [dic setValue:AYPACKAGE forKey:@"package"];
    [dic setValue:nonce_str forKey:@"noncestr"];
    [dic setValue:[NSString stringWithFormat:@"%d", date] forKey:@"timestamp"];
   
    request.sign= [AYWechatFuncHelper paySignatureWithArgs:[dic copy]];
    [WXApi sendReq:request];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
