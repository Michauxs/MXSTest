//
//  AYEnumHomeQueryDataCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/14/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYEnumHomeQueryDataCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "QueryContent.h"
#import "QueryContent+ContextOpt.h"

@implementation AYEnumHomeQueryDataCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"change provider info in local db: %@", *obj);
    
    AYModelFacade* f = HOMECONTENTMODEL;
    *obj = [QueryContent enumLocalQueyDataInContext:f.doc.managedObjectContext];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
