//
//  AYHomePushCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 6/6/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomePushCommand.h"
#import "AYCommandDefines.h"
#import "AYControllerActionDefines.h"
#import "AYViewController.h"
#import "UINavigationController+WXSTransition.h"

@implementation AYHomePushCommand
@synthesize para = _para;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	NSLog(@"pop command perfrom");
	
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
	[source.navigationController pushViewController:des animated:NO];
	
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}
@end
