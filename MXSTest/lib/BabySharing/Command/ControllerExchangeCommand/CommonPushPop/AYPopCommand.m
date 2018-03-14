//
//  AYPopCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPopCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"

@implementation AYPopCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"pop command perfrom");
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
    
    if (source.navigationController == nil) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"pop command source controler 必须是一个navigation controller" userInfo:nil];
    }
    
    [source.navigationController popViewControllerAnimated:YES];
    
    AYViewController* des = source.navigationController.viewControllers.lastObject;
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
