//
//  AYMapMatchDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 21/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMapMatchDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYMapMatchCellView.h"
#import <CoreLocation/CoreLocation.h>

@implementation AYMapMatchDelegate {
	NSArray *servicesData;
	CLLocation *loc;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (id)changeQueryData:(id)args {
	servicesData = [args objectForKey:@"result_data"];
	loc  = [args objectForKey:@"location"];
	return nil;
}

#pragma mark -- collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return servicesData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"MapMatchCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	AYMapMatchCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:class_name forIndexPath:indexPath];
	
	if (servicesData) {
		
		NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
		[tmp setValue:[servicesData objectAtIndex:indexPath.row] forKey:kAYServiceArgsInfo];
		[tmp setValue:loc forKey:@"location_self"];
		cell.service_info = [tmp copy];
		cell.didTouchUpInSubCell = ^(NSDictionary *service_info) {
			
		};
	}
	
	return (UICollectionViewCell*)cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat offset_x = scrollView.contentOffset.x;
	int index = offset_x / SCREEN_WIDTH;
	NSNumber *tmp = [NSNumber numberWithInt:index];
	kAYDelegateSendNotify(self, @"sendChangeAnnoMessage:", &tmp)
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	id tmp = [servicesData objectAtIndex:indexPath.row];
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:_controller forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:tmp forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
}

#pragma mark -- actions


@end
