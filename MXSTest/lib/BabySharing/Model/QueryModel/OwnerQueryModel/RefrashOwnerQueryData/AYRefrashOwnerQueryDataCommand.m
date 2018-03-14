//
//  AYRefrashOwnerQueryDataCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRefrashOwnerQueryDataCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "QueryContent.h"
#import "QueryContent+ContextOpt.h"

@implementation AYRefrashOwnerQueryDataCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"change provider info in local db: %@", *obj);

    NSDictionary* result = (NSDictionary*)*obj;
    
    NSArray* reVal = [result objectForKey:@"result"];
    NSNumber*  time = [result objectForKey:@"date"];

    AYModelFacade* f = OWNERQUERYMODEL;
    [QueryContent refrashLocalQueryDataInContext:f.doc.managedObjectContext withData:reVal andTimeSpan:time.longLongValue];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
