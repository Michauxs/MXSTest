//
//  AYTopicContentController.m
//  BabySharing
//
//  Created by Alfred Yang on 21/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYTopicContentController.h"

#define kCOLLECTIONVIEWTOP			(kStatusBarH + 161)

@interface AYTopicContentController ()

@end

@implementation AYTopicContentController {
	UIStatusBarStyle statusStyle;
	
//	UIView *bannerView;
//	UILabel *bannerTitle;
//	UIButton *navLeftBtn;
	
	UILabel *navTitleLabel;
	UILabel *navCountLabel;
	
	NSString *albumCateg;
	NSInteger skipedCount;
	NSMutableArray *remoteDataArr;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return remoteDataArr.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYAssortmentItemView *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYAssortmentItemView" forIndexPath:indexPath];
	id tmp = [remoteDataArr objectAtIndex:indexPath.row];
	[item setItemInfo:tmp];
	return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic setValue:[remoteDataArr objectAtIndex:indexPath.row] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
}

#pragma mark -- commands
- (void)postPerform {
	[super postPerform];
//	statusStyle = UIStatusBarStyleLightContent;
}

- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		albumCateg = [dic objectForKey:kAYControllerChangeArgsKey];
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
				
				id tmp = @{kAYServiceArgsInfo:[remoteDataArr copy]};
				kAYDelegatesSendMessage(@"TopicContent", kAYDelegateChangeDataMessage, &tmp)
				UITableView *view_table = [self.views objectForKey:kAYTableView];
				[view_table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index+2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
				
			}
		}
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	id<AYDelegateBase> delegate_found = [self.delegates objectForKey:@"TopicContent"];
	id obj = (id)delegate_found;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	obj = (id)delegate_found;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	
	NSArray *arr_cell_name = @[@"AYTopicImageCellView", @"AYTopicDescCellView", @"AYTopicContentCellView", @"AYListEndSignCellView"];
	for (NSString *cell_name in arr_cell_name) {
		id class_name = [cell_name copy];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name);
	}
	
	NSDictionary *tmp = @{kAYServiceArgsAlbum:albumCateg};
	kAYDelegatesSendMessage(@"TopicContent", kAYDelegateChangeDataMessage, &tmp)
	
//	UITableView *tableView = [self.views objectForKey:kAYTableView];
//	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//	tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	
	[self loadNewData];
}

#pragma mark -- actions
- (void)loadNewData {
	NSDictionary *user;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData:user];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:albumCateg forKey:kAYServiceArgsAlbumInfo];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
//	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithLongLong:([NSDate date].timeIntervalSince1970 * 1000)] forKey:kAYCommArgsRemoteDate];
	
	id<AYFacadeBase> f_choice = [self.facades objectForKey:@"ChoiceRemote"];
	AYRemoteCallCommand *cmd_search = [f_choice.commands objectForKey:@"ChoiceSearch"];
	[[AYRemoteCallManager shared] performWithRemoteCmd:cmd_search andArgs:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//	[cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		UITableView *tableView = [self.views objectForKey:kAYTableView];
		if (success) {
			remoteDataArr = [[result objectForKey:@"services"] mutableCopy];
			skipedCount = remoteDataArr.count;
			
			id tmp = @{kAYServiceArgsInfo:[remoteDataArr copy]};
			kAYDelegatesSendMessage(@"TopicContent", kAYDelegateChangeDataMessage, &tmp)
			[tableView reloadData];
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		[tableView.mj_header endRefreshing];
	}];
}

- (void)loadMoreData {
	NSDictionary *user;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:albumCateg forKey:kAYServiceArgsCategoryInfo];
//	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithLong:([NSDate date].timeIntervalSince1970 * 1000)] forKey:kAYCommArgsRemoteDate];
	[dic_search setValue:[NSNumber numberWithInteger:skipedCount] forKey:kAYCommArgsRemoteDataSkip];
	
	id<AYFacadeBase> f_choice = [self.facades objectForKey:@"ChoiceRemote"];
	AYRemoteCallCommand *cmd_search = [f_choice.commands objectForKey:@"ChoiceSearch"];
	[[AYRemoteCallManager shared] performWithRemoteCmd:cmd_search andArgs:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//	[cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		
		UITableView *tableView = [self.views objectForKey:kAYTableView];
		if (success) {
			NSArray *reArr = [result objectForKey:@"services"];
			if (reArr.count != 0) {
				[remoteDataArr addObjectsFromArray:reArr];
				skipedCount = remoteDataArr.count;
				
				id tmp = [remoteDataArr copy];
				kAYDelegatesSendMessage(@"TopicContent", kAYDelegateChangeDataMessage, &tmp)
				[tableView reloadData];
			} else {
				NSString *title = @"没有更多服务了";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		
		[tableView.mj_footer endRefreshing];
	}];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
//	view.backgroundColor = [UIColor colorWithWhite:1 alpha: 0];
//	view.alpha = 0;
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
//	view.backgroundColor = [UIColor colorWithWhite:1 alpha: 0];
//	view.alpha = 0;
	
	NSString *title = albumCateg;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH);
	view.backgroundColor = [UIColor clearColor];
//	((UITableView*)view).contentInset = UIEdgeInsetsMake(kCOLLECTIONVIEWTOP - kStatusAndNavBarH, 0, 0, 0);
	((UITableView*)view).estimatedRowHeight = 300;
	((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
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

- (id)showHideDetail:(NSNumber*)args {
	UITableView *table = [self.views objectForKey:kAYTableView];
	kAYDelegatesSendMessage(@"TopicContent", @"TransfromExpend:", &args)
	[table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
- (id)scrollViewDidScroll:(id)args {
//	CGFloat offset_y = [args floatValue]+20;
//	
//	UIView *navBar = [self.views objectForKey:@"FakeNavBar"];
//	UIView *statusBar = [self.views objectForKey:@"FakeStatusBar"];
//
//	CGFloat alp = ((60+kStatusBarH) - offset_y) / (60+kStatusBarH);		// UP -> small
//	if (alp > 0.7) {
//		navLeftBtn.selected = YES;
//		bannerTitle.textColor = [UIColor white];
//		statusStyle = UIStatusBarStyleLightContent;
//		[self setNeedsStatusBarAppearanceUpdate];
//	} else if (alp < 0.7) {
//		navLeftBtn.selected = NO;
//		bannerTitle.textColor = [UIColor black];
//		statusStyle = UIStatusBarStyleDefault;
//		[self setNeedsStatusBarAppearanceUpdate];
//	}
//	else if (alp >= 1)
//		alp = 1.f;
//	NSLog(@"alp : %f", alp);
//	
//	//		navBar.alpha = statusBar.alpha = 1 - alp;
//	navBar.backgroundColor = statusBar.backgroundColor = [UIColor colorWithWhite:1 alpha: 1-alp];
//	bannerView.alpha = alp;
	
	return nil;
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//	//	[self setNeedsStatusBarAppearanceUpdate];
//	return statusStyle;
//}

@end

