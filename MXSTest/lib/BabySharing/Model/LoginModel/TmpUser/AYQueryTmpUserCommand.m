//
//  AYQueryTmpUserCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryTmpUserCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "RegTmpToken.h"
#import "RegTmpToken+ContextOpt.h"

#import "AYModelFacade.h"

@implementation AYQueryTmpUserCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"query tmp user in local db: %@", *obj);
    
    NSDictionary* dic = (NSDictionary*)*obj;
    NSString* phoneNo = [dic objectForKey:@"phoneNo"];
    
    AYModelFacade* f = LOGINMODEL;
    RegTmpToken* tmp = [RegTmpToken enumRegTokenINContext:f.doc.managedObjectContext WithPhoneNo:phoneNo];
    *obj = tmp.reg_token;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
