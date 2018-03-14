//
//  AYUpdataChatSessionCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/15/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUpdataChatSessionCommand.h"

#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "NotificationOwner.h"
#import "NotificationOwner+ContextOpt.h"

@implementation AYUpdataChatSessionCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"update session in local db");
   
    NSDictionary* dic = nil;
    CURRENUSER(dic);
    
    NSArray* reVal = (NSArray*)*obj;
    
    AYModelFacade* f = CHATSESSIONMODEL;
    [NotificationOwner updateMultipleChatGroupWithOwnerID:[dic objectForKey:@"user_id"] chatGroups:reVal inContext:f.doc.managedObjectContext];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
