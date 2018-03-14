//
//  AYQueryModelDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYQueryModelDefines_h
#define AYQueryModelDefines_h
typedef enum : NSUInteger {
    PostPreViewPhote,
    PostPreViewMovie,
    PostPreViewText,
} PostPreViewType;

typedef NS_ENUM(NSInteger, ModelAttchmentType) {
    ModelAttchmentTypeImage,
    ModelAttchmentTypeMovie,
};

typedef NS_ENUM(NSInteger, PostCommentsError) {
    PostCommentsErrorNoError,
    PostCommentsErrorPostIDNotExisting,
};

typedef NS_ENUM(NSInteger, PostLikesError) {
    PostLikesErrorNoError,
    PostLikesErrorPostIDNotExisting,
};

typedef NS_ENUM(NSInteger, UserPostOwnerConnections) {
    UserPostOwnerConnectionsNone,
    UserPostOwnerConnectionsSamePerson,
    UserPostOwnerConnectionsFollowing,
    UserPostOwnerConnectionsFollowed,
    UserPostOwnerConnectionsFriends
};

#endif /* AYQueryModelDefines_h */
