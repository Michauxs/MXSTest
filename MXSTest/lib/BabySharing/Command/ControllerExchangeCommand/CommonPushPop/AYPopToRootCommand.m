//
//  AYPopToRootCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPopToRootCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"

@implementation AYPopToRootCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"pop to root command perfrom");
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopToRootValue]) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"pop to root command 只能出来pop 操作" userInfo:nil];
    }
    
    AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
    
    if (source.navigationController == nil) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"pop command source controler 必须是一个navigation controller" userInfo:nil];
    }
    
    AYViewController* des = source.navigationController.viewControllers.firstObject;
    
    [source.navigationController popToRootViewControllerAnimated:YES];
    
    id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
    if (tmp != nil) {
        NSMutableDictionary* dic_back =[[NSMutableDictionary alloc]init];
        [dic_back setValue:kAYControllerActionPopBackValue forKey:kAYControllerActionKey];
        [dic_back setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
        [des performWithResult:&dic_back];
    }
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
