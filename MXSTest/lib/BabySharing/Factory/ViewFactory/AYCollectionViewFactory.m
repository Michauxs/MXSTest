//
//  AYCollectionViewFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 21/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCollectionViewFactory.h"
//#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYViewBase.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYCollectionView.h"
#import "UICollectionViewLeftAlignedLayout.h"

@implementation AYCollectionViewFactory

@synthesize para = _para;

+ (id)factoryInstance {
	return [[self alloc]init];
}

- (id)createInstance {
	NSLog(@"para is : %@", _para);
	
	NSString* desFacade = [self.para objectForKey:@"view"];
	id<AYViewBase> result = nil;
	
	Class c = NSClassFromString([[kAYFactoryManagerControllerPrefix stringByAppendingString:desFacade] stringByAppendingString:kAYFactoryManagerViewsuffix]);
	if (c == nil) {
		@throw [NSException exceptionWithName:@"error" reason:@"perform  init command error" userInfo:nil];
	} else {
		
		NSArray* args = [_para objectForKey:@"args"];
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//		UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
		layout.scrollDirection = ((NSString*)[args objectAtIndex:0]).integerValue;
		layout.minimumInteritemSpacing =  ((NSString*)[args objectAtIndex:1]).integerValue;
		layout.minimumLineSpacing =  ((NSString*)[args objectAtIndex:2]).integerValue;
		
		AYCollectionView *collectionView = [[AYCollectionView alloc]initWithFrame:CGRectMake(0, 0, 0,0) collectionViewLayout:layout];
		result = (id<AYViewBase>)collectionView;
//		result = [[c alloc]init];
		[result postPerform];
	}
	
	NSDictionary* cmds = [_para objectForKey:@"commands"];
	NSMutableDictionary* commands = [[NSMutableDictionary alloc]initWithCapacity:cmds.count];
	for (NSString* cmd in cmds) {
		AYViewCommand* c = [[AYViewCommand alloc]init];
		c.view = result;
		c.method_name = cmd;
		c.need_args = [cmd containsString:@":"];
		[commands setObject:c forKey:cmd];
	}
	
	NSDictionary* notifies = [_para objectForKey:@"notifies"];
	NSMutableDictionary* ntf = [[NSMutableDictionary alloc]initWithCapacity:notifies.count];
	for (NSString* notify in notifies) {
		AYViewNotifyCommand* n = [[AYViewNotifyCommand alloc]init];
		n.view = result;
		n.method_name = notify;
		n.need_args = [notify containsString:@":"];
		[ntf setObject:n forKey:notify];
	}
	
	result.commands = [commands copy];
	result.notifies = [ntf copy];
	return result;
}
@end
