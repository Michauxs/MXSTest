//
//  AYNewVersionNavDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 17/2/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNewVersionNavDelegate.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"
#import "AYVersionNavCellView.h"

@implementation AYNewVersionNavDelegate {
	NSArray *query_data;
	
	NSArray *titleArr;
	NSArray *detailArr;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
	titleArr = @[@"发现服务", @"轻松预订", @"成为服务者"];
	detailArr = @[@"每次尝试，\n都是孩子对未来的触摸", @"随时随地，\n了解孩子的每一步成长", @"分享创造，\n发掘孩子的无限可能"];
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
	query_data = (NSArray*)args;
	return nil;
}

#pragma mark -- collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"VersionNavCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	AYVersionNavCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:class_name forIndexPath:indexPath];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	[tmp setValue:[NSString stringWithFormat:@"version_nav_cover_%d",(int)indexPath.row] forKey:@"cover"];
	[tmp setValue:[titleArr objectAtIndex:indexPath.row] forKey:@"title"];
	[tmp setValue:[detailArr objectAtIndex:indexPath.row] forKey:@"detail"];
	cell.itemInfoDic = [tmp copy];
	
	return (UICollectionViewCell*)cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	CGFloat offset_x = scrollView.contentOffset.x;
	NSNumber *tmp = [NSNumber numberWithFloat:offset_x];
	kAYDelegateSendNotify(self, @"scrollOffsetX:", &tmp)
}

#pragma mark -- actions


@end
