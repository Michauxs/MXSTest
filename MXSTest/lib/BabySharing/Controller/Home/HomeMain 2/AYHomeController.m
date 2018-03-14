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


typedef void(^queryContentFinish)(void);

#define HEADER_MARGIN_TO_SCREEN         10.5
#define CONTENT_START_POINT             71
#define PAN_HANDLE_CHECK_POINT          10
#define BACK_TO_TOP_TIME    3.0
#define SHADOW_WIDTH 4
#define TableContentInsetTop     120
#define kFilterCollectionViewHeight 			90
#define kDongDaSegHeight				44
// 减速度
#define DECELERATION 400.0

#import "AYFilterCansCellView.h"
#import "UICollectionViewLeftAlignedLayout.h"

@implementation AYHomeController {
    
    CATextLayer* badge;
    UIButton* actionView;
    CAShapeLayer *circleLayer;
    UIView *animationView;
    CGFloat radius;
    CALayer *maskLayer;
	
    NSInteger skipCount;
	NSTimeInterval timeInterval;
	NSDictionary *search_loc;
	
	/************旧版搜索************/
	NSNumber *search_cansCat;
	NSNumber *search_servCat;
	NSMutableArray *servicesData;
	/*************************/
	
	UIButton *filterBtn;
	int DongDaSegIndex;		// == service_type
	NSMutableDictionary *serviceData;
	NSMutableDictionary *subIndexData;
	NSArray *titleArr;
	UIView *maskView;
	
	UICollectionView *filterCollectionView;
	
	UILabel *addressLabel;
	UILabel *themeCatlabel;
	UIView *filterViewBg;
	CGFloat dynamicOffsetY;
	BOOL isDargging;
	
	NSDictionary *dic_location;
	CLLocation *loc;

}

@synthesize manager = _manager;

- (CLLocationManager *)manager{
	if (!_manager) {
		_manager = [[CLLocationManager alloc]init];
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
        id backArgs = [dic objectForKey:kAYControllerChangeArgsKey];
		
		if ([backArgs isKindOfClass:[NSString class]]) {
//			NSString *title = (NSString*)backArgs;
//			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		else if ([backArgs isKindOfClass:[NSDictionary class]]) {
			NSString *key = [backArgs objectForKey:@"key"];
			if ([key isEqualToString:@"filterLocation"]) {
				addressLabel.text = [backArgs objectForKey:kAYServiceArgsAddress];
				search_loc = [backArgs objectForKey:kAYServiceArgsLocation];
				[self loadNewData];
				NSNumber *height = [NSNumber numberWithFloat:0.f];
				kAYViewsSendMessage(kAYTableView, @"scrollToPostion:", &height)
			}
			else if ([key isEqualToString:@"filterTheme"]) {
				search_cansCat = [backArgs objectForKey:kAYServiceArgsTheme];
				search_servCat = [backArgs objectForKey:kAYServiceArgsServiceCat];
				themeCatlabel.text = [backArgs objectForKey:@"title"];
				[self loadNewData];
				NSNumber *height = [NSNumber numberWithFloat:0.f];
				kAYViewsSendMessage(kAYTableView, @"scrollToPostion:", &height)
			}
			else if ([key isEqualToString:@"is_change_collect"]) {
				id service_info = [backArgs objectForKey:@"args"];
				NSString *service_id = [service_info objectForKey:kAYServiceArgsID];
				NSMutableArray *handArr = [serviceData objectForKey:[self serviceDataHandleKey]];
				NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
				NSArray *result = [handArr filteredArrayUsingPredicate:pre_id];
				if (result.count == 1) {
					NSInteger index = [handArr indexOfObject:result.firstObject];
					[handArr replaceObjectAtIndex:index withObject:service_info];
					UITableView *view_table = [self.views objectForKey:kAYTableView];
					id tmp = [handArr copy];
					kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
					[view_table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
				}
			}
			
		}
			
    }
}

#pragma mark -- CollectionView delegate datasoure
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *class_name = @"AYFilterCansCellView";
	AYFilterCansCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:class_name forIndexPath:indexPath];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:[titleArr objectAtIndex:indexPath.row] forKey:@"title"];
	NSNumber *comp = [subIndexData objectForKey:[NSString stringWithFormat:@"%d",DongDaSegIndex]];
	[tmp setValue:[NSNumber numberWithBool:indexPath.row == comp.integerValue && comp] forKey:@"is_selected"];
	cell.itemInfo = tmp;
	
	return (UICollectionViewCell*)cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat itemHeight = 40;
	if (DongDaSegIndex == ServiceTypeCourse) {
		//		NSString *title = [courseTitleArr objectAtIndex:indexPath.row];
		return CGSizeMake(80, itemHeight);
	} else {
		return CGSizeMake(106, itemHeight);
	}
	
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *key_comp = [NSString stringWithFormat:@"%d", DongDaSegIndex];
	NSNumber *index_comp = [subIndexData objectForKey:key_comp];
	
	NSNumber *index = [NSNumber numberWithInteger:indexPath.row];
	
	if ([index_comp isEqualToNumber:index]) {
		[subIndexData removeObjectForKey:key_comp];
	} else
		[subIndexData setValue:index forKey:[NSString stringWithFormat:@"%d", DongDaSegIndex]];
	
	[filterCollectionView reloadData];
	[self didFilterBtnClick:nil];
	[self loadNewData];
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
	dynamicOffsetY = 0.f;
	DongDaSegIndex = ServiceTypeCourse;
	subIndexData = [[NSMutableDictionary alloc] init];
	serviceData = [[NSMutableDictionary alloc] init];
	timeInterval = [NSDate date].timeIntervalSince1970;
//	servDataOfCourse = [NSMutableArray array];
//	servDataOfNursery = [NSMutableArray array];
	
	filterViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusAndNavBarH, SCREEN_WIDTH, kDongDaSegHeight)];
	filterViewBg.backgroundColor = [Tools whiteColor];
	filterViewBg.layer.shadowColor = [Tools garyColor].CGColor;
	filterViewBg.layer.shadowOffset = CGSizeMake(0, 3.5);
	filterViewBg.layer.shadowOpacity = 0.15f;
	[self.view addSubview:filterViewBg];
	
//	UIView *view_collect = [self.views objectForKey:kAYCollectionVerView];
//	[self.view bringSubviewToFront:view_collect];
	
	titleArr = kAY_service_options_title_course;
	UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc] init];
	layout.minimumInteritemSpacing = 20.f;
	layout.minimumLineSpacing = 25.f;
	layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
	filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 108.f - kFilterCollectionViewHeight, SCREEN_WIDTH, kFilterCollectionViewHeight) collectionViewLayout:layout];
	filterCollectionView.backgroundColor = [Tools garyBackgroundColor];
	filterCollectionView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:filterCollectionView];
	filterCollectionView.delegate =self;
	filterCollectionView.dataSource =self;
	filterCollectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 0);
	[Tools creatCALayerWithFrame:CGRectMake(-20, 89.5, SCREEN_WIDTH*10, 0.5) andColor:[Tools garyLineColor] inSuperView:filterCollectionView];
	
	NSString *item_class_name = @"AYFilterCansCellView";
	[filterCollectionView registerClass:NSClassFromString(item_class_name) forCellWithReuseIdentifier:item_class_name];
	
	maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
	maskView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.15f];
	[self.view addSubview:maskView];
	maskView.hidden = YES;
	maskView.userInteractionEnabled = YES;
	[maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didMaskViewTap)]];
	
	/**********层级调整*******/
	[self.view bringSubviewToFront:filterCollectionView];
	UIView *view_status = [self.views objectForKey:@"FakeStatusBar"];
	UIView *view_nav = [self.views objectForKey:kAYFakeNavBarView];
	[self.view bringSubviewToFront:filterViewBg];
	[self.view bringSubviewToFront:view_nav];
	[self.view bringSubviewToFront:view_status];
	
	filterBtn = [[UIButton alloc]init];
	[filterBtn setImage:IMGRESOURCE(@"home_icon_filter") forState:UIControlStateNormal];
	[filterBtn setImage:IMGRESOURCE(@"home_icon_filter") forState:UIControlStateSelected];
	[filterViewBg addSubview:filterBtn];
	[filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(filterViewBg);
		make.centerX.equalTo(filterViewBg.mas_right).offset(-30);
		make.size.mas_equalTo(CGSizeMake(60, kDongDaSegHeight));
	}];
	filterBtn.selected = NO;
	[filterBtn addTarget:self action:@selector(didFilterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	
	UIView *segView = [self.views objectForKey:@"DongDaSeg"];
	[filterViewBg addSubview:segView];
	
	id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
	UITableView *tableView = (UITableView*)view_notify;
	
	UILabel *tipsLabel = [Tools creatUILabelWithText:@"没有匹配的结果" andTextColor:[Tools garyColor] andFontSize:16.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
	[tableView addSubview:tipsLabel];
	[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(tableView).offset(180);
		make.centerX.equalTo(tableView);
	}];
	[tableView sendSubviewToBack:tipsLabel];
	
	tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
	tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
	
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"Home"];
	id<AYCommand> cmd_datasource = [view_notify.commands objectForKey:@"registerDatasource:"];
	id<AYCommand> cmd_delegate = [view_notify.commands objectForKey:@"registerDelegate:"];
	
	id obj = (id)cmd_notify;
	[cmd_datasource performWithResult:&obj];
	obj = (id)cmd_notify;
	[cmd_delegate performWithResult:&obj];
	
	id<AYCommand> cmd_cell = [view_notify.commands objectForKey:@"registerCellWithClass:"];
	NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"HomeServPerCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	[cmd_cell performWithResult:&class_name];
	class_name = @"HomeTopTipCell";
	[cmd_cell performWithResult:&class_name];
	
	id<AYDelegateBase> delegate_collect = [self.delegates objectForKey:@"HomeCollect"];
	id dele = delegate_collect;
	kAYViewsSendMessage(kAYCollectionVerView, kAYTableRegisterDelegateMessage, &dele)
	dele = delegate_collect;
	kAYViewsSendMessage(kAYCollectionVerView, kAYTableRegisterDatasourceMessage, &dele)
	
//	NSString *item_class_name = @"AYFilterCansCellView";
//	kAYViewsSendMessage(kAYCollectionVerView, kAYTableRegisterCellWithClassMessage, &item_class_name)
	
//	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
//	[tmp setValue:[NSNumber numberWithInt:DongDaSegIndex] forKey:kAYServiceArgsServiceCat];
//	[tmp setValue:[NSNumber numberWithInt:-1] forKey:@"sub_index"];
//	kAYDelegatesSendMessage(@"HomeCollect", kAYDelegateChangeDataMessage, &tmp)
	
	[self loadNewData];
	[self startLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
	view.backgroundColor = [Tools whiteColor];
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44);
	view.backgroundColor = [Tools whiteColor];
	
	addressLabel = [Tools creatUILabelWithText:@"北京市" andTextColor:[Tools garyColor] andFontSize:315.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentLeft];
	[view addSubview:addressLabel];
	[addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(view).offset(20);
		make.centerY.equalTo(view);
	}];
//	addressLabel.userInteractionEnabled = YES;
//	[addressLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didAddressLabelTap)]];
	
	UIButton *mapBtn = [[UIButton alloc]init];
	[mapBtn setImage:IMGRESOURCE(@"home_icon_mapfilter") forState:UIControlStateNormal];
	[view addSubview:mapBtn];
	[mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(view);
		make.centerX.equalTo(view.mas_right).offset(-30);
		make.size.mas_equalTo(CGSizeMake(kDongDaSegHeight, kDongDaSegHeight));
	}];
	[mapBtn addTarget:self action:@selector(rightBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	
	NSNumber *is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &is_hidden)
	is_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &is_hidden)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	
	[Tools addBtmLineWithMargin:0 andAlignment:NSTextAlignmentCenter andColor:[Tools garyLineColor] inSuperView:view];
	return nil;
}

#import "AYDongDaSegDefines.h"
- (id)DongDaSegLayout:(UIView*)view {
	
	view.frame = CGRectMake(0, 0, 180, kDongDaSegHeight);		//重新加入了self.view 的子view   0,0,w,h
	
	id<AYViewBase> seg = (id<AYViewBase>)view;
	id<AYCommand> cmd_add_item = [seg.commands objectForKey:@"addItem:"];
	
	NSMutableDictionary* dic_add_item_0 = [[NSMutableDictionary alloc]init];
	[dic_add_item_0 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
	[dic_add_item_0 setValue:@"课程" forKey:kAYSegViewTitleKey];
	[cmd_add_item performWithResult:&dic_add_item_0];
	
	NSMutableDictionary* dic_add_item_1 = [[NSMutableDictionary alloc]init];
	[dic_add_item_1 setValue:[NSNumber numberWithInt:AYSegViewItemTypeTitle] forKey:kAYSegViewItemTypeKey];
	[dic_add_item_1 setValue:@"看顾" forKey:kAYSegViewTitleKey];
	[cmd_add_item performWithResult:&dic_add_item_1];
	
	NSMutableDictionary* dic_user_info = [[NSMutableDictionary alloc]init];
	[dic_user_info setValue:[NSNumber numberWithInt:0] forKey:kAYSegViewCurrentSelectKey];
	[dic_user_info setValue:[NSNumber numberWithFloat:20] forKey:kAYSegViewMarginBetweenKey];
	
	id<AYCommand> cmd_info = [seg.commands objectForKey:@"setSegInfo:"];
	[cmd_info performWithResult:&dic_user_info];
	
	return nil;
}

- (id)TableLayout:(UIView*)view {
	CGFloat topmargin = 108.f;
    view.frame = CGRectMake(0, topmargin, SCREEN_WIDTH, SCREEN_HEIGHT - topmargin - 49);
    ((UITableView*)view).backgroundColor = [UIColor whiteColor];
    return nil;
}

- (id)CollectionVerLayout:(UIView*)view {
	CGFloat topMargin = 108.f;
	view.frame = CGRectMake(0, topMargin, SCREEN_WIDTH, kFilterCollectionViewHeight);
//	view.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.75f];
	view.backgroundColor = [UIColor whiteColor];
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
- (void)didAddressLabelTap {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"FilterLocation");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd_show_module = SHOWMODULEUP;
	[cmd_show_module performWithResult:&dic];
	
}

- (void)didMaskViewTap {
	maskView.hidden = YES;
	[self didFilterBtnClick:nil];
}

- (void)didFilterBtnClick:(UIButton*)btn {
//	UICollectionView *view_collect = [self.views objectForKey:kAYCollectionVerView];
	
	filterBtn.selected = !filterBtn.selected;
	NSLog(@"%d", filterBtn.selected);
	if (filterBtn.selected) {
		maskView.hidden = NO;
		[UIView animateWithDuration:0.25 animations:^{
			filterCollectionView.frame = CGRectMake(0, 108.f + dynamicOffsetY, SCREEN_WIDTH, kFilterCollectionViewHeight);
		}];
	} else {		//hide
		
		maskView.hidden = YES;
		[UIView animateWithDuration:0.25 animations:^{
			filterCollectionView.frame = CGRectMake(0, 108.f - 90 + dynamicOffsetY, SCREEN_WIDTH, kFilterCollectionViewHeight);
		}];
	}
}

- (NSString*)serviceDataHandleKey {
	return [NSString stringWithFormat:@"%d", DongDaSegIndex];
}

- (void)loadMoreData {
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [user mutableCopy];
	[dic_search setValue:[NSNumber numberWithInteger:skipCount] forKey:@"skip"];
	[dic_search setValue:[NSNumber numberWithDouble:timeInterval * 1000] forKey:@"date"];
	[dic_search setValue:search_loc forKey:kAYServiceArgsLocation];
	/*condition*/
	[dic_search setValue:[NSNumber numberWithInt:DongDaSegIndex] forKey:kAYServiceArgsServiceCat];
	[dic_search setValue:[subIndexData objectForKey:[NSString stringWithFormat:@"%d",DongDaSegIndex]] forKey:kAYServiceArgsTheme];
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
	[cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		if (success) {
			NSLog(@"query recommand tags result %@", result);
			NSArray *remoteArr = [result objectForKey:@"result"];
			
			if (remoteArr.count == 0) {
				NSString *title = @"没有更多服务了";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			} else {
				
				NSMutableArray *handArr = [serviceData objectForKey:[self serviceDataHandleKey]];
				[handArr addObjectsFromArray:remoteArr];
				skipCount += handArr.count;
				
				id tmp = [handArr copy];
				kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
				kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			}
			
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		
		id<AYViewBase> view_table = [self.views objectForKey:@"Table"];
		[((UITableView*)view_table).mj_footer endRefreshing];
		
	}];
}

- (void)loadNewData {
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic_search = [user mutableCopy];
	[dic_search setValue:[NSNumber numberWithDouble:timeInterval * 1000] forKey:@"date"];
	[dic_search setValue:search_loc forKey:kAYServiceArgsLocation];
	/*condition*/
	[dic_search setValue:[NSNumber numberWithInt:DongDaSegIndex] forKey:kAYServiceArgsServiceCat];
	[dic_search setValue:[subIndexData objectForKey:[NSString stringWithFormat:@"%d",DongDaSegIndex]] forKey:kAYServiceArgsTheme];
	
	id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand* cmd_tags = [f_search.commands objectForKey:@"SearchFiltService"];
	[cmd_tags performWithResult:[dic_search copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
		UITableView *view_table = [self.views objectForKey:@"Table"];
		if (success) {
			
			NSArray *remoteArr = [result objectForKey:@"result"];
//			NSPredicate *pre_course = [NSPredicate predicateWithFormat:@"self.%@=%d", kAYServiceArgsServiceCat, ServiceTypeCourse];
//			servDataOfCourse = [[remoteArr filteredArrayUsingPredicate:pre_course] mutableCopy];
			
			[serviceData setValue:[remoteArr mutableCopy] forKey:[NSString stringWithFormat:@"%d", DongDaSegIndex]];
			skipCount = remoteArr.count;			//刷新重置 计数为当前请求service数据个数
			
			id tmp = [remoteArr copy];
			kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
			kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			[view_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
		} else {
			NSString *title = @"请改善网络环境并重试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
		
		[view_table.mj_header endRefreshing];
		
	}];
}

#pragma mark -- notifies
- (id)willCollectWithRow:(id)args {
	
	NSString *service_id = [args objectForKey:kAYServiceArgsID];
	UIButton *likeBtn = [args objectForKey:@"btn"];
	
	NSDictionary *info = nil;
	CURRENUSER(info);
	NSMutableArray *handArr = [serviceData objectForKey:[self serviceDataHandleKey]];
	NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, service_id];
	NSArray *resultArr = [handArr filteredArrayUsingPredicate:pre_id];
	if (resultArr.count != 1) {
		return nil;
	}
	NSMutableDictionary *dic = [info mutableCopy];
	[dic setValue:[resultArr.firstObject objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
	if (!likeBtn.selected) {
		AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"CollectService"];
		[cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
			if (success) {
				likeBtn.selected = YES;
				[resultArr.firstObject setValue:[NSNumber numberWithBool:YES] forKey:kAYServiceArgsIsCollect];
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
				[resultArr.firstObject setValue:[NSNumber numberWithBool:NO] forKey:kAYServiceArgsIsCollect];
			} else {
				NSString *title = @"取消收藏失败!请检查网络链接是否正常";
				AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
			}
		}];
	}
	return nil;
}

- (id)collectCompleteWithRow:(NSString*)args {
	NSMutableArray *handArr = [serviceData objectForKey:[self serviceDataHandleKey]];
	NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, args];
	NSArray *result = [handArr filteredArrayUsingPredicate:pre_id];
	if (result.count == 1) {
		[result.firstObject setValue:[NSNumber numberWithBool:YES] forKey:kAYServiceArgsIsCollect];
	}
	return nil;
}
- (id)unCollectCompleteWithRow:(NSString*)args {
	NSMutableArray *handArr = [serviceData objectForKey:[self serviceDataHandleKey]];
	NSPredicate *pre_id = [NSPredicate predicateWithFormat:@"self.%@=%@", kAYServiceArgsID, args];
	NSArray *result = [handArr filteredArrayUsingPredicate:pre_id];
	if (result.count == 1) {
		[result.firstObject setValue:[NSNumber numberWithBool:NO] forKey:kAYServiceArgsIsCollect];
	}
	return nil;
}

- (id)scrollToShowHideTop:(NSNumber*)args {	//
	if (isDargging) {
		
		UITableView *view_table = [self.views objectForKey:kAYTableView];
		if (view_table.contentOffset.y > view_table.contentSize.height - view_table.frame.size.height || view_table.contentOffset.y < 0 ) {
			return nil;
		}
		
		UIView *view_nav = [self.views objectForKey:kAYFakeNavBarView];
		dynamicOffsetY = dynamicOffsetY + args.floatValue;
		NSLog(@"%f", dynamicOffsetY);
		if (dynamicOffsetY > 0) {
			dynamicOffsetY = 0.f;
		} else if (dynamicOffsetY < - 44) {
			dynamicOffsetY = -44.f;
		}
		view_table.frame = CGRectMake(0, 108 + dynamicOffsetY, SCREEN_WIDTH, SCREEN_HEIGHT - 108 - 49 - dynamicOffsetY);
		view_nav.frame = CGRectMake(0, 20 + dynamicOffsetY, SCREEN_WIDTH, 44);
		filterViewBg.frame = CGRectMake(0, kStatusAndNavBarH + dynamicOffsetY, SCREEN_WIDTH, kDongDaSegHeight);
		filterCollectionView.frame = CGRectMake(0, 108 - (filterBtn.selected ? 0 : kFilterCollectionViewHeight) + dynamicOffsetY, SCREEN_WIDTH, kFilterCollectionViewHeight);
	}
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

- (id)didSelectedRow:(NSMutableDictionary*)args {
	
	NSIndexPath *indexPath = [args objectForKey:@"indexpath"];
	UITableView *view_table = [self.views objectForKey:kAYTableView];
	UITableViewCell *cell = [view_table cellForRowAtIndexPath:indexPath];
	
	CGFloat cellImageMinY = (SCREEN_HEIGHT - 64 - 44 - 49 - cell.bounds.size.height) * 0.5 + 64 + 44 - 10;
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[args setValue:[NSNumber numberWithFloat:cellImageMinY] forKey:@"cell_min_y"];
	
	[dic setValue:args forKey:kAYControllerChangeArgsKey];

	id<AYCommand> cmd_show_module = HOMEPUSH;
	[cmd_show_module performWithResult:&dic];
	
	return nil;
}

- (id)leftBtnSelected {
	
	return nil;
}

- (id)rightBtnSelected {
	
	if (!loc) {
		NSString *title = @"正在定位，请稍等...";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return nil;
	}
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"MapMatch");
	
	NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc]init];
	[dic_show_module setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_show_module setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *args = [[NSMutableDictionary alloc]init];
	[args setValue:loc forKey:@"location"];
	[args setValue:[[serviceData objectForKey:[self serviceDataHandleKey]] copy] forKey:@"result_data"];
	
	[dic_show_module setValue:[args copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic_show_module];
	
	return nil;
}

- (id)segValueChanged:(id)obj {
	id<AYViewBase> seg = (id<AYViewBase>)obj;
	id<AYCommand> cmd = [seg.commands objectForKey:@"queryCurrentSelectedIndex"];
	NSNumber* index = nil;
	[cmd performWithResult:&index];
	NSLog(@"current index %@", index);
	
	DongDaSegIndex = index.intValue;
	NSMutableArray *handArr = [serviceData objectForKey:[self serviceDataHandleKey]];
	if (handArr.count != 0) {
		id tmp = [handArr copy];
		kAYDelegatesSendMessage(@"Home", kAYDelegateChangeDataMessage, &tmp)
		kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	} else {
		[self loadNewData];
	}
	
	if (index.intValue == ServiceTypeCourse) {
		titleArr = kAY_service_options_title_course;
	} else {
		titleArr = kAY_service_options_title_nursery;
	}
	[filterCollectionView reloadData];
	
	return nil;
}

- (id)scrollOffsetY:(NSNumber*)args {
//    CGFloat offset_y = args.floatValue;
//    CGFloat offsetH = SCREEN_WIDTH + offset_y;
//
//    if (offsetH < 0) {
//        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
//        UITableView *tableView = (UITableView*)view_notify;
//        [coverImg mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(tableView);
//            make.top.equalTo(tableView).offset(-SCREEN_WIDTH + offsetH);
//            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - offsetH, SCREEN_WIDTH - offsetH));
//        }];
//    }
    return nil;
}

- (void)startLocation {
	
	[self.manager requestWhenInUseAuthorization];
	self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
	self.manager.delegate = self;
	if ([CLLocationManager locationServicesEnabled]) {
		
		[self.manager startUpdatingLocation];
	} else {
		NSString *title = @"请在iPhone的\"设置-隐私-定位\"中允许-咚哒-定位服务";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
	}
}

//定位成功 调用代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	loc = [locations firstObject];
	[manager stopUpdatingLocation];
	
}




@end
