//
//  AYPopFromBotCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 19/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPopFromBotCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"
#import "UINavigationController+WXSTransition.h"

@implementation AYPopFromBotCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"pop command perfrom");
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if (![[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopValue]) {
        @throw [[NSException alloc]initWithName:@"error" reason:@"pop command 只能出来pop 操作" userInfo:nil];
    }
    
    AYViewController* source = [dic objectForKey:kAYControllerActionSourceControllerKey];
//	AYViewController* des = [dic objectForKey:kAYControllerActionDestinationControllerKey];
	
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
	
//	[source.navigationController popViewControllerAnimated:NO];
//	AYViewController* des = source.navigationController.viewControllers.lastObject;
//	
//	UIImage* img = [Tools SourceImageWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) fromView:des.view];
//	UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//	coverImageView.image = img;
//	[des.view addSubview:coverImageView];
//	
//	[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//		coverImageView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
//		
//	} completion:^(BOOL finished) {
//		[coverImageView removeFromSuperview];
//		
//		id tmp = [dic objectForKey:kAYControllerChangeArgsKey];
//		if (tmp != nil) {
//			NSMutableDictionary* dic_init =[[NSMutableDictionary alloc]init];
//			[dic_init setValue:kAYControllerActionPopBackValue forKey:kAYControllerActionKey];
//			[dic_init setValue:[dic objectForKey:kAYControllerChangeArgsKey] forKey:kAYControllerChangeArgsKey];
//			[des performWithResult:&dic_init];
//		}
//	}];
	
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
