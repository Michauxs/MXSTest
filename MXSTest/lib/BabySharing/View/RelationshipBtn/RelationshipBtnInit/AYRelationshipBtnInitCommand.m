//
//  AYRelationshipBtnInitCommand.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRelationshipBtnInitCommand.h"
#import "AYCommandDefines.h"
#import "AYPhotoTagView.h"
#import "AYRelationshipBtnView.h"
#import "AYQueryModelDefines.h"

//#import "AYSamePersonBtnView.h"
//#import "AYFollowingBtnView.h"
//#import "AYFollowedBtnView.h"
//#import "AYFriendsBtnView.h"
#import "AYFactoryManager.h"

@implementation AYRelationshipBtnInitCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSNumber* current_relations = (NSNumber*)*obj;
   
    id<AYViewBase> result = nil;
    switch (current_relations.integerValue) {
        case UserPostOwnerConnectionsSamePerson:
            result = VIEW(@"SamePersonBtn", @"SamePersonBtn");
            break;
        case UserPostOwnerConnectionsFollowing:
            result = VIEW(@"FollowingBtn", @"FollowingBtn");
            break;
        case UserPostOwnerConnectionsNone:
        case UserPostOwnerConnectionsFollowed:
            result = VIEW(@"FollowedBtn", @"FollowedBtn");
            break;
        case UserPostOwnerConnectionsFriends:
            result = VIEW(@"FriendsBtn", @"FriendsBtn");
            break;
        default:
            result = VIEW(@"InvitationBtn", @"InvitationBtn");
            break;
    }
    [result postPerform];
    *obj = result;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
