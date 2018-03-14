//
//  AYPopToDestCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 9/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPopToDestCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"

@implementation AYPopToDestCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"push command perfrom");
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopToDestValue]) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"push command 只能出来push 操作" userInfo:nil];
    }
    
    AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
    AYViewController* desClass = [dic objectForKey:kAYControllerActionDestinationControllerKey];
    
    if (source.navigationController == nil) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"push command source controler 必须是一个navigation controller" userInfo:nil];
    }
    
    AYViewController* des = nil;
    for (AYViewController *iter in source.navigationController.viewControllers) {
        if ([iter isKindOfClass:[desClass class]]) {
            des = iter;
        }
    }
	
	if (!des) {
		[source.navigationController popToRootViewControllerAnimated:YES];
	} else {
		[source.navigationController popToViewController:des animated:YES];
	}
	
    id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
    if (tmp != nil) {
        NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
        [dic_init setValue:kAYControllerActionPopBackValue forKey:kAYControllerActionKey];
        [dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
        [des performWithResult:&dic_init];
    }
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
