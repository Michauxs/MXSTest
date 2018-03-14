//
//  AYRemoteCallDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 3/27/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYRemoteCallDefines_h
#define AYRemoteCallDefines_h

//typedef NS_ENUM(NSInteger, UserPostOwnerConnections) {
//    UserPostOwnerConnectionsNone,
//    UserPostOwnerConnectionsSamePerson,
//    UserPostOwnerConnectionsFollowing,
//    UserPostOwnerConnectionsFollowed,
//    UserPostOwnerConnectionsFriends
//};

typedef enum : NSUInteger {
    RemoteControllerStatusPrepare,
    RemoteControllerStatusReady,
    RemoteControllerStatusLoading,
} RemoteControllerStatus;

static NSString* const kAYRemoteCallResultKey = @"RemoteResult:";
static NSString* const kAYRemoteCallResultArgsKey = @"RemoteArgs:";

static NSString* const kAYRemoteCallStartFuncName = @"startRemoteCall:";
static NSString* const kAYRemoteCallEndFuncName = @"endRemoteCall:";
#endif /* AYRemoteCallDefines_h */
