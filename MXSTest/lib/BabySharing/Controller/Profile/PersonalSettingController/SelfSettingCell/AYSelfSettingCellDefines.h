//
//  AYSelfSettingCellDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 4/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYSelfSettingCellDefines_h
#define AYSelfSettingCellDefines_h

typedef enum : NSUInteger {
    AYSelfSettingUserInfoStatusUnchange,
    AYSelfSettingUserInfoStatusChanged,
} AYSelfSettingUserInfoStatus;

static NSString* const kAYSelfSettingCellName           = @"SelfSettingCell";

static NSString* const kAYSelfSettingCellCellKey        = @"kAYSelfSettingCellCellKey";
static NSString* const kAYSelfSettingCellTypeKey        = @"kAYSelfSettingCellTypeKey";
static NSString* const kAYSelfSettingCellContentKey     = @"kAYSelfSettingCellContentKey";
static NSString* const kAYSelfSettingCellTitleKey       = @"kAYSelfSettingCellTitleKey";
static NSString* const kAYSelfSettingCellScreenPhotoKey = @"kAYSelfSettingCellScreenPhotoKey";
static NSString* const kAYSelfSettingCellScreenNameKey  = @"kAYSelfSettingCellScreenNameKey";
static NSString* const kAYSelfSettingCellRoleTagKey     = @"kAYSelfSettingCellRoleTagKey";
#endif /* AYSelfSettingCellDefines_h */
