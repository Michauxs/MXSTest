//
//  AYFollowedBtnView.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFollowedBtnView.h"
#import "AYResourceManager.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYRemoteCallCommand.h"

@implementation AYFollowedBtnView
- (void)postPerform {
    [super postPerform];
    [self setBackgroundImage:PNGRESOURCE(@"friend_relation_follow") forState:UIControlStateNormal];
}

- (void)selfClicked {
    
    id<AYCommand> cmd_query = [self.notifies objectForKey:@"queryTargetID"];
    id follow_user_id = nil;
    [cmd_query performWithResult:&follow_user_id];
    
    id<AYFacadeBase> f = DEFAULTFACADE(@"RelationshipRemote");
    AYRemoteCallCommand* cmd = [f.commands objectForKey:@"Follow"];
    NSDictionary* user = nil;
    CURRENUSER(user)
    
    NSMutableDictionary* dic = [user mutableCopy];
    [dic setValue:[user objectForKey:@"user_id"] forKey:@"owner_id"];
    [dic setValue:follow_user_id forKey:@"follow_user_id"];
   
    [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            id<AYCommand> cmd_notify = [self.notifies objectForKey:@"relationChanged:"];
            id reVal = [result objectForKey:@"relations"];
            [cmd_notify performWithResult:&reVal];
        } else {
            [[[UIAlertView alloc]initWithTitle:@"关注失败" message:@"请检查网络连接是否正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
        }
    }];
}
@end
