//
//  AYQueryRegUserCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryRegUserCommand.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYCommandDefines.h"

#import "RegTmpToken.h"
#import "RegTmpToken+ContextOpt.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "RegCurrentToken.h"
#import "RegCurrentToken+ContextOpt.h"

@implementation AYQueryRegUserCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"query tmp user in local db: %@", *obj);
    
    AYModelFacade* f = LOGINMODEL;
    *obj = [RegCurrentToken enumCurrentRegLoginUserInContext:f.doc.managedObjectContext];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
