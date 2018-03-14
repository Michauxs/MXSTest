//
//  AYHomeAssortmentCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 20/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYNurseryCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "AYHomeAssortmentItem.h"

@implementation AYNurseryCellView {
	UILabel *titleLabel;
	UILabel *subTitleLabel;
	
	UICollectionView *CollectionView;
	NSArray *serviceData;
	
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

#pragma mark -- life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		titleLabel = [Tools creatLabelWithText:@"分类" textColor:[UIColor black] fontSize:622 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.top.equalTo(self).offset(0);
		}];
		
		subTitleLabel = [UILabel creatLabelWithText:@"一句话简单描述" textColor:[UIColor gary115] fontSize:313 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:subTitleLabel];
		[subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(titleLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(5);
		}];
//		subTitleLabel.hidden = YES;
		
		UIButton *moreBtn = [Tools creatBtnWithTitle:@"查看更多" titleColor:[UIColor theme] fontSize:615 backgroundColor:nil];
		[self addSubview:moreBtn];
		[moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self).offset(-8);
			make.bottom.equalTo(subTitleLabel).offset(6);
			make.size.mas_equalTo(CGSizeMake(80, 30));
		}];
		[moreBtn addTarget:self action:@selector(didAssortmentMoreBtnClick) forControlEvents:UIControlEventTouchUpInside];
		
		UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
		flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		flowLayout.minimumInteritemSpacing = 8;
		flowLayout.minimumLineSpacing = 8;
		
		CollectionView = [[UICollectionView  alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
		CollectionView.delegate = self;
		CollectionView.dataSource = self;
		CollectionView.showsVerticalScrollIndicator = NO;
		CollectionView.showsHorizontalScrollIndicator = NO;
		CollectionView.contentInset = UIEdgeInsetsMake(0, SCREEN_MARGIN_LR, 0, SCREEN_MARGIN_LR);
		[CollectionView setBackgroundColor:[UIColor clearColor]];
		[CollectionView registerClass:NSClassFromString(@"AYNurseryItem") forCellWithReuseIdentifier:@"AYNurseryItem"];
		[CollectionView registerClass:NSClassFromString(@"AYNurseryMoreItem") forCellWithReuseIdentifier:@"AYNurseryMoreItem"];
		[self addSubview:CollectionView];
		[CollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(subTitleLabel.mas_bottom).offset(20);
			make.left.equalTo(self);
			make.right.equalTo(self);
			make.bottom.equalTo(self);
		}];
		
	}
	return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return serviceData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	AYHomeAssortmentItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYNurseryItem" forIndexPath:indexPath];
	NSMutableDictionary *tmp = [[serviceData objectAtIndex:indexPath.row] copy];
	cell.itemInfo = [tmp copy];
	cell.likeBtnClick = ^(NSDictionary *service_info) {
		id ser = [service_info copy];
		[(AYViewController*)self.controller performAYSel:@"willCollectWithRow:" withResult:&ser];
	};
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
	[dic setValue:[serviceData objectAtIndex:indexPath.row] forKey:kAYServiceArgsSelf];
	id tmp = [dic copy];
	[(AYViewController*)self.controller performAYSel:@"didSelectAssortmentAtIndex:" withResult:&tmp];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height = HOME_NURSERY_CELL_HEIGHT - 45;
	return CGSizeMake(319, height);
}

#pragma mark -- actions
- (void)didAssortmentMoreBtnClick {
	NSString *title = titleLabel.text;
	[(AYViewController*)self.controller performAYSel:@"didAssortmentMoreBtnClick:" withResult:&title];
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	
	[CollectionView setContentOffset:CGPointMake(-SCREEN_MARGIN_LR, 0)];
	
	NSString *cat = [[args objectForKey:@"service"] objectForKey:@"service_type"];
	titleLabel.text = cat;
	
	NSString *subStr = [kAY_home_assortment_subtitle objectForKey:cat];
	subTitleLabel.text = subStr;
	
	serviceData = [[args objectForKey:@"service"] objectForKey:@"services"];
	[CollectionView reloadData];
	
	return nil;
}

@end
