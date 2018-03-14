//
//  AYChoiceContentController.m
//  BabySharing
//
//  Created by Alfred Yang on 26/7/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYChoiceContentController.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYThumbsAndPushDefines.h"
#import "AYModelFacade.h"

#define kCHOICESIGNHEIGHT  285

@implementation AYChoiceContentController {
	UIStatusBarStyle statusStyle;
	
	UIView *bannerView;
	UILabel *bannerTitle;
	UILabel *bannerCount;
	UIButton *navLeftBtn;
	
	UILabel *navTitleLabel;
	UILabel *navCountLabel;
	
	NSString *theTopCateg;
	NSMutableArray *queryChioceArr;
	NSInteger skipCount;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		theTopCateg = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
	}
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UITableView *view_table = [self.views objectForKey:kAYTableView];
//	bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, -kCHOICESIGNHEIGHT, SCREEN_WIDTH, kCHOICESIGNHEIGHT)];
	bannerView = [[UIView alloc] init];
	[view_table addSubview:bannerView];
	[bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(view_table).offset(-kCHOICESIGNHEIGHT);
		make.centerX.equalTo(view_table);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kCHOICESIGNHEIGHT));
	}];
	view_table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	
	UIImageView *choice_logo = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"dongda_choice_logo")];
	[bannerView addSubview:choice_logo];
	[choice_logo mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(bannerView.mas_centerX).offset(7);
//		make.left.equalTo(bannerView).offset((SCREEN_WIDTH - 123)*0.5);
		make.top.equalTo(bannerView);
		make.size.mas_equalTo(CGSizeMake(137, 214));
	}];
	bannerTitle = [Tools creatLabelWithText:theTopCateg textColor:[Tools theme] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[bannerView addSubview:bannerTitle];
	[bannerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(choice_logo.mas_bottom).offset(5);
		make.centerX.equalTo(bannerView);
	}];
	bannerCount = [Tools creatLabelWithText:@"20个服务" textColor:[Tools RGB153GaryColor] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[bannerView addSubview:bannerCount];
	[bannerCount mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(bannerTitle.mas_bottom).offset(0);
		make.centerX.equalTo(bannerView);
	}];
	bannerCount.hidden = YES;
	
	UIView *leftLine = [UIView new];
	UIView *rightLine = [UIView new];
	[bannerView addSubview:leftLine];
	[bannerView addSubview:rightLine];
	leftLine.backgroundColor = rightLine.backgroundColor = [Tools garyLineColor];
	
	[leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(bannerView).offset(20);
		make.centerY.equalTo(bannerTitle);
		make.right.equalTo(bannerTitle.mas_left).offset(-30);
		make.height.mas_equalTo(0.5);
	}];
	
	[rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(bannerView).offset(-20);
		make.centerY.equalTo(bannerTitle);
		make.size.equalTo(leftLine);
	}];
	
	
	UIView *navBar = [self.views objectForKey:kAYFakeNavBarView];
	UIView *statusBar = [self.views objectForKey:kAYFakeStatusBarView];
	[self.view bringSubviewToFront:navBar];
	[self.view bringSubviewToFront:statusBar];
	navBar.alpha = statusBar.alpha = 0.f;
	
	navLeftBtn = [[UIButton alloc] init];
	[navLeftBtn setImage:IMGRESOURCE(@"bar_left_black") forState:UIControlStateNormal];
	[navLeftBtn setImage:IMGRESOURCE(@"bar_left_white") forState:UIControlStateSelected];
	[self.view addSubview:navLeftBtn];
	[navLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(navBar).offset(10.5);
		make.centerY.equalTo(navBar);
		make.size.mas_equalTo(CGSizeMake(30, 30));
	}];
	[navLeftBtn addTarget:self action:@selector(leftBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	
	id<AYDelegateBase> delegate = [self.delegates objectForKey:@"ChoiceContent"];
	id obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	obj = (id)delegate;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeServPerCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	
	NSDictionary *user;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:theTopCateg forKey:kAYServiceArgsCategoryInfo];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithLongLong:([NSDate date].timeIntervalSince1970 * 1000)] forKey:kAYCommArgsRemoteDate];
	
	id<AYFacadeBase> f_choice = [self.facades objectForKey:@"ChoiceRemote"];
	AYRemoteCallCommand *cmd_search = [f_choice.commands objectForKey:@"ChoiceSearch"];
	[cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSArray* tmp = [result objectForKey:@"services"];
			queryChioceArr = [tmp mutableCopy];
			skipCount = queryChioceArr.count;
			kAYDelegatesSendMessage(@"ChoiceContent", kAYDelegateChangeDataMessage, &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
	}];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	view.backgroundColor = [Tools theme];
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	view.backgroundColor = [Tools theme];
	
	NSString *title = @"咚哒严选";
	navTitleLabel = [Tools creatLabelWithText:title textColor:[Tools whiteColor] fontSize:615.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[view addSubview:navTitleLabel];
	[navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.bottom.equalTo(view.mas_centerY).offset(0);
//		make.centerX.equalTo(view);
		make.center.equalTo(view);
	}];
	
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
	
	navCountLabel = [Tools creatLabelWithText:@"20个服务" textColor:[Tools whiteColor] fontSize:311.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[view addSubview:navCountLabel];
	[navCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(view.mas_centerY).offset(0);
		make.centerX.equalTo(view);
	}];
	navCountLabel.hidden = YES;
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
	is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden)
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarHideBarBotLineMessage, nil)
	
	view.layer.shadowColor = [Tools garyColor].CGColor;
	view.layer.shadowOffset = CGSizeMake(0, 3);
	view.layer.shadowOpacity = 0.25f;
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
	((UITableView*)view).contentInset = UIEdgeInsetsMake(kCHOICESIGNHEIGHT, 0, 0, 0);
	return nil;
}

#pragma mark -- actions
- (void)loadMoreData {
	
	NSDictionary *user;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:theTopCateg forKey:kAYServiceArgsCategoryInfo];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[NSNumber numberWithLong:([NSDate date].timeIntervalSince1970 * 1000)] forKey:kAYCommArgsRemoteDate];
	
	id<AYFacadeBase> f_choice = [self.facades objectForKey:@"ChoiceRemote"];
	AYRemoteCallCommand *cmd_search = [f_choice.commands objectForKey:@"ChoiceSearch"];
	[cmd_search performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		if (success) {
			NSArray *reArr = [result objectForKey:@"services"];
			if (reArr.count != 0) {
				[queryChioceArr addObjectsFromArray:reArr];
				skipCount = queryChioceArr.count;
				
				id tmp = [queryChioceArr copy];
				kAYDelegatesSendMessage(@"ChoiceContent", kAYDelegateChangeDataMessage, &tmp)
				kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			} else {
				NSString *title = @"没有更多服务了";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		} else {
			
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		UITableView *view_table = [self.views objectForKey:@"Table2"];
		kAYViewsSendMessage(@"Table", kAYTableRefreshMessage, nil)
		[view_table.mj_footer endRefreshing];
	}];
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
	
	NSString *service_id = [args objectForKey:kAYServiceArgsID];
	UIButton *likeBtn = [args objectForKey:@"btn"];
	
	NSDictionary *user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic = [Tools getBaseRemoteData];
	
	NSMutableDictionary *dic_collect = [[NSMutableDictionary alloc] init];
	[dic_collect setValue:service_id forKey:kAYServiceArgsID];
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
			} else {
				NSString *title = @"取消收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	}
	return nil;
}

#pragma scroll delegate
- (id)scrollOffsetYNoyify:(id)args {
	CGFloat offset_y = ((NSNumber*)args).floatValue;
	
	UIView *navBar = [self.views objectForKey:@"FakeNavBar"];
	UIView *statusBar = [self.views objectForKey:@"FakeStatusBar"];
	
	if (offset_y+kStatusAndNavBarH*2 < 0 ) {
		
		CGFloat alp = fabs(offset_y+kStatusAndNavBarH*2) / (kCHOICESIGNHEIGHT-kStatusAndNavBarH*2);		// UP -> small
		if (alp > 0.7) {
			navLeftBtn.selected = NO;
			statusStyle = UIStatusBarStyleDefault;
			[self setNeedsStatusBarAppearanceUpdate];
		} else if (alp < 0.7) {
			navLeftBtn.selected = YES;
			statusStyle = UIStatusBarStyleLightContent;
			[self setNeedsStatusBarAppearanceUpdate];
		}
		else if (alp >= 1)
			alp = 1.f;
		NSLog(@"alp : %f", alp);
		
		navBar.alpha = statusBar.alpha = 1 - alp;
		bannerView.alpha = alp;
	}
	return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	//	[self setNeedsStatusBarAppearanceUpdate];
	return statusStyle;
}

@end
