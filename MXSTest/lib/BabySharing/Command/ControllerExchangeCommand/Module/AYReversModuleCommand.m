//
//  AYReversModuleCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/18/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYReversModuleCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"

@implementation AYReversModuleCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"revers module command perfrom");
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionReversModuleValue]) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"revers module command 只能出来这个 操作" userInfo:nil];
    }
    
    AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
    
//    [source.navigationController popToRootViewControllerAnimated:YES];
    [source dismissViewControllerAnimated:YES completion:^{
        id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
        if (tmp != nil) {
//            AYViewController* des = (AYViewController*)([Tools activityViewController].tabBarController);
			AYViewController* des = (AYViewController*)[Tools activityViewController];
            NSMutableDictionary* dic_back =[[NSMutableDictionary alloc]init];
            [dic_back setValue:kAYControllerActionPopBackValue forKey:kAYControllerActionKey];
            [dic_back setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
            [des performWithResult:&dic_back];
        }       
    }];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
