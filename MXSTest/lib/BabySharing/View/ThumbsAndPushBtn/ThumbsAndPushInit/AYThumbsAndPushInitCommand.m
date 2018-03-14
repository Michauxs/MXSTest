//
//  AYThumbsAndPushInitCommand.m
//  BabySharing
//
//  Created by BM on 5/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYThumbsAndPushInitCommand.h"
#import "AYCommandDefines.h"
#import "AYThumbsAndPushDefines.h"
#import "AYViewBase.h"
#import "AYFactoryManager.h"

@implementation AYThumbsAndPushInitCommand
@synthesize para = _para;

- (void)postPerform {

}

- (void)performWithResult:(NSObject**)obj {
   
    NSNumber* t = (NSNumber*)*obj;
   
    id<AYViewBase> result = nil;
    switch (t.integerValue) {
        case kAYThumbsPushBtnTypeThumbsNormal:
            result = VIEW(@"ThumbsNormalBtn", @"ThumbsNormalBtn");
            break;
        case kAYThumbsPushBtnTypeThumbsUp:
            result = VIEW(@"ThumbsUpBtn", @"ThumbsUpBtn");
            break;
        case kAYThumbsPushBtnTypePushNormal:
            result = VIEW(@"PushNormalBtn", @"PushNormalBtn");
            break;
        case kAYThumbsPushBtnTypePushUp:
            result = VIEW(@"PushUpBtn", @"PushUpBtn");
            break;
        default:
            @throw [[NSException alloc]initWithName:@"error" reason:@"thumbs push btn type error" userInfo:nil];
            break;
    }
    
    *obj = result;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
