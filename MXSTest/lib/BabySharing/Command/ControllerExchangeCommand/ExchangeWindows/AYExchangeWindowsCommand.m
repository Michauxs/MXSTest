//
//  AYExchangeWindowsCommand.m
//  BabySharing
//
//  Created by BM on 8/18/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYExchangeWindowsCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"
#import "AppDelegate.h"
#import <UIKit/UIKit.h>

@implementation AYExchangeWindowsCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"exchange window command perfrom");

    NSDictionary* dic = (NSDictionary*)*obj;
    
    if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionExchangeWindowsModuleValue]) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"exchange windows 只能出来push 操作" userInfo:nil];
    }
	
    AYViewController* des = [dic objectForKey:kAYControllerActionDestinationControllerKey];
	
    id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
    if (tmp != nil) {
        NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
        [dic_init setValue:kAYControllerActionInitValue forKey:kAYControllerActionKey];
        [dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
        [des performWithResult:&dic_init];
    }
    
//    des.hidesBottomBarWhenPushed = YES;
//    [source.navigationController pushViewController:des animated:YES];
//    UIWindow *source_window = [UIApplication sharedApplication].keyWindow;
	
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[UIApplication sharedApplication].delegate.window = [[UIWindow alloc] initWithFrame:screenBounds];
		UIWindow *des_window = [UIApplication sharedApplication].delegate.window;
		[des_window makeKeyAndVisible];
		des_window.rootViewController = des;
	});
    
//    [UIView transitionFromView:source.view toView:des.view duration:0.75f options:UIViewAnimationOptionTransitionCrossDissolve completion:^(BOOL finished) {
//        
//    }];
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end

