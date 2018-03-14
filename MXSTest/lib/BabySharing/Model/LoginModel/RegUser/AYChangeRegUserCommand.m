//
//  AYChangeRegUserCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/27/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYChangeRegUserCommand.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYCommandDefines.h"

#import "RegTmpToken.h"
#import "RegTmpToken+ContextOpt.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "RegCurrentToken.h"
#import "RegCurrentToken+ContextOpt.h"

@implementation AYChangeRegUserCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"query tmp user in local db: %@", *obj);
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    AYModelFacade* f = LOGINMODEL;
    LoginToken *user = [LoginToken createTokenInContext:f.doc.managedObjectContext withUserID:[dic objectForKey:@"user_id"] andAttrs:dic];
	
    *obj = [RegCurrentToken changeCurrentRegLoginUser:user inContext:f.doc.managedObjectContext];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
