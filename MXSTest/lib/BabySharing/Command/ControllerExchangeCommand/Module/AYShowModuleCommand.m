//
//  AYShowModuleCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYShowModuleCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"

@implementation AYShowModuleCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"show module command perfrom");
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionShowModuleValue]) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"show module command 只能出来push 操作" userInfo:nil];
    }
    
    AYViewController* src = [dic objectForKey:kAYControllerActionSourceControllerKey];
    AYViewController* dst = [dic objectForKey:kAYControllerActionDestinationControllerKey];
    
    id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
    if (tmp != nil) {
        NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
        [dic_init setValue:kAYControllerActionInitValue forKey:kAYControllerActionKey];
        [dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
        [dst performWithResult:&dic_init];
    }
    
    [UIView transitionFromView:src.view toView:dst.view duration:0.8f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
        [src presentViewController:dst animated:NO completion:^{
            NSLog(@"show content segue");
        }];
    }];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
