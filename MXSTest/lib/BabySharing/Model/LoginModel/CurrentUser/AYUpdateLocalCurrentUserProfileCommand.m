//
//  AYUpdateLocalCurrentUserProfileCommand.m
//  BabySharing
//
//  Created by BM on 30/09/2016.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUpdateLocalCurrentUserProfileCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#import "AYModelFacade.h"

@implementation AYUpdateLocalCurrentUserProfileCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"update tmp user in local db: %@", *obj);
    
    AYModelFacade* f = LOGINMODEL;
    CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
    LoginToken* cur = tmp.who;
    
    NSDictionary* dic = (NSDictionary*)*obj;
    NSString* uid = nil;
    if (cur == nil) {
        uid = [dic objectForKey:@"user_id"];
    } else uid = cur.user_id;
   
    [LoginToken updataLoginUserInContext:f.doc.managedObjectContext withUserID:uid andAttrs:dic];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
