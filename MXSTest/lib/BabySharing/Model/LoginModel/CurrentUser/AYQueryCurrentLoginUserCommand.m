//
//  AYQueryCurrentLoginUserCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryCurrentLoginUserCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#import "AYModelFacade.h"

@implementation AYQueryCurrentLoginUserCommand {
}
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"query tmp user in local db: %@", *obj);
   
    AYModelFacade* f = LOGINMODEL;
    CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
    
    NSMutableDictionary* cur = [[NSMutableDictionary alloc]initWithCapacity:2];
    [cur setValue:tmp.who.user_id forKey:kAYCommArgsUserID];
    [cur setValue:tmp.who.auth_token forKey:kAYCommArgsToken];
    
    *obj = [cur copy];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
