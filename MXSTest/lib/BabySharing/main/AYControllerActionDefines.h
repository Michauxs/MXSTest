//
//  AYControllerAcitionDefines.h
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYControllerAcitionDefines_h
#define AYControllerAcitionDefines_h

static NSString* const kAYControllerActionKey = @"action name";

static NSString* const kAYControllerActionInitValue = @"controller init";
static NSString* const kAYControllerActionPopBackValue = @"controller pop back";
static NSString* const kAYControllerActionPushValue = @"controller push";
static NSString* const kAYControllerActionPopValue = @"controller pop";
static NSString* const kAYControllerActionPushSplitValue = @"controller push split";
static NSString* const kAYControllerActionPopSplitValue = @"controller pop split";
static NSString* const kAYControllerActionPopToDestValue = @"controller pop to dest";
static NSString* const kAYControllerActionPopToRootValue = @"controller pop to root";
static NSString* const kAYControllerActionShowModuleValue = @"controller show model";
static NSString* const kAYControllerActionShowModuleUpValue = @"controller show model up";
static NSString* const kAYControllerActionReversModuleValue = @"controller revers model up";
static NSString* const kAYControllerActionExchangeWindowsModuleValue = @"controller exchange windows";

static NSString* const kAYControllerActionModelTypeKey = @"what kind of model";

static NSString* const kAYControllerActionDestinationControllerKey = @"destination controller";
static NSString* const kAYControllerActionSourceControllerKey = @"srouce controller";

static NSString* const kAYControllerIndentifierKey = @"controller identifier";      // 类型由source controller自行确定

static NSString* const kAYControllerChangeArgsKey = @"controller exchange args";

static NSString* const kAYControllerSplitValueKey  = @"controller split Value key";
static NSString* const kAYControllerSplitHeightKey = @"controller split height key";
static NSString* const kAYControllerSplitTopImgKey = @"controller split top img";
static NSString* const kAYControllerSplitBtmImgKey = @"controller split btm img";


static NSString* const kAYControllerImgForFrameKey = @"img_for_frame";

#endif /* AYControllerAcitionDefines_h */
