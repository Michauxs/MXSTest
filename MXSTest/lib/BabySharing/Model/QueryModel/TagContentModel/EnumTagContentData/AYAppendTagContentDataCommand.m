//
//  AYAppendTagContentDataCommand.m
//  BabySharing
//
//  Created by BM on 4/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYAppendTagContentDataCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "QueryContent.h"
#import "QueryContent+ContextOpt.h"

@implementation AYAppendTagContentDataCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"change provider info in local db: %@", *obj);
    NSDictionary* result = (NSDictionary*)*obj;
    
    NSArray* reVal = [result objectForKey:@"result"];
    
    AYModelFacade* f = TAGCONTENTMODEL;
    [QueryContent appendLocalQueryDataInContext:f.doc.managedObjectContext withData:reVal];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
