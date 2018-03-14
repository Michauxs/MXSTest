//
//  AYHomeTopicsCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYHomeTopicsCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYViewController.h"

@implementation AYHomeTopicsCellView  {
	UILabel *titleLabel;
	UILabel *subTitleLabel;
	
	UICollectionView *collectionView;
	
	NSArray *EngArr;
	NSArray *topicsArr;
	NSArray *subTopicsArr;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
}

- (void)performWithResult:(NSObject**)obj {
	
}

- (NSString*)getViewType {
	return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
	return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCatigoryView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		EngArr = @[@"Montessori", @"Native Speaker", @"Extreme Sports", @"Art", @"Science Technology"];
		topicsArr = kAY_home_album_titles;
		subTopicsArr = kAY_home_album_titles_sub;
		
		titleLabel = [UILabel creatLabelWithText:@"精选主题" textColor:[Tools black] fontSize:628 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.top.equalTo(self).offset(15);
		}];
		
		subTitleLabel = [UILabel creatLabelWithText:@"一句话简单描述" textColor:[UIColor gary] fontSize:13 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:subTitleLabel];
		[subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(2);
		}];
		subTitleLabel.hidden = YES;
		
		UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
		flowLayout.itemSize  = CGSizeMake(235, 310);
		flowLayout.scrollDirection  = UICollectionViewScrollDirectionHorizontal;
		flowLayout.minimumInteritemSpacing = 0;
		flowLayout.minimumLineSpacing = 16;
		
		collectionView = [[UICollectionView  alloc] initWithFrame:CGRectMake(0, 15+45, SCREEN_WIDTH, 330) collectionViewLayout:flowLayout];
		collectionView.delegate = self;
		collectionView.dataSource = self;
		collectionView.showsVerticalScrollIndicator = NO;
		collectionView.showsHorizontalScrollIndicator = NO;
		collectionView.contentInset = UIEdgeInsetsMake(5, SCREEN_MARGIN_LR, 15, SCREEN_MARGIN_LR);
		[collectionView setBackgroundColor:[UIColor clearColor]];
		[collectionView registerClass:NSClassFromString(@"AYHomeTopicItem") forCellWithReuseIdentifier:@"AYHomeTopicItem"];
		[self addSubview:collectionView];
		
	}
	return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return topicsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYHomeTopicItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYHomeTopicItem" forIndexPath:indexPath];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[EngArr objectAtIndex:indexPath.row] forKey:@"eng"];
	[tmp setValue:[topicsArr objectAtIndex:indexPath.row] forKey:@"title"];
	[tmp setValue:[subTopicsArr objectAtIndex:indexPath.row] forKey:@"title_sub"];
	[tmp setValue:[NSString stringWithFormat:@"home_album_%d", (int)indexPath.row] forKey:@"img"];
	//	[tmp setValue:[NSNumber numberWithInteger:100] forKey:@"count_skiped"];
//	[tmp setValue:[NSString stringWithFormat:@"topsort_home_%ld", indexPath.row] forKey:@"assortment_img"];
	[cell setItemInfo:[tmp copy]];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	NSString *sort = [topicsArr objectAtIndex:indexPath.row];
	[(AYViewController*)self.controller performAYSel:@"didOneTopicClick:" withResult:&sort];
}

#pragma mark -- actions
- (void)didTopicsMoreBtnClick {
	kAYViewSendNotify(self, @"didTopicsMoreBtnClick", nil)
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	[collectionView setContentOffset:CGPointMake(-SCREEN_MARGIN_LR, -5)];
	return nil;
}

@end
