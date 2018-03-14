//
//  AYPushFromBotCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 19/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPushFromBotCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"
#import "UINavigationController+WXSTransition.h"

@implementation AYPushFromBotCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"push command perfrom");
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"push command 只能出来push 操作" userInfo:nil];
    }
    
    AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
    AYViewController* des = [dic objectForKey:kAYControllerActionDestinationControllerKey];
	
    if (source.navigationController == nil) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"push command source controler 必须是一个navigation controller" userInfo:nil];
    }
	
    id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
    if (tmp != nil) {
        NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
        [dic_init setValue:kAYControllerActionInitValue forKey:kAYControllerActionKey];
        [dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
        [des performWithResult:&dic_init];
    }
    
    des.hidesBottomBarWhenPushed = YES;
    [source.navigationController wxs_pushViewController:des animationType:WXSTransitionAnimationTypeSpreadFromBottom];
	
//	UIImage* img = [Tools SourceImageWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) fromView:des.view];
//	UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
//	coverImageView.image = img;
//	[source.view addSubview:coverImageView];
//	
//	des.hidesBottomBarWhenPushed = YES;
//	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//		coverImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//		
//	} completion:^(BOOL finished) {
//		[coverImageView removeFromSuperview];
//		
//		[source.navigationController pushViewController:des animated:NO];
//		id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
//		if (tmp != nil) {
//			NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
//			[dic_init setValue:kAYControllerActionInitValue forKey:kAYControllerActionKey];
//			[dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
//			[des performWithResult:&dic_init];
//		}
//	}];
	
	
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
