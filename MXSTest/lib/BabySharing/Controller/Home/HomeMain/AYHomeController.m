//
//  AYHomeController.m
//  BabySharing
//
//  Created by Alfred Yang on 4/14/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYHomeController.h"
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

#import "AYDongDaSegDefines.h"
#import "UICollectionViewLeftAlignedLayout.h"

#define kHOMENAVHEIGHT					64
#define kTABLEMARGINTOP					(kStatusBarH + kHOMENAVHEIGHT)
#define kCollectionViewHeight			164

typedef void(^queryContentFinish)(void);

@implementation AYHomeController {
	
	NSMutableArray *serviceData;
    NSInteger skipCountFound;
	NSTimeInterval timeIntervalFound;
	
	UILabel *addressLabel;
	BOOL isDargging;
	
	UIImageView *profilePhoto;
	UILabel *locationLabel;
	CLLocation *loc;
	NSString *localityStr;
	NSDictionary *search_pin;
	NSArray *localityArr;
	BOOL isLocationAuth;
}

@synthesize manager = _manager;

- (CLLocationManager *)manager {
	if (!_manager) {
		_manager = [[CLLocationManager alloc] init];
	}
	return _manager;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
        NSDictionary* dic_push = [dic copy];
        id<AYCommand> cmd = PUSH;
        [cmd performWithResult:&dic_push];
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
        NSDictionary *backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
		NSString *key = [backArgs objectForKey:kAYVCBackArgsKey];
		
		if ([key isEqualToString:kAYVCBackArgsKeyCollectChange]) {
			
			NSString *service_id = [[backArgs objectForKey:kAYServiceArgsInfo] objectForKey:kAYServiceArgsID];
			for (NSMutableDictionary *dic_services in serviceData) {
				NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
				NSArray *result = [[dic_services objectForKey:@"services"] filteredArrayUsingPredicate:pre_id];
				if (result.count != 0) {
					[result.firstObject setValue:[backArgs objectForKey:kAYServiceArgsIsCollect] forKey:kAYServiceArgsIsCollect];
					id tmp = [serviceData copy];
					
					UITableView *view_table = [self.views objectForKey:kAYTableView];
					kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
					[view_table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:([serviceData indexOfObject:dic_services]+1) inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
					break;
				}
			}
		}
		else if ([key isEqualToString:kAYVCBackArgsKeyProfileUpdate]) {
			NSDictionary *user_info = nil;
			CURRENPROFILE(user_info)
			NSString* photo_name = [user_info objectForKey:kAYProfileArgsScreenPhoto];
			if (photo_name) {
				NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
				[dic setValue:photo_name forKey:@"key"];
				[dic setValue:profilePhoto forKey:@"imageView"];
				[dic setValue:@228 forKey:@"wh"];
				id brige = [dic copy];
				id<AYFacadeBase> oss_f = DEFAULTFACADE(@"AliyunOSS");
				id<AYCommand> cmd_oss_get = [oss_f.commands objectForKey:@"OSSGet"];
				[cmd_oss_get performWithResult:&brige];
				
//				id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//				AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//				NSString *prefix = cmd.route;
//				[profilePhoto sd_setImageWithURL:[NSURL URLWithString:[prefix stringByAppendingString:photo_name]] placeholderImage:IMGRESOURCE(@"default_user")];
			}
		}
		
    }
}


#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:[NSNumber numberWithInt:DongDaAppModeCommon] forKey:kAYDongDaAppMode];
	[defaults synchronize];
	
	serviceData = [[NSMutableArray alloc] init];
	localityArr = @[@"北京市", @"Beijing"];
	
	UIView *HomeHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kTABLEMARGINTOP)];
	[self.view addSubview:HomeHeadView];

	NSDictionary *user_info = nil;
	CURRENPROFILE(user_info)
	NSString* photo_name = [user_info objectForKey:@"screen_photo"];
	
//	NSDictionary *oss_dic = @{kAYCommArgsToken:[user_info objectForKey:kAYCommArgsToken]};
//	id<AYFacadeBase> oss_f = DEFAULTFACADE(@"OSSSTSRemote");
//	AYRemoteCallCommand* oss_cmd = [oss_f.commands objectForKey:@"OSSSTSQuery"];
//	[oss_cmd performWithResult:[oss_dic copy] andFinishBlack:^(BOOL success, NSDictionary* result) {
//		NSLog(@"michauxs:%@", result);
//	}];
	
	CGFloat photoWidth = 36;
	profilePhoto = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_MARGIN_LR, (kHOMENAVHEIGHT-photoWidth)*0.5+kStatusBarH, photoWidth, photoWidth)];
	profilePhoto.image = IMGRESOURCE(@"default_user");
	[profilePhoto setRadius:photoWidth*0.5 borderWidth:0 borderColor:nil background:nil];
	[profilePhoto setImageViewContentMode];
	[HomeHeadView addSubview:profilePhoto];
	if (photo_name) {
		
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
		[dic setValue:photo_name forKey:@"key"];
		[dic setValue:profilePhoto forKey:@"imageView"];
		[dic setValue:@228 forKey:@"wh"];
		id brige = [dic copy];
		id<AYFacadeBase> oss_f = DEFAULTFACADE(@"AliyunOSS");
		id<AYCommand> cmd_oss_get = [oss_f.commands objectForKey:@"OSSGet"];
		[cmd_oss_get performWithResult:&brige];
		
//		id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
//		AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
//		NSString *prefix = cmd.route;
//		[profilePhoto sd_setImageWithURL:[NSURL URLWithString:[prefix stringByAppendingString:photo_name]] placeholderImage:IMGRESOURCE(@"default_user")];
	}
	profilePhoto.userInteractionEnabled = YES;
	[profilePhoto addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePhotoTap)]];
	
	UIImageView *dongda = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"logo_artfont")];
	[HomeHeadView addSubview:dongda];
	[dongda mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(profilePhoto);
		make.centerX.equalTo(HomeHeadView);
		make.size.mas_equalTo(CGSizeMake(56, 24));
	}];
	
	locationLabel = [UILabel creatLabelWithText:@"北京" textColor:[UIColor black] fontSize:313.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[HomeHeadView addSubview:locationLabel];
	[locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(dongda.mas_right).offset(7);
//		make.centerY.equalTo(profilePhoto).offset(0);
		make.bottom.equalTo(dongda);
	}];
	locationLabel.userInteractionEnabled = YES;
	[locationLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationLabelTap)]];
	
	UIButton *collesBtn = [UIButton new];
	[collesBtn setImage:IMGRESOURCE(@"home_icon_collection") forState:UIControlStateNormal];
	[HomeHeadView addSubview:collesBtn];
	[collesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(profilePhoto);
		make.right.equalTo(HomeHeadView).offset(0);
		make.size.mas_equalTo(CGSizeMake(44, 44));
	}];
	[collesBtn addTarget:self action:@selector(didCollectBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	{
		UITableView *tableView = [self.views objectForKey:kAYTableView];
		
		id<AYDelegateBase> delegate_found = [self.delegates objectForKey:@"Home"];
		id obj = (id)delegate_found;
		kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
		obj = (id)delegate_found;
		kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
		
		NSArray *arr_cell_name = @[@"AYHomeTopicsCellView", @"AYNurseryCellView", @"AYHomeAssortmentCellView"];
		for (NSString *cell_name in arr_cell_name) {
			id class_name = [cell_name copy];
			kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name);
		}
//		MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//		header.stateLabel.hidden = YES;
//		header.lastUpdatedTimeLabel.hidden = YES;
//		tableView.mj_header = header;
		tableView.mj_header = [MXSRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//		tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	}
	
	[self loadNewData];
	[self startLocation];
	
	UIView *shadow_map = [UIView new];
	shadow_map.backgroundColor = [UIColor white];
	shadow_map.layer.shadowColor = [UIColor colorWithRED:44 GREEN:52 BLUE:109 ALPHA:1].CGColor;
	shadow_map.layer.shadowOffset = CGSizeMake(0, 6);
	shadow_map.layer.shadowRadius = 20;
	shadow_map.layer.shadowOpacity = 0.2f;
	shadow_map.layer.cornerRadius = 29;
	[self.view addSubview:shadow_map];
	[shadow_map mas_makeConstraints:^(MASConstraintMaker *make) {
		make.right.equalTo(self.view).offset(-20);
		make.bottom.equalTo(self.view).offset(-20);
		make.size.mas_equalTo(CGSizeMake(58, 58));
	}];
	UIButton *mapBtn = [[UIButton alloc] init];
	[mapBtn setImage:IMGRESOURCE(@"home_btn_nearby") forState:UIControlStateNormal];
	[self.view addSubview:mapBtn];
	[mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(shadow_map);
	}];
	[mapBtn addTarget:self action:@selector(willOpenMapMatch) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	view.backgroundColor = [Tools whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	view.backgroundColor = [Tools whiteColor];
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden)
	is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
	view.frame = CGRectMake(0, kTABLEMARGINTOP, SCREEN_WIDTH, SCREEN_HEIGHT - kTABLEMARGINTOP);
	return nil;
}

#pragma mark -- controller actions
- (id)foundBtnClick {
    
    AYViewController* des = DEFAULTCONTROLLER(@"Location");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return nil;
}

#pragma mark -- actions
- (void)locationLabelTap {
	
//	if (![localityStr isEqualToString:@"北京市"] && ![localityStr isEqualToString:@"Beijing"]) {
//	}
	NSString *title = @"目前只开放北京,我们正在努力为更多的城市服务";
	AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
}

- (void)profilePhotoTap {
	// 个人信息
	AYViewController* des = DEFAULTCONTROLLER(@"PersonalInfo");
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
}

- (void)didCollectBtnClick {
	
	AYViewController* des = DEFAULTCONTROLLER(@"CollectServ");
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	
}

- (NSDictionary*)sortDataForSearchAroundWithSkiped:(NSInteger)skiped {
	
	if (!search_pin) {
		NSString *title = @"正在定位，请稍等...";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	NSMutableDictionary *dic_search = [[NSMutableDictionary alloc] init];
	
	return [dic_search copy];
}

- (void)loadMoreData {
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	
	NSMutableDictionary *dic_search = [[NSMutableDictionary alloc] init];;
	[dic_search setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];
	[dic_search setValue:[NSNumber numberWithInteger:skipCountFound] forKey:kAYCommArgsRemoteDataSkip];
	/*condition*/
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] init];
	[dic_condt setValue:[NSNumber numberWithLong:timeIntervalFound*1000] forKey:kAYCommArgsRemoteDate];
	[dic_condt setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic_search setValue:dic_condt forKey:kAYCommArgsCondition];
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
	[cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			
			timeIntervalFound = ((NSNumber*)[[result objectForKey:@"result"] objectForKey:kAYCommArgsRemoteDate]).longValue * 0.001;
			NSArray *remoteArr = [[result objectForKey:@"result"] objectForKey:@"services"];
			if (remoteArr.count == 0) {
				NSString *title = @"没有更多服务了";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			} else {
				
				[serviceData addObjectsFromArray:remoteArr];
				skipCountFound += serviceData.count;
				
				id tmp = [serviceData copy];
				kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
				kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			}
			
		} else {
			AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
		}
		
		id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
		[((UITableView*)view_table).mj_footer endRefreshing];
		
	}];
}

- (void)loadNewData {
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [Tools getBaseRemoteData:user];
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	
	/*condition*/
	NSMutableArray *catsArr = [NSMutableArray array];
	NSArray *cats = @[@"看顾",@"艺术",@"运动",@"科学"];
	for (NSString *cat in cats) {
		NSDictionary *dic = @{@"service_type":cat, @"count":[NSNumber numberWithInt:6]};
		[catsArr addObject:dic];
	}
	[[dic_search objectForKey:kAYCommArgsCondition] setValue:[catsArr copy] forKey:@"service_type_list"];
	
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"HomeQuery"];
	[[AYRemoteCallManager shared] performWithRemoteCmd:cmd_tags andArgs:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
		
		UITableView *view_table = [self.views objectForKey:@"Table"];
		if (success) {
			
			//			timeIntervalFound = ((NSNumber*)[[result objectForKey:@"result"] objectForKey:kAYCommArgsRemoteDate]).longValue * 0.001;
			//			serviceData = [[[result objectForKey:@"result"] objectForKey:@"services"] mutableCopy];
			//			skipCountFound = serviceData.count;			//刷新重置 计数为当前请求service数据个数
			serviceData = [[result objectForKey:@"homepage_services"] mutableCopy];
			id tmp = [serviceData copy];
			kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		} else {
			NSString *message = [result objectForKey:@"message"];
			if([message isEqualToString:@"token过期"]) {
				NSString *tip = @"当前用户登录实效已过期，请重新登录";
				AYShowBtmAlertView(tip, BtmAlertViewTypeHideWithTimer)
			} else
				AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
				}
		
		[view_table.mj_header endRefreshing];
	}];
//	[cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
//
//
//	}];
}

#pragma mark -- notifies
- (id)willCollectWithRow:(id)args {
	
	NSDictionary *service_info = [args objectForKey:kAYServiceArgsInfo];
	UIButton *likeBtn = [args objectForKey:@"btn"];
	
	NSString *service_id = [service_info objectForKey:kAYServiceArgsID];
	NSMutableDictionary *handle_info;
	for (NSMutableDictionary *dic_services in serviceData) {
		NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
		NSArray *result = [[dic_services objectForKey:@"services"] filteredArrayUsingPredicate:pre_id];
		if (result.count != 0) {
			handle_info = result.firstObject;
			break;
		}
	}
	
	NSDictionary *user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic = [Tools getBaseRemoteData:user];
	
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
				[handle_info setValue:[NSNumber numberWithBool:YES] forKey:kAYServiceArgsIsCollect];
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
				[handle_info setValue:[NSNumber numberWithBool:NO] forKey:kAYServiceArgsIsCollect];
			} else {
				NSString *title = @"取消收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	}
	return nil;
}

- (id)scrollToShowHideTop:(NSNumber*)args {	//
	return nil;
}

- (id)scrollViewWillBeginDrag {
	isDargging = YES;
	return nil;
}
- (id)scrollViewWillEndDrag {
	isDargging = NO;
	return nil;
}

- (id)didSelectedRow:(NSDictionary*)args {
	
	NSIndexPath *indexPath = [args objectForKey:@"indexpath"];
	UITableView *view_table = [self.views objectForKey:kAYTableView];
	UITableViewCell *cell = [view_table cellForRowAtIndexPath:indexPath];
	
	CGFloat cellImageMinY = (SCREEN_HEIGHT - kStatusAndNavBarH - 49 - cell.bounds.size.height) * 0.5 + kStatusAndNavBarH - 10;
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[[args objectForKey:@"service_info"] objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	[tmp setValue:[NSNumber numberWithFloat:cellImageMinY] forKey:@"cell_min_y"];
	
	[dic setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];

	id<AYCommand> cmd_show_module = HOMEPUSH;
	[cmd_show_module performWithResult:&dic];
	
	return nil;
}

- (id)leftBtnSelected {
	
	return nil;
}

- (id)rightBtnSelected {
	
	return nil;
}

- (id)willOpenMapMatch {
	if (!loc) {
//		NSString *title;
		if (isLocationAuth) {
			NSString *title = @"正在定位，请稍等...";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		} else {
			NSString *title = @"无法获取您的当前位置";
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
			
			UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
			UIAlertAction *certain = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
			}];
			[alert addAction:cancel];
			[alert addAction:certain];
			[self presentViewController:alert animated:YES completion:nil];
		}
		return nil;
	}
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"MapMatch");
	
	NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
	[dic_show_module setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
	[args setValue:loc forKey:kAYServiceArgsLocationInfo];
	[args setValue:[NSNumber numberWithBool:[localityArr containsObject:localityStr]] forKey:@"is_local"];
	
	[dic_show_module setValue:[args copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push = PUSH;
	[cmd_push performWithResult:&dic_show_module];
	
	return nil;
}

- (id)didSomeOneChoiceClick:(id)args {
	id<AYCommand> des = DEFAULTCONTROLLER(@"ChoiceContent");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)didOneTopicClick:(id)args {
	id<AYCommand> des = DEFAULTCONTROLLER(@"TopicContent");
	
	dispatch_async(dispatch_get_main_queue(), ^{
		
		NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
		[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
		[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
		[dic setValue:args forKey:kAYControllerChangeArgsKey];
		
		id<AYCommand> cmd_show_module = PUSH;
		[cmd_show_module performWithResult:&dic];
	});
	return nil;
}

- (id)didAssortmentMoreBtnClick:(id)args {
	id<AYCommand> des ;
	if ([args isEqualToString:@"看顾"]) {
		des = DEFAULTCONTROLLER(@"NursaryList");
	} else {
		des = DEFAULTCONTROLLER(@"Assortment");
	}
	
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)didSelectAssortmentAtIndex:(id)args {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	
//	[dic setObject:[args objectForKey:@"cover"] forKey:kAYControllerImgForFrameKey];
	[dic setValue:[args objectForKey:kAYServiceArgsSelf] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_push_animate = PUSH;
	[cmd_push_animate performWithResult:&dic];
	return nil;
}

- (id)didNursarySortTapAtIndex:(id)args {
	id<AYCommand> des = DEFAULTCONTROLLER(@"SortServiceList");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)didCourseSortTapAtIndex:(id)args {
	id<AYCommand> des = DEFAULTCONTROLLER(@"SortServiceList");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic setValue:args forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)scrollOffsetY:(NSNumber*)args {
    return nil;
}

- (void)startLocation {
	
	[self.manager requestWhenInUseAuthorization];
	self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
	self.manager.delegate = self;
	
	BOOL isEnabled = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
	if ([CLLocationManager locationServicesEnabled] && isEnabled) {
		isLocationAuth = YES;
		[self.manager startUpdatingLocation];
	} else {
		isLocationAuth = NO;
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
	}
}
-(CLGeocoder *)geoC
{
	if (!_geoC) {
		_geoC = [[CLGeocoder alloc] init];
	}
	return _geoC;
}
//定位成功 调用代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	loc = [locations firstObject];
	NSMutableDictionary *l = [[NSMutableDictionary alloc] init];
	[l setValue:[NSNumber numberWithDouble:loc.coordinate.latitude] forKey:kAYServiceArgsLatitude];
	[l setValue:[NSNumber numberWithDouble:loc.coordinate.longitude] forKey:kAYServiceArgsLongtitude];
	search_pin = [l copy];
	
	[self.geoC reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
		if (!error) {
			CLPlacemark *first = placemarks.firstObject;
			localityStr = first.locality;
			
			if (![localityStr isEqualToString:@"北京市"] && ![localityStr isEqualToString:@"Beijing"]) {
				NSString *title = @"咚哒目前只支持北京市,我们正在努力到达更多的城市";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}
	}];
	
	[manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	switch (status) {
		case kCLAuthorizationStatusAuthorizedAlways:
		case kCLAuthorizationStatusAuthorizedWhenInUse: {
			isLocationAuth = YES;
			[self.manager startUpdatingLocation];
		}
			break;
		case kCLAuthorizationStatusDenied:
		case kCLAuthorizationStatusNotDetermined:
		case kCLAuthorizationStatusRestricted: {
			NSLog(@"status:%d",status);
			isLocationAuth = NO;
			loc = nil;
			search_pin = nil;
		}
			break;
		default:
			break;
	}
}
- (id)sendChangeOffsetMessage:(NSNumber*)index {
	
	UICollectionView *view_collection = [self.views objectForKey:@"Collection"];
	CGRect frame_org = view_collection.frame;
	
	[UIView animateWithDuration:0.25 animations:^{
		view_collection.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kCollectionViewHeight);
	} completion:^(BOOL finished) {
		
		NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
		[tmp setValue:index forKey:@"index"];
		[tmp setValue:[NSNumber numberWithInt:SCREEN_WIDTH] forKey:@"unit_width"];
		[tmp setValue:[NSNumber numberWithBool:NO] forKey:@"animated"];
		kAYViewsSendMessage(kAYCollectionView, @"scrollToPostion:", &tmp)
		
		[UIView animateWithDuration:0.15 animations:^{
			view_collection.frame = frame_org;
		}];
	}];
	
	return nil;
}

- (id)sendChangeAnnoMessage:(NSNumber*)index {
	id<AYViewBase> view = [self.views objectForKey:@"MapView"];
	id<AYCommand> cmd = [view.commands objectForKey:@"changeAnnoView:"];
	[cmd performWithResult:&index];
	
	return nil;
}

@end
