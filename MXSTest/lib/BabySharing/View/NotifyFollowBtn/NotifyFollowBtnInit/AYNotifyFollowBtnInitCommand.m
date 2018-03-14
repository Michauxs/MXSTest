//
//  AYNotifyFollowBtnInitCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 24/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYNotifyFollowBtnInitCommand.h"
#import "AYCommandDefines.h"
#import "AYPhotoTagView.h"
#import "AYRelationshipBtnView.h"
#import "AYQueryModelDefines.h"
#import "AYFactoryManager.h"

@implementation AYNotifyFollowBtnInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSNumber* current_relations = (NSNumber*)*obj;
    
    id<AYViewBase> result = nil;
    switch (current_relations.integerValue) {
        case UserPostOwnerConnectionsFriends:
        case UserPostOwnerConnectionsFollowing:
            result = VIEW(@"NotifyFollowedBtn", @"NotifyFollowedBtn");
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed:
            result = VIEW(@"NotifyUnFollowBtn", @"NotifyUnFollowBtn");
            break;
        default:
            break;
    }
    [result postPerform];
    *obj = result;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
