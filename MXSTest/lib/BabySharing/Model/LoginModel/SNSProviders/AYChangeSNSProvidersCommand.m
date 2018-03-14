//
//  AYChangeSNSProvidersCommands.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYChangeSNSProvidersCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "Providers.h"
#import "Providers+ContextOpt.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"

@implementation AYChangeSNSProvidersCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"change provider info in local db: %@", *obj);
   
    NSDictionary* dic = (NSDictionary*)*obj;
    
    NSString* provide_name = [dic objectForKey:@"provide_name"];
    NSString* provide_user_id = [dic objectForKey:@"provide_user_id"];
    NSString* provide_token = [dic objectForKey:@"provide_token"];
    NSString* provide_screen_name = [dic objectForKey:@"provide_screen_name"];
    
    AYModelFacade* f = LOGINMODEL;
    Providers* tmp = [Providers createProviderInContext:f.doc.managedObjectContext ByName:provide_name andProviderUserId:provide_user_id andProviderToken:provide_token andProviderScreenName:provide_screen_name];
	
	NSString* user_id = [dic objectForKey:kAYCommArgsUserID];
    LoginToken* user = [LoginToken enumLoginUserInContext:f.doc.managedObjectContext withUserID:user_id];
    [user addConnectWithObject:tmp];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
