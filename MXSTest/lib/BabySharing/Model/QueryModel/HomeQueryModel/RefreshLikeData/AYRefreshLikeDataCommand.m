//
//  AYRefreshLikeDataCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/15/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRefreshLikeDataCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "QueryContent.h"
#import "QueryContent+ContextOpt.h"

@implementation AYRefreshLikeDataCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"like content : %@", *obj);
    NSDictionary* result = (NSDictionary*)*obj;

    NSString* post_id = [result objectForKey:@"post_id"];
    NSNumber* like_result = [result objectForKey:@"like_result"];
    
    AYModelFacade* f = HOMECONTENTMODEL;
    NSArray* like_array =  [[result objectForKey:@"result"] objectForKey:@"likes"];
    NSNumber* like_count =  [[result objectForKey:@"result"] objectForKey:@"likes_count"];
    [QueryContent refreshLikesToPostWithID:post_id withArr:like_array andLikesCount:like_count inContext:f.doc.managedObjectContext];
    [QueryContent refreshIslike:like_result postId:post_id inContext:f.doc.managedObjectContext];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
