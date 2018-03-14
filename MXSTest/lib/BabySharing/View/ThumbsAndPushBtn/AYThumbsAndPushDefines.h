//
//  AYThumbsAndPushDefines.h
//  BabySharing
//
//  Created by BM on 5/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYThumbsAndPushDefines_h
#define AYThumbsAndPushDefines_h

static NSString* const kAYThumbsPushBtnContentIDKey             = @"kAYThumbsPushBtnContentIDKey";
static NSString* const kAYThumbsPushBtnContentIndexKey          = @"kAYThumbsPushBtnContentIndexKey";
static NSString* const kAYThumbsPushBtnContentResultKey         = @"kAYThumbsPushBtnContentResultKey";

typedef NS_ENUM(NSUInteger, kAYThumbsPushBtnType) {
    kAYThumbsPushBtnTypeThumbsNormal,
    kAYThumbsPushBtnTypeThumbsUp,
    kAYThumbsPushBtnTypePushNormal,
    kAYThumbsPushBtnTypePushUp,
};

#endif /* AYThumbsAndPushDefines_h */
