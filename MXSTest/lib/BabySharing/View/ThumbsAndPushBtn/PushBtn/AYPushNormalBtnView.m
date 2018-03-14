//
//  AYPushBtnView.m
//  BabySharing
//
//  Created by BM on 5/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPushNormalBtnView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYThumbsAndPushDefines.h"
#import "Define.h"

@implementation AYPushNormalBtnView
- (void)postPerform {
    [super postPerform];
    self.btn.image = PNGRESOURCE(@"push");
    self.label.textColor = TextColor;
    self.label.text = @"咚";
}

- (void)selfClicked {
    
    NSDictionary* obj = nil;
    CURRENUSER(obj);
    
    NSMutableDictionary* dic_like = [obj mutableCopy];
    [dic_like setValue:self.post_id forKey:@"post_id"];
    
    id<AYFacadeBase> f_post = DEFAULTFACADE(@"ContentPostRemote"); //[self.facades objectForKey:@"ContentPostRemote"];
    AYRemoteCallCommand* cmd_like = [f_post.commands objectForKey:@"PostPushContent"];
    
    [cmd_like performWithResult:[dic_like copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        if (success) {
            
            {
                id<AYFacadeBase> f_home = HOMECONTENTMODEL;
                id<AYCommand> cmd_refresh_like = [f_home.commands objectForKey:@"RefreshPushData"];
                NSMutableDictionary* dic = [result mutableCopy];
                [dic setValue:self.post_id forKey:@"post_id"];
                [dic setValue:[NSNumber numberWithBool:YES] forKey:@"push_result"];
                [cmd_refresh_like performWithResult:&dic];
            }
            
            {
                id<AYCommand> cmd = [self.notifies objectForKey:@"pushChanged:"];
                NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                [dic setValue:self.post_id forKey:kAYThumbsPushBtnContentIDKey];
                [dic setValue:[NSNumber numberWithInteger:self.cell_index] forKey:kAYThumbsPushBtnContentIndexKey];
                [dic setValue:[NSNumber numberWithBool:YES] forKey:kAYThumbsPushBtnContentResultKey];
                [cmd performWithResult:&dic];
            }
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"通知" message:@"由于某些不可抗力，出现了错误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
        }
    }];
}
@end
