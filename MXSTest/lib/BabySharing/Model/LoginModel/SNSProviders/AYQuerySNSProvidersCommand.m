//
//  AYQuerySNSProvidersCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQuerySNSProvidersCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "Providers.h"
#import "Providers+ContextOpt.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"

@implementation AYQuerySNSProvidersCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"change provider info in local db: %@", *obj);
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    NSString* user_id = [dic objectForKey:@"user_id"];
    
    AYModelFacade* f = LOGINMODEL;
    LoginToken* user = [LoginToken enumLoginUserInContext:f.doc.managedObjectContext withUserID:user_id];
    Providers* tmp = user.connectWith.anyObject;
    
    NSMutableDictionary* dic_result = [[NSMutableDictionary alloc]init];
    [dic_result setValue:tmp.provider_name forKey:@"provide_name"];
    [dic_result setValue:tmp.provider_user_id forKey:@"provide_user_id"];
    [dic_result setValue:tmp.provider_token forKey:@"provide_token"];
    
    *obj = [dic_result copy];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
