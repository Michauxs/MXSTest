//
//  AYPersonalPageController.m
//  BabySharing
//
//  Created by Alfred Yang on 12/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYServicePageController.h"
#import "TmpFileStorageModel.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYViewBase.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYRemoteCallDefines.h"
#import "AYModelFacade.h"

#import "AYServiceImagesCell.h"
#import "AYServicePageBtmView.h"

#define kLIMITEDSHOWNAVBAR			(-70.5)
#define kFlexibleHeight				280
#define kBtmViewHeight				56
#define kBookBtnTitleNormal			@"查看可预订时间"
#define kBookBtnTitleSeted			@"申请预订"

//#define CarouseNumb			

@implementation AYServicePageController {
	NSDictionary *receiveData;
    NSMutableDictionary *service_info;
    
    UIButton *shareBtn;
    CGFloat offset_y;
	BOOL isBlackLeftBtn;
	BOOL isStatusHide;
	
	
    UIButton *bar_like_btn;
	UIButton *bar_back_btn;
    UIView *flexibleView;
	UIScrollView *TAGScrollView;
	NSMutableArray *imageTagsView;
	AYImageTagView *tmpImageTag;
	
	BOOL isChangeCollect;
	/****/
	UICollectionView *CarouselView;
	NSArray *serviceImages;
	CGFloat HeadViewHeight;
	/****/
	
	NSMutableArray *offer_date_mutable;
}

-(void)postPerform {
	[super postPerform];
	isStatusHide = YES;
}

- (void)performWithResult:(NSObject**)obj {
    
    NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		receiveData = [dic objectForKey:kAYControllerChangeArgsKey];
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		
    }
}

#pragma mark --<UICollectionViewDataSource,UICollectionViewDelegate>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return serviceImages.count == 0 ? 1 : serviceImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	AYServiceImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AYServiceImagesCell" forIndexPath:indexPath];
	
	if (serviceImages.count != 0) {
//		if ([[serviceImages firstObject] isKindOfClass:[NSString class]]) {
//			[cell setItemImageWithImageName:[serviceImages objectAtIndex:indexPath.row]];
//		} else {
//		NSDictionary *info_img = [serviceImages objectAtIndex:indexPath.row];
//		[cell setItemImageWithImage:[info_img objectForKey:@"image"]];
//		}
		NSDictionary *info_img = [serviceImages objectAtIndex:indexPath.row];
		[cell setItemImageWithImageName:[info_img objectForKey:@"image"]];
		
	} else
		[cell setItemImageWithImage:IMGRESOURCE(@"default_image")];
	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
		return CGSizeMake(SCREEN_WIDTH, HeadViewHeight);
}

//设置页码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	int page = (int)(scrollView.contentOffset.x / SCREEN_WIDTH + 0.5)% serviceImages.count;
	NSDictionary *item = [serviceImages objectAtIndex:page];
	NSString *tag = [item objectForKey:@"tag"];
	
	for (AYImageTagView *view in imageTagsView) {
		if ([view.label.text isEqualToString:tag]) {
			
			tmpImageTag.isSelect = NO;
			view.isSelect = YES;
			tmpImageTag = view;
			
			CGPoint offSet = TAGScrollView.contentOffset;
			CGFloat x_min = CGRectGetMinX(view.frame);
			CGFloat x_max = CGRectGetMaxX(view.frame);
			
			if (x_min - offSet.x <= 0) {
				[TAGScrollView scrollRectToVisible:view.frame animated:YES];
//				TAGScrollView.contentOffset = CGPointMake(view.frame.origin.x, 0);
				
			} else if (x_max - offSet.x >= SCREEN_WIDTH) {
				[TAGScrollView scrollRectToVisible:view.frame animated:YES];
//				TAGScrollView.contentOffset = CGPointMake(view.frame.origin.x - (SCREEN_WIDTH-view.frame.size.width), 0);
				
			} else {
				
			}
		}
	}
	
//	pageControl.currentPage = page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [Tools whiteColor];
	
	HeadViewHeight = kFlexibleHeight;
	
    id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"ServicePage"];
    id obj = (id)cmd_recommend;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
    obj = (id)cmd_recommend;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	
	NSArray *cell_class_name_arr = @[@"ServiceTitleCell",
									 @"ServiceOwnerInfoCell",
									 @"ServiceCapacityCell",
									 @"ServiceDescCell",
									 @"ServiceTAGCell",
									 @"ServiceMapCell",
									 @"ServiceFacilityCell",
									 @"ServiceNotiCell"];
	NSString* class_name;
	for (NSString *class_name_str in cell_class_name_arr) {
		class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:class_name_str] stringByAppendingString:kAYFactoryManagerViewsuffix];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &class_name)
	}
	
	/*********************************************/
	
	{
		UITableView *tableView = [self.views objectForKey:kAYTableView];
		flexibleView = [[UIView alloc]init];
		[tableView addSubview:flexibleView];
		[flexibleView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(tableView).offset(-kFlexibleHeight);
			make.centerX.equalTo(tableView);
			make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, kFlexibleHeight));
		}];
		
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.minimumLineSpacing = 0.f;
		layout.minimumInteritemSpacing = 0.f;
		layout.itemSize = CGSizeMake(SCREEN_WIDTH, HeadViewHeight);
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		
		CarouselView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kFlexibleHeight) collectionViewLayout:layout];
		CarouselView.backgroundColor = [UIColor clearColor];
		CarouselView.delegate = self;
		CarouselView.dataSource = self;
		CarouselView.pagingEnabled = YES;
		CarouselView.showsHorizontalScrollIndicator = NO;
		CarouselView.bounces = NO;
		[CarouselView registerClass:NSClassFromString(@"AYServiceImagesCell") forCellWithReuseIdentifier:@"AYServiceImagesCell"];
		[flexibleView addSubview:CarouselView];
		
		UIImageView *mask = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"mask_detail_images")];
		[flexibleView addSubview:mask];
//		mask.frame = CGRectMake(0, HeadViewHeight - 42, SCREEN_WIDTH, 42);
		[mask mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(flexibleView);
			make.left.equalTo(flexibleView);
			make.right.equalTo(flexibleView);
			make.height.equalTo(@42);
		}];
		
		TAGScrollView = [[UIScrollView alloc] init/*WithFrame:CGRectMake(0, HeadViewHeight-30, SCREEN_WIDTH, 30)*/];
		[flexibleView addSubview:TAGScrollView];
		TAGScrollView.bounces = NO;
		[TAGScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(flexibleView);
			make.left.equalTo(flexibleView);
			make.right.equalTo(flexibleView);
			make.height.equalTo(@30);
		}];
	}
	
	NSNumber *per_mode = [receiveData objectForKey:@"perview_mode"];
	NSString *service_id = [receiveData objectForKey:kAYServiceArgsID];
	if (per_mode ) {
		bar_like_btn.hidden = YES;
		
		service_info = [receiveData mutableCopy];
		[self layoutServicePageBannerImages];
		NSDictionary *tmp = [service_info copy];
		kAYDelegatesSendMessage(@"ServicePage", kAYDelegateChangeDataMessage, &tmp)
		
	} else {
		
//		AYServicePageBtmView *btmView = [[AYServicePageBtmView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kBtmViewHeight-HOME_IND_HEIGHT, SCREEN_WIDTH, kBtmViewHeight)];
//		[self.view addSubview:btmView];
//		[self.view bringSubviewToFront:btmView];
//		[btmView.bookBtn addTarget:self action:@selector(didBookBtnClick) forControlEvents:UIControlEventTouchUpInside];
//		[btmView.chatBtn addTarget:self action:@selector(didChatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		NSDictionary* user = nil;
		CURRENUSER(user);
		NSMutableDictionary *dic_detail = [Tools getBaseRemoteData:user];
		[[dic_detail objectForKey:kAYCommArgsCondition] setValue:service_id forKey:kAYServiceArgsID];
		[[dic_detail objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
		
		id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
		AYRemoteCallCommand* cmd_search = [f_search.commands objectForKey:@"QueryServiceDetail"];
		[[AYRemoteCallManager shared] performWithRemoteCmd:cmd_search andArgs:[dic_detail copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
//		[cmd_search performWithResult:[dic_detail copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
			if(success) {
				
				NSMutableDictionary *tmp_args = [[result objectForKey:@"service"] mutableCopy];
				id<AYFacadeBase> facade = [self.facades objectForKey:@"Timemanagement"];
				id<AYCommand> cmd = [facade.commands objectForKey:@"ParseServiceTMProtocol"];
				id args = [tmp_args objectForKey:@"tms"];
				[cmd performWithResult:&args];
				
				offer_date_mutable = [args mutableCopy];
				[offer_date_mutable enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
					NSArray *occurance = [obj objectForKey:kAYServiceArgsOccurance];
					[occurance enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
						[obj setValue:[NSNumber numberWithBool:NO] forKey:@"is_selected"];
					}];
				}];
				
				[tmp_args setValue:[args copy] forKey:kAYServiceArgsOfferDate];
				service_info = tmp_args;
				
//				[btmView setViewWithData:service_info];
				[self layoutServicePageBannerImages];

				NSDictionary *tmp = [service_info copy];
				kAYDelegatesSendMessage(@"ServicePage", kAYDelegateChangeDataMessage, &tmp)
				kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
				
			} else {
				AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
			}
		}];
		
	}
	
	/***************************************/
    id<AYViewBase> navBar = [self.views objectForKey:@"FakeNavBar"];
	id<AYViewBase> statusBar = [self.views objectForKey:@"FakeStatusBar"];
    [self.view bringSubviewToFront:(UIView*)navBar];
	[self.view bringSubviewToFront:(UIView*)statusBar];
    ((UIView*)navBar).backgroundColor = ((UIView*)statusBar).backgroundColor = [UIColor colorWithWhite:1.f alpha:0.f];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

#pragma mark -- layouts
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
//    UIImage* left = IMGRESOURCE(@"detail_icon_back_white");
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	bar_back_btn = [[UIButton alloc]init];
	[bar_back_btn setImage:IMGRESOURCE(@"detail_icon_back_white") forState:UIControlStateNormal];
	[bar_back_btn setImage:IMGRESOURCE(@"detail_icon_back_black") forState:UIControlStateSelected];
	[bar_back_btn addTarget:self action:@selector(leftBtnSelected) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:bar_back_btn];
	[bar_back_btn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(view).offset(-5);
		make.top.equalTo(view).offset(6);
		make.size.mas_equalTo(CGSizeMake(36, 36));
	}];
	
    id hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &hidden)
	hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnVisibilityMessage, &hidden)
	
    bar_like_btn = [[UIButton alloc]init];
    [bar_like_btn setImage:IMGRESOURCE(@"home_icon_love_normal") forState:UIControlStateNormal];
    [bar_like_btn setImage:IMGRESOURCE(@"home_icon_love_select") forState:UIControlStateSelected];
	[bar_like_btn setImage:IMGRESOURCE(@"home_icon_love_black") forState:UIControlStateHighlighted];
    [bar_like_btn addTarget:self action:@selector(didCollectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bar_like_btn];
    [bar_like_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-8);
        make.top.equalTo(view).offset(7);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
	
    return nil;
}

- (id)TableLayout:(UIView*)view {
//	NSNumber *per_mode = [receiveData objectForKey:@"perview_mode"];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT /*- (per_mode ? 0 : kBtmViewHeight) - HOME_IND_HEIGHT*/);
    
    ((UITableView*)view).contentInset = UIEdgeInsetsMake(kFlexibleHeight, 0, 0, 0);
    ((UITableView*)view).estimatedRowHeight = kFlexibleHeight;
    ((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
    return nil;
}

#pragma mark -- notifies
- (id)leftBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	if (isChangeCollect) {
		NSDictionary *back_args = @{kAYServiceArgsInfo:service_info, kAYServiceArgsIsCollect:[NSNumber numberWithBool:bar_like_btn.selected], kAYVCBackArgsKey:kAYVCBackArgsKeyCollectChange};
		[dic setValue:back_args forKey:kAYControllerChangeArgsKey];
	}
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
    return nil;
}

- (id)sendPopMessage {
    [self leftBtnSelected];
    return nil;
}

- (id)scrollOffsetY:(NSNumber*)y {
	
    id<AYViewBase> navBar = [self.views objectForKey:@"FakeNavBar"];
	id<AYViewBase> statusBar = [self.views objectForKey:@"FakeStatusBar"];
	
	offset_y = y.floatValue;
	CGFloat alp = (kStatusAndNavBarH*2 + offset_y) / (kStatusAndNavBarH);
	if (alp > 0.5 && !isBlackLeftBtn) {
		bar_back_btn.selected = YES;
		if (!bar_like_btn.selected) {
			bar_like_btn.highlighted = YES;
		}
		
		isBlackLeftBtn = YES;
		NSString *titleStr = @"服务详情";
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &titleStr)
		isStatusHide = NO;
		[self setNeedsStatusBarAppearanceUpdate];
		
	} else if (alp <=  0.5 && isBlackLeftBtn) {
		bar_back_btn.selected = NO;
		if (!bar_like_btn.selected) {
			bar_like_btn.highlighted = NO;
		}
		
		isBlackLeftBtn = NO;
		NSString *titleStr = @"";
		kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &titleStr)
		isStatusHide = YES;
		[self setNeedsStatusBarAppearanceUpdate];
	}
	alp = alp > 1 ? 1 :alp;
	alp = alp < 0 ? 0 :alp;
	
	((UIView*)navBar).backgroundColor = ((UIView*)statusBar).backgroundColor = [UIColor colorWithRED:250 GREEN:250 BLUE:250 ALPHA:alp];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarHideBarBotLineMessage, nil)
//	if (offset_y < - kStatusAndNavBarH * 2) {
//		((UIView*)navBar).backgroundColor = ((UIView*)statusBar).backgroundColor = [UIColor colorWithWhite:1.f alpha:0.f];
//	}
//	else if ( offset_y >= -kStatusAndNavBarH * 2) { //偏移的绝对值 小于 abs(-64)
//
//	}
	
    CGFloat offsetH = kFlexibleHeight + offset_y;
    if (offsetH < 0) {
        id<AYViewBase> view_notify = [self.views objectForKey:@"Table"];
		UITableView *tableView = (UITableView*)view_notify;
		HeadViewHeight = kFlexibleHeight - offsetH;
        [flexibleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(tableView);
            make.top.equalTo(tableView).offset(-kFlexibleHeight + offsetH);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, HeadViewHeight));
        }];
		CarouselView.frame = CGRectMake(0, 0, SCREEN_WIDTH, HeadViewHeight);
		[CarouselView reloadData];
    }
	
    return nil;
}

- (id)showP2PMap {
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServiceMap");
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
	[dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *dic_p2p = [[NSMutableDictionary alloc]init];
	[dic_p2p setValue:[service_info copy] forKey:kAYServiceArgsInfo];
//	dic_p2p [setValue: forKey:@"self"];
	[dic setValue:[dic_p2p copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = SHOWMODULEUP;
	[cmd_show_module performWithResult:&dic];
	return nil;
}

- (id)showOwnerInfo {
    
    id<AYCommand> des = DEFAULTCONTROLLER(@"OneProfile");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionShowModuleUpValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:[service_info objectForKey:kAYBrandArgsSelf] forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = SHOWMODULEUP;
    [cmd_show_module performWithResult:&dic];
    return nil;
}

- (id)showServiceOfferDate {
	
    id<AYCommand> dest = DEFAULTCONTROLLER(@"BOrderTime");
    NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
	[tmp setValue:service_info forKey:kAYServiceArgsInfo];
	[tmp setValue:offer_date_mutable forKey:kAYServiceArgsOfferDate];
    [dic_push setValue:tmp forKey:kAYControllerChangeArgsKey];
	
    id<AYCommand> cmd_push = PUSH;
    [cmd_push performWithResult:&dic_push];
    return nil;
}

- (id)showHideDescDetail:(NSNumber*)args {
	
	UITableView *table = [self.views objectForKey:@"Table"];
//	[table beginUpdates];
	kAYDelegatesSendMessage(@"ServicePage", @"TransfromExpend:", &args)
	[table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//	[table endUpdates];
    return nil;
}

#pragma mark -- actions
- (void)layoutServicePageBannerImages {
	NSArray *images_service = [service_info objectForKey:kAYServiceArgsImages];
	NSArray *images_location = [[service_info objectForKey:kAYServiceArgsLocationInfo] objectForKey:@"location_images"];
	
	NSMutableArray *tmp_images = [images_service mutableCopy];
	for (NSMutableDictionary *info_img in tmp_images) {
		[info_img setValue:@"时刻" forKey:@"tag"];
	}
	[tmp_images addObjectsFromArray:images_location];
	serviceImages = [tmp_images copy];
	
	NSMutableArray *tagsArr = [NSMutableArray array];
	for (NSDictionary *info_img in serviceImages) {
		NSString *img_tag = [info_img objectForKey:@"tag"];
		if (![tagsArr containsObject:img_tag]) {
			[tagsArr addObject:img_tag];
		}
	}
	
	CGFloat itemHeight = 30;
	CGFloat marginBetween = 20;
	CGFloat padding = 15;
	CGFloat preMaxX = 0;
	imageTagsView = [NSMutableArray array];
	for (int i = 0; i < tagsArr.count; ++i) {
		
		NSString *title = [tagsArr objectAtIndex:i];
		CGSize labelSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
		CGRect frame = CGRectMake( i==0 ? 0 : marginBetween + preMaxX, 0, labelSize.width+padding*2, itemHeight);
		
		AYImageTagView *item = [[AYImageTagView alloc] initWithFrame:frame title:title];
		[TAGScrollView addSubview:item];
		
		preMaxX = item.frame.origin.x + item.frame.size.width;
		
		item.userInteractionEnabled = YES;
		[item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didImageTagTap:)]];
		
		[imageTagsView addObject:item];
	}
	TAGScrollView.contentSize = CGSizeMake(preMaxX, 30);
	
	tmpImageTag = imageTagsView.firstObject;
	tmpImageTag.isSelect = YES;
	
	NSNumber *iscollect = [service_info objectForKey:kAYServiceArgsIsCollect];
	bar_like_btn.selected = iscollect.boolValue;
	
	[CarouselView reloadData];
}

- (void)didImageTagTap:(UITapGestureRecognizer*)tap {
	UIView *item = tap.view;
	//正则匹配
	NSPredicate *pred_tag = [NSPredicate predicateWithFormat:@"SELF.%@=%@", @"tag", ((AYImageTagView*)item).label.text];
	NSArray *result = [serviceImages filteredArrayUsingPredicate:pred_tag];
	
	if (result.count != 0) {
		int index = (int)[serviceImages indexOfObject:result.firstObject];
		[CarouselView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
	}
}

- (void)didBookBtnClick {
	if ([self isOwnerUserSelf]) {
		return;
	}
	[self showServiceOfferDate];
}

- (BOOL)isOwnerUserSelf {
	NSDictionary* user = nil;
	CURRENUSER(user);
	
	NSString *user_id = [user objectForKey:@"user_id"];
	NSString *owner_id = [[service_info objectForKey:@"owner"] objectForKey:kAYCommArgsUserID];
	if ([user_id isEqualToString:owner_id]) {
		NSString *title = @"该服务是您自己发布";
		AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		return YES;
	} else
		return NO;
}

- (void)didChatBtnClick:(UIButton*)btn {
	if ([self isOwnerUserSelf]) {
		return;
	}
	
	NSDictionary* user = nil;
	CURRENUSER(user);
	NSString *user_id = [user objectForKey:@"user_id"];
	NSString *owner_id = [[service_info objectForKey:@"owner"] objectForKey:kAYCommArgsUserID];
	
    id<AYCommand> des = DEFAULTCONTROLLER(@"SingleChat");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:des forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
	NSMutableDictionary *dic_chat = [[NSMutableDictionary alloc]init];
	[dic_chat setValue:user_id forKey:@"user_id"];
	[dic_chat setValue:owner_id forKey:@"owner_id"];
    
    [dic setValue:dic_chat forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd_show_module = PUSH;
    [cmd_show_module performWithResult:&dic];
    
}

-(void)didCollectionBtnClick:(UIButton*)btn{
	NSDictionary *user = nil;
	CURRENUSER(user);
	NSMutableDictionary *dic = [Tools getBaseRemoteData];
	
	NSMutableDictionary *dic_collect = [[NSMutableDictionary alloc] init];
	[dic_collect setValue:[service_info objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	[dic_collect setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic setValue:dic_collect forKey:@"collections"];
	
	NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] initWithDictionary:dic_collect];
	[dic setValue:dic_condt forKey:kAYCommArgsCondition];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
    if (!bar_like_btn.selected) {
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"CollectService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
				isChangeCollect = YES;
                bar_like_btn.selected = YES;
				[service_info setValue:[NSNumber numberWithBool:YES] forKey:kAYServiceArgsIsCollect];
            } else {
                NSString *title = @"收藏失败!请检查网络链接是否正常";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }];
    }
	else {
        AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"UnCollectService"];
        [cmd_push performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
            if (success) {
				isChangeCollect = YES;
                bar_like_btn.selected = NO;
				[service_info setValue:[NSNumber numberWithBool:NO] forKey:kAYServiceArgsIsCollect];
            } else {
                NSString *title = @"取消收藏失败!请检查网络链接是否正常";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }];
    }
}

- (BOOL)prefersStatusBarHidden {
	return isStatusHide;
}

//- (BOOL)prefersStatusBarHidden{
//	return YES;
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleDefault;
}

@end
