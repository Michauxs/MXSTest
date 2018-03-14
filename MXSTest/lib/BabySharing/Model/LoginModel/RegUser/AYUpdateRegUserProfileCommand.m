//
//  AYUpdateRegUserProfileCommand.m
//  BabySharing
//
//  Created by BM on 11/11/2016.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUpdateRegUserProfileCommand.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYCommandDefines.h"

#import "RegTmpToken.h"
#import "RegTmpToken+ContextOpt.h"
#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "RegCurrentToken.h"
#import "RegCurrentToken+ContextOpt.h"

#import "AYModelFacade.h"
#import "AYModel.h"

@implementation AYUpdateRegUserProfileCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"query tmp user in local db: %@", *obj);
    
    NSDictionary* dic = (NSDictionary*)*obj;
    AYModelFacade* f = LOGINMODEL;
    [RegCurrentToken updateCurrentRegUserProfileWithAttr:dic inContext:f.doc.managedObjectContext];
    
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYCurrentRegUserProfileChanged forKey:kAYNotifyFunctionKey];
    
    [notify setValue:[dic copy] forKey:kAYNotifyArgsKey];
    AYModel* m = MODEL;
    [m performWithResult:&notify];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
