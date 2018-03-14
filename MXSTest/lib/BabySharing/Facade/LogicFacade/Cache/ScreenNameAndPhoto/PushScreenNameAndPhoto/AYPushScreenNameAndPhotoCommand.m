//
//  AYPushScreenNameAndPhotoCommand.m
//  BabySharing
//
//  Created by BM on 4/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPushScreenNameAndPhotoCommand.h"
#import "AYScreenNameAndPhotoCacheFacade.h"
#import "AYFactoryManager.h"

@implementation AYPushScreenNameAndPhotoCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
    AYScreenNameAndPhotoCacheFacade* f = USERCACHE;
    @synchronized (self) {
        
        NSDictionary* dic = (NSDictionary*)*obj;
        NSString* user_id = [dic objectForKey:@"user_id"];

        NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.user_id=%@", user_id];
        NSPredicate* not_p = [NSPredicate predicateWithFormat:@"SELF.user_id!=%@", user_id];

        NSArray* arr = [f.head_lst filteredArrayUsingPredicate:p];

        if (arr.count > 1) {
            @throw [[NSException alloc]initWithName:@"error" reason:@"cache error with primary key" userInfo:nil];
        } else if (arr.count == 1) {
            [f.head_lst filterUsingPredicate:not_p];
        }

        [f.head_lst addObject:dic];
    }
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
