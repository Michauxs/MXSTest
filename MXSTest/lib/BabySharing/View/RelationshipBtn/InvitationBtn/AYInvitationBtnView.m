//
//  AYInvitationBtnView.m
//  BabySharing
//
//  Created by BM on 4/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYInvitationBtnView.h"
#import "AYResourceManager.h"
#import "AYCommandDefines.h"

@implementation AYInvitationBtnView
- (void)postPerform {
    [super postPerform];
    [self setBackgroundImage:PNGRESOURCE(@"friend_invitation") forState:UIControlStateNormal];
    self.userInteractionEnabled = NO;
}

- (void)selfClicked {
//    UIAlertView* view = [[UIAlertView alloc]initWithTitle:@"短信邀请" message:@"免费发送短信给联系人？" delegate:nil cancelButtonTitle:@"放弃" otherButtonTitles:@"邀请", nil];
//    [view show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"invitation");
//    id<AYCommand> cmd = [self.commands objectForKey:@"sendMessageToTel:"];
//    [cmd performWithResult:nil];
}
@end
