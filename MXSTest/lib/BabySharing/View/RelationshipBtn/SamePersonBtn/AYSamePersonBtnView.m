//
//  AYSamePersonBtnView.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSamePersonBtnView.h"
#import "AYResourceManager.h"
#import "AYCommandDefines.h"
#import "AYViewController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYDongDaSegDefines.h"
#import "AYAlbumDefines.h"
#import "AYRemoteCallDefines.h"

@implementation AYSamePersonBtnView
- (void)postPerform {
    [super postPerform];
    [self setBackgroundImage:PNGRESOURCE(@"friend_relation_myself") forState:UIControlStateNormal];
}

- (void)selfClicked {

    id<AYCommand> cmd = [self.notifies objectForKey:@"SamePersonBtnSelected"];
    [cmd performWithResult:nil];
    
}
@end
