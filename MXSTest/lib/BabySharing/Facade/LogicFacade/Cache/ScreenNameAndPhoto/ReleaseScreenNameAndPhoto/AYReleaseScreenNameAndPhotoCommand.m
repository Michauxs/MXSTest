//
//  AYReleaseScreenNameAndPhotoCommand.m
//  BabySharing
//
//  Created by BM on 4/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYReleaseScreenNameAndPhotoCommand.h"
#import "AYScreenNameAndPhotoCacheFacade.h"
#import "AYFactoryManager.h"

@implementation AYReleaseScreenNameAndPhotoCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    AYScreenNameAndPhotoCacheFacade* f = USERCACHE;
    @synchronized (f) {
        [f.head_lst removeAllObjects];
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
