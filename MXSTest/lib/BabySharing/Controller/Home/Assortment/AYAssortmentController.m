//
//  AYAssortmentListController.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYAssortmentController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYThumbsAndPushDefines.h"
#import "AYModelFacade.h"

#define kCOLLECTIONVIEWTOP			(kStatusAndNavBarH + 141)

@implementation AYAssortmentController {
//	UIStatusBarStyle statusStyle;
	
	UILabel *navTitleLabel;
	UICollectionView *servCollectionView;
	
	NSString *sortCateg;
	NSInteger skipedCount;
	NSMutableArray *remoteDataArr;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return remoteDataArr.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYHomeAssortmentItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYHomeAssortmentItem" forIndexPath:indexPath];
	id tmp = [remoteDataArr objectAtIndex:indexPath.row];
	[item setItemInfo:tmp];
	item.likeBtnClick = ^(NSDictionary *service_info) {
		[self willCollectWithRow:service_info];
	};
	return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
//	AYHomeAssortmentItem *item = (AYHomeAssortmentItem*)[collectionView cellForItemAtIndexPath:indexPath];
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	
//	[dic setObject:item.coverImage forKey:kAYControllerImgForFrameKey];
	[dic setValue:[remoteDataArr objectAtIndex:indexPath.row] forKey:kAYControllerChangeArgsKey];
	
//	id<AYCommand> cmd_push_animate = PUSHANIMATE;
//	[cmd_push_animate performWithResult:&dic];
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic];
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		sortCateg = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSDictionary *backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
		NSString *key = [backArgs objectForKey:kAYVCBackArgsKey];
		
		if ([key isEqualToString:kAYVCBackArgsKeyCollectChange]) {
			id service_info = [backArgs objectForKey:kAYServiceArgsInfo];
			NSString *service_id = [service_info objectForKey:kAYServiceArgsID];
			
			NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
			NSArray *result = [remoteDataArr filteredArrayUsingPredicate:pre_id];
			if (result.count == 1) {
				[result.firstObject setValue:[backArgs objectForKey:kAYServiceArgsIsCollect] forKey:kAYServiceArgsIsCollect];
				NSInteger index = [remoteDataArr indexOfObject:result.firstObject];
				
//				[servCollectionView reloadRowsAtIndexPaths: withRowAnimation:UITableViewRowAnimationNone];
				[servCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
				
			}
		}
	}
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	skipedCount = 0;
	
//	navTitleLabel = [UILabel creatLabelWithText:@"" textColor:[UIColor black] fontSize:616 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
//	[self.view addSubview:navTitleLabel];
//	[navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.left.equalTo(self.view).offset(15);
//		make.top.equalTo(self.view).offset(kStatusAndNavBarH);
//	}];
	
	UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
	layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	layout.itemSize = CGSizeMake((SCREEN_WIDTH - SCREEN_MARGIN_LR*2-15)*0.5, 250);
	layout.minimumInteritemSpacing = 8.f;
	layout.minimumLineSpacing = 8.f;
	
	servCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(SCREEN_MARGIN_LR, kStatusAndNavBarH, SCREEN_WIDTH-SCREEN_MARGIN_LR*2, SCREEN_HEIGHT-kStatusAndNavBarH) collectionViewLayout:layout];
	servCollectionView.delegate = self;
	servCollectionView.dataSource = self;
	servCollectionView.backgroundColor = [UIColor clearColor];
	servCollectionView.showsVerticalScrollIndicator = NO;
	
	servCollectionView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
	[self.view addSubview:servCollectionView];
	[servCollectionView registerClass:NSClassFromString(@"AYHomeAssortmentItem") forCellWithReuseIdentifier:@"AYHomeAssortmentItem"];
	
	servCollectionView.mj_header = [MXSRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	servCollectionView.mj_footer = [MXSRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//	servCollectionView.mj_footer = [MXSRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	[self loadNewData];
}

#pragma mark -- actions
- (void)loadNewData {
	NSDictionary *user;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData:user];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:sortCateg forKey:kAYServiceArgsServiceTypeInfo];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
//	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithLongLong:([NSDate date].timeIntervalSince1970 * 1000)] forKey:kAYCommArgsRemoteDate];
	
	id<AYFacadeBase> f_choice = [self.facades objectForKey:@"ChoiceRemote"];
	AYRemoteCallCommand *cmd_search = [f_choice.commands objectForKey:@"ChoiceSearch"];
	[[AYRemoteCallManager shared] performWithRemoteCmd:cmd_search andArgs:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//	[cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSArray* tmp = [result objectForKey:@"services"];
			remoteDataArr = [tmp mutableCopy];
			skipedCount = remoteDataArr.count;
			[servCollectionView reloadData];
			
			if (servCollectionView.mj_footer.state == MJRefreshStateNoMoreData) {
				servCollectionView.mj_footer.state = MJRefreshStateResetIdle;
			}
			
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		[servCollectionView.mj_header endRefreshing];
	}];
}

- (void)loadMoreData {
	
	NSDictionary *user;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData:user];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:sortCateg forKey:kAYServiceArgsServiceTypeInfo];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithLong:([NSDate date].timeIntervalSince1970 * 1000)] forKey:kAYCommArgsRemoteDate];
	[dic_search setValue:[NSNumber numberWithInteger:skipedCount] forKey:kAYCommArgsRemoteDataSkip];
	
	id<AYFacadeBase> f_choice = [self.facades objectForKey:@"ChoiceRemote"];
	AYRemoteCallCommand *cmd_search = [f_choice.commands objectForKey:@"ChoiceSearch"];
	[[AYRemoteCallManager shared] performWithRemoteCmd:cmd_search andArgs:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//	[cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSArray *reArr = [result objectForKey:@"services"];
			if (reArr.count != 0) {
				[remoteDataArr addObjectsFromArray:reArr];
				skipedCount = remoteDataArr.count;
				[servCollectionView reloadData];
				
			} else {
				[servCollectionView.mj_footer endRefreshingWithNoMoreData];
				
			}
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		
		[servCollectionView.mj_footer endRefreshing];
	}];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	NSString *title = sortCateg;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
//	navTitleLabel = [Tools creatUILabelWithText:title andTextColor:[Tools blackColor] andFontSize:615.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
//	[view addSubview:navTitleLabel];
//	[navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.bottom.equalTo(view.mas_centerY).offset(0);
//		make.centerX.equalTo(view);
//	}];
//	
//	navCountLabel = [Tools creatUILabelWithText:@"6个服务" andTextColor:[Tools blackColor] andFontSize:311.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
//	[view addSubview:navCountLabel];
//	[navCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.top.equalTo(view.mas_centerY).offset(0);
//		make.centerX.equalTo(view);
//	}];
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
//	is_hidden = [NSNumber numberWithBool:YES];
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	
//	view.layer.shadowColor = [Tools garyColor].CGColor;
//	view.layer.shadowOffset = CGSizeMake(0, 3);
//	view.layer.shadowOpacity = 0.25f;
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH);
	((UITableView*)view).contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
	return nil;
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}
- (id)willCollectWithRow:(id)args {
	
	NSDictionary *service_info = [args objectForKey:kAYServiceArgsInfo];
	UIButton *likeBtn = [args objectForKey:@"btn"];
	
	//	NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
	//	NSArray *resultArr = [serviceDataFound filteredArrayUsingPredicate:pre_id];
	//	if (resultArr.count != 1) {
	//		return nil;
	//	}
	//	id service_data = resultArr.firstObject;
	
	NSDictionary *user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic = [Tools getBaseRemoteData:user];
	
	NSMutableDictionary *dic_collect = [[NSMutableDictionary alloc] init];
	[dic_collect setValue:[service_info objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	[dic_collect setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic setValue:dic_collect forKey:@"collections"];
	
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] initWithDictionary:dic_collect];
	[dic setValue:dic_condt forKey:kAYCommArgsCondition];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
	if (!likeBtn.selected) {
		AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"CollectService"];
		[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				likeBtn.selected = YES;
				//				[resultArr.firstObject setValue:[NSNumber numberWithBool:YES] forKey:kAYServiceArgsIsCollect];
			} else {
				NSString *title = @"收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	} else {
		AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"UnCollectService"];
		[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				likeBtn.selected = NO;
				//				[resultArr.firstObject setValue:[NSNumber numberWithBool:NO] forKey:kAYServiceArgsIsCollect];
			} else {
				NSString *title = @"取消收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	}
	return nil;
}

#pragma scroll delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//	CGFloat offset_y = scrollView.contentOffset.y;
//	
//	UIView *navBar = [self.views objectForKey:@"FakeNavBar"];
//	UIView *statusBar = [self.views objectForKey:@"FakeStatusBar"];
//	
//	if (offset_y < 0 ) {
//		
//		CGFloat alp = fabs(offset_y) / (kCOLLECTIONVIEWTOP - kStatusAndNavBarH);		// UP -> small
//		if (alp > 0.7) {
//			navLeftBtn.selected = YES;
//			statusStyle = UIStatusBarStyleLightContent;
//			[self setNeedsStatusBarAppearanceUpdate];
//		} else if (alp < 0.7) {
//			navLeftBtn.selected = NO;
//			statusStyle = UIStatusBarStyleDefault;
//			[self setNeedsStatusBarAppearanceUpdate];
//		}
//		else if (alp >= 1)
//			alp = 1.f;
//		NSLog(@"alp : %f", alp);
//		
//		navBar.alpha = statusBar.alpha = 1 - alp;
//		bannerView.alpha = alp;
//	}
//}

//- (UIStatusBarStyle)preferredStatusBarStyle {
////	[self setNeedsStatusBarAppearanceUpdate];
//	return statusStyle;
//}

@end
