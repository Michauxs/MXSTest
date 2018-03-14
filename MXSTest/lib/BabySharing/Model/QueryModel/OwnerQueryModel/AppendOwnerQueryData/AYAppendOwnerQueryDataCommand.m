//
//  AYRefrashOwnerQueryDataCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYAppendOwnerQueryDataCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "QueryContent.h"
#import "QueryContent+ContextOpt.h"

@implementation AYAppendOwnerQueryDataCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"change provider info in local db: %@", *obj);
    NSDictionary* result = (NSDictionary*)*obj;
    
    NSArray* reVal = [result objectForKey:@"result"];
    
    AYModelFacade* f = OWNERQUERYMODEL;
    [QueryContent appendLocalQueryDataInContext:f.doc.managedObjectContext withData:reVal];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
