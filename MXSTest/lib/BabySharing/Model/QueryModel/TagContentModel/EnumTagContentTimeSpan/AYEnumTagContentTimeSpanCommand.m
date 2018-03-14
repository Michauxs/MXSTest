//
//  AYEnumTagContentTimeSpanCommand.m
//  BabySharing
//
//  Created by BM on 4/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYEnumTagContentTimeSpanCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "QueryContent.h"
#import "QueryContent+ContextOpt.h"

@implementation AYEnumTagContentTimeSpanCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"change provider info in local db: %@", *obj);
    
    AYModelFacade* f = TAGCONTENTMODEL;
    *obj = [QueryContent enumContentTimeSpanInContext:f.doc.managedObjectContext];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
