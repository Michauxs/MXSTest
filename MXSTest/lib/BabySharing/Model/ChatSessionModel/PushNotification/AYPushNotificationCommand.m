//
//  AYPushNotificationCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPushNotificationCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "NotificationOwner.h"
#import "NotificationOwner+ContextOpt.h"

@implementation AYPushNotificationCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"query chat session in local db");
    
    AYModelFacade* f = CHATSESSIONMODEL;
    
    NSDictionary* dic = (NSDictionary*)*obj;
    NSDictionary* user = nil;
    CURRENUSER(user)
    
    [NotificationOwner addNotification:[dic copy] forUser:[user objectForKey:@"user_id"] inContext:f.doc.managedObjectContext];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
