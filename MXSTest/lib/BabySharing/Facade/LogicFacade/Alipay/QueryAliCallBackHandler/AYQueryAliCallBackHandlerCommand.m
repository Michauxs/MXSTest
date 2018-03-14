//
//  AYQueryAliCallBackHandlerCommand.m
//  BabySharing
//
//  Created by BM on 08/03/2017.
//  Copyright © 2017 Alfred Yang. All rights reserved.
//

#import "AYQueryAliCallBackHandlerCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYNotifyDefines.h"

#import "AYAlipayFacade.h"

@implementation AYQueryAliCallBackHandlerCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYAlipayFacade* alipay_facade = FACADE(kAYFactoryManagerCommandTypeDefaultFacade, @"Alipay");
    *obj = alipay_facade.cltBlock;
}


- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
