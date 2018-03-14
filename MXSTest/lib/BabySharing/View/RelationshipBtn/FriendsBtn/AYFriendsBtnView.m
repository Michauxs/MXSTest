//
//  AYFriendsBtnView.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFriendsBtnView.h"
#import "AYResourceManager.h"
#import "AYCommandDefines.h"

@implementation AYFriendsBtnView
- (void)postPerform {
    [super postPerform];
    [self setBackgroundImage:PNGRESOURCE(@"friend_relation_muture_follow") forState:UIControlStateNormal];
}
@end
