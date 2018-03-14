//
//  AYHomeCollectDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 31/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeCollectDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYFilterCansCellView.h"

@implementation AYHomeCollectDelegate {
	NSArray *titleArr;
//	NSArray *nurseryTitleArr;
	
	ServiceType service_type;
	
	NSNumber *didSelected;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
//	courseTitleArr = kAY_service_options_title_course;
//	nurseryTitleArr = kAY_service_options_title_nursery;
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
	
	NSNumber *cat = [args objectForKey:kAYServiceArgsServiceCat];
	service_type = cat.intValue;
	
	NSNumber *sub_index = [args objectForKey:@"sub_index"];
	didSelected = sub_index;
	NSLog(@"%d", sub_index.intValue);
	
	if (service_type == ServiceTypeCourse) {
		titleArr = kAY_service_options_title_course;
	} else {
		titleArr = kAY_service_options_title_nursery;
	}
	return nil;
}

#pragma mark -- collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *class_name = @"AYFilterCansCellView";
	AYFilterCansCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:class_name forIndexPath:indexPath];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[titleArr objectAtIndex:indexPath.row] forKey:@"title"];
	[tmp setValue:[NSNumber numberWithBool:indexPath.row == didSelected.integerValue] forKey:@"is_selected"];
	cell.itemInfo = tmp;
	
	return (UICollectionViewCell*)cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat itemHeight = 90.f;
	if (service_type == ServiceTypeCourse) {
//		NSString *title = [courseTitleArr objectAtIndex:indexPath.row];
		return CGSizeMake(80+20, itemHeight);
	} else {
		return CGSizeMake(106+20, itemHeight);
	}
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
}

@end
