//
//  AYShowModuleUpCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYShowModuleUpCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"

@implementation AYShowModuleUpCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"show module up command perfrom");
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionShowModuleUpValue]) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"show module up command 只能出来show module up 操作" userInfo:nil];
    }
    
    AYViewController* src = [dic objectForKey:kAYControllerActionSourceControllerKey];
    AYViewController* dst = [dic objectForKey:kAYControllerActionDestinationControllerKey];
    
    id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
    if (tmp != nil) {
        id tmp_dst = nil;
        if ([dst isKindOfClass:[UINavigationController class]])
            tmp_dst = ((UINavigationController*)dst).topViewController;
        else
            tmp_dst = dst;
        
        NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
        [dic_init setValue:kAYControllerActionInitValue forKey:kAYControllerActionKey];
        [dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
        [tmp_dst performWithResult:&dic_init];
        
    }
    
//    [UIView transitionFromView:src.view toView:dst.view duration:0.8f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        [src presentViewController:dst animated:YES completion:^{
            NSLog(@"show content segue");
        }];
//    }];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
