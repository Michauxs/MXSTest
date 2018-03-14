//
//  AYQueryScreenNameAndPhotoCommand.m
//  BabySharing
//
//  Created by BM on 4/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryScreenNameAndPhotoCommand.h"
#import "AYScreenNameAndPhotoCacheFacade.h"
#import "AYFactoryManager.h"
#import "TmpFileStorageModel.h"

@implementation AYQueryScreenNameAndPhotoCommand

- (void)beforeAsyncCall {
    
}

- (void)endAsyncCall {
    
}

- (void)performWithResult:(NSDictionary *)args andFinishBlack:(asynCommandFinishBlock)block {
  
    NSString* user_id = [args objectForKey:@"user_id"];
    
    AYScreenNameAndPhotoCacheFacade* f = USERCACHE;
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.user_id=%@", user_id];
    
    NSArray* arr = [f.head_lst filteredArrayUsingPredicate:p];
    if (arr.count > 1) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"cache error with primary key" userInfo:nil];
    } else if (arr.count == 1) {
        block(YES, arr.lastObject);
    } else {
		
		NSMutableDictionary* dic = [Tools getBaseRemoteData];
		[[dic objectForKey:kAYCommArgsCondition] setValue:user_id  forKey:kAYCommArgsUserID];
		
		id<AYFacadeBase> f_profile = DEFAULTFACADE(@"ProfileRemote");
		AYRemoteCallCommand* cmd = [f_profile.commands objectForKey:@"QueryUserProfile"];
        [cmd performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            if (success) {
				NSDictionary *info_prifole = [result objectForKey:kAYProfileArgsSelf];
                NSMutableDictionary* reVal = [[NSMutableDictionary alloc]init];
                [reVal setValue:user_id forKey:@"user_id"];
                [reVal setValue:[info_prifole objectForKey:@"screen_name"] forKey:@"screen_name"];
                [reVal setValue:[info_prifole objectForKey:@"screen_photo"] forKey:@"screen_photo"];
                
                id<AYCommand> cmd_push = [f.commands objectForKey:@"PushScreenNameAndPhoto"];
                id arg_push = [reVal copy];
                [cmd_push performWithResult:&arg_push];
                
                block(YES, [reVal copy]);
            } else {
                block(NO, nil);
            }
        }];
    }
}
@end
