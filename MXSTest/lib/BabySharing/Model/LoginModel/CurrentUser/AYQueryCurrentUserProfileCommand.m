//
//  AYQueryCurrentUserProfileCommand.m
//  BabySharing
//
//  Created by BM on 29/09/2016.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryCurrentUserProfileCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

#import "AYModelFacade.h"

@implementation AYQueryCurrentUserProfileCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"query tmp user profile in local db: %@", *obj);
    
    AYModelFacade* f = LOGINMODEL;
    CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
    
    NSDictionary* cur = [LoginToken userToken2Attr:tmp.who];
    *obj = [cur copy];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
