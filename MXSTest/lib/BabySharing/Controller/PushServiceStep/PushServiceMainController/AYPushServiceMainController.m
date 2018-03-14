//
//  AYPushServiceMainController.m
//  BabySharing
//
//  Created by Alfred Yang on 15/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYPushServiceMainController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"

#import "AYMainServInfoView.h"

#define STATUS_BAR_HEIGHT           20
#define FAKE_BAR_HEIGHT             44
#define kTOPHEIGHT					166
#define kBOTTOMHEIGHT				85
#define kBETWEENMARGIN				16

@implementation AYPushServiceMainController {
	NSMutableDictionary *push_service_info;
	
	AYMainServInfoView *basicSubView;
	AYMainServInfoView *locationSubView;
	AYMainServInfoView *capacitySubView;
	AYMainServInfoView *TMsSubView;
	AYMainServInfoView *noticeSubView;
	
	AYMainServInfoView *priceSubView;
	UIView *pushBtnBG;
	UIButton *pushBtn;
	UILabel *pushBtnTitle;
	CAGradientLayer *ableGradi;
	CAGradientLayer *unAbleGradi;
	
	NSArray *locationKeyArr;
	NSArray *detailKeyArr;
	NSArray *rootKeyArr;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		push_service_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		id back_args = [dic objectForKey:kAYControllerChangeArgsKey];
		if ([back_args isKindOfClass:[NSDictionary class]]) {
			
			for (NSString *key in [back_args allKeys]) {
				[self encodeServiceInfoWithArgs:[back_args objectForKey:key] andKey:key];
			}
			
			NSString *note_key = [back_args objectForKey:@"key"];
			if ([note_key isEqualToString:@"part_basic"]) {
				basicSubView.isReady = [[back_args objectForKey:kAYServiceArgsImages] count] != 0 && [[back_args objectForKey:kAYServiceArgsDescription] length] != 0 && [[back_args objectForKey:kAYServiceArgsCharact] count] != 0;
				
				UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"预览" titleColor:[Tools theme] fontSize:616.f backgroundColor:nil];
				kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
				
			}
			else if ([note_key isEqualToString:@"part_capacity"]) {
				capacitySubView.isReady = [back_args objectForKey:kAYServiceArgsAgeBoundary] && [back_args objectForKey:kAYServiceArgsCapacity] && [back_args objectForKey:kAYServiceArgsServantNumb];
			}
			else if ([note_key isEqualToString:@"part_notice"]) {
				noticeSubView.isReady = [back_args objectForKey:kAYServiceArgsAllowLeave] && [back_args objectForKey:kAYServiceArgsIsHealth];
			}
			else if ([note_key isEqualToString:@"part_location"]) {
				
				locationSubView.isReady = [back_args objectForKey:kAYServiceArgsAddress] && [back_args objectForKey:kAYServiceArgsAdjustAddress] && [back_args objectForKey:kAYServiceArgsPin] && [back_args objectForKey:kAYServiceArgsDistrict] && [[back_args objectForKey:kAYServiceArgsFacility] count] != 0 && [back_args objectForKey:kAYServiceArgsYardType] && [[back_args objectForKey:kAYServiceArgsYardImages] count] != 0;
			}
			else if ([note_key isEqualToString:@"part_price"]) {
				priceSubView.isReady = [[back_args objectForKey:kAYServiceArgsPriceArr] count] != 0;
			}
			else if ([note_key isEqualToString:@"part_tms"]) {
				TMsSubView.isReady = YES;
			}
			
			[self isAllArgsReady];
		}
	}
}

- (void)isAllArgsReady {
		
	if (basicSubView.isReady && locationSubView.isReady && capacitySubView.isReady && TMsSubView.isReady && noticeSubView.isReady) {
		pushBtn.enabled = YES;
		pushBtnBG.layer.shadowColor = [Tools theme].CGColor;
		[unAbleGradi removeFromSuperlayer];
		[pushBtn.layer addSublayer:ableGradi];
		pushBtnTitle.text = @"发布服务";
	} else {
		pushBtn.enabled = NO;
		pushBtnBG.layer.shadowColor = [Tools garyColor].CGColor;
		[ableGradi removeFromSuperlayer];
		[pushBtn.layer addSublayer:unAbleGradi];
		pushBtnTitle.text = @"准备发布";
	}
}

- (void)encodeServiceInfoWithArgs:(id)args andKey:(NSString*)key {
	//root
	if ([rootKeyArr containsObject:key]) {
		[push_service_info setValue:args forKey:key];
	}
	//detail
	else if ([detailKeyArr containsObject:key]) {
		[[push_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:args forKey:key];
	}
	//location
	else if ([locationKeyArr containsObject:key]) {
		[[push_service_info objectForKey:kAYServiceArgsLocationInfo] setValue:args forKey:key];
	}
	else {
		
	}
}

- (void)enCoderWithData:(id)data ForKey:(NSString*)key andSubKey:(NSString*)subKey {
	if (subKey) {
		[[push_service_info objectForKey:subKey] setValue:data forKey:key];
	} else {
		[push_service_info setValue:data forKey:key];
	}
}

#pragma mark -- life cycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGFloat margin = 20.f;
	[push_service_info setValue:[[NSMutableDictionary alloc] init] forKey:kAYServiceArgsDetailInfo];
	
	locationKeyArr = @[kAYServiceArgsDistrict, kAYServiceArgsAddress, kAYServiceArgsAdjustAddress, kAYServiceArgsPin, kAYServiceArgsYardType, kAYServiceArgsYardImages];
	detailKeyArr = @[kAYServiceArgsAgeBoundary, kAYServiceArgsCapacity, kAYServiceArgsFacility, kAYServiceArgsServantNumb, kAYServiceArgsPriceArr, kAYServiceArgsClassCount, kAYServiceArgsAllowLeave, kAYServiceArgsLeastHours, kAYServiceArgsLeastTimes, kAYServiceArgsCourseduration, kAYServiceArgsNotice, kAYServiceArgsIsHealth, kAYServiceArgsCharact];
	rootKeyArr = @[kAYServiceArgsImages, kAYServiceArgsTitle, kAYProfileArgsDescription, kAYTimeManagerArgsTMs];
	
	UIView *sloganShadow = [[UIView alloc] initWithFrame:CGRectMake(margin, 80, SCREEN_WIDTH - margin*2, 86)];
	sloganShadow.layer.cornerRadius = 4.f;
	sloganShadow.layer.shadowColor = [Tools garyColor].CGColor;
	sloganShadow.layer.shadowRadius = 4.f;
	sloganShadow.layer.shadowOpacity = 0.5f;
	sloganShadow.layer.shadowOffset = CGSizeMake(0, 0);
	[self.view addSubview:sloganShadow];
	sloganShadow.backgroundColor = [Tools whiteColor];
	
	UIView *sloganView = [[UIView alloc] initWithFrame:sloganShadow.frame];
	[self.view addSubview:sloganView];
	[Tools setViewBorder:sloganView withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
	
	UILabel *titleLabel = [Tools creatLabelWithText:@"Servant' Servcie" textColor:[Tools black] fontSize:617 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[sloganView addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(sloganView).offset(kBETWEENMARGIN);
//		make.left.equalTo(sloganView).offset(kBETWEENMARGIN);
		make.centerX.equalTo(sloganView);
	}];
	
	UILabel *sloganLabel = [Tools creatLabelWithText:@"Servant' Servcie" textColor:[Tools black] fontSize:313 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[sloganView addSubview:sloganLabel];
	[sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(sloganView).offset(-kBETWEENMARGIN);
//		make.left.equalTo(sloganView).offset(kBETWEENMARGIN);
		make.centerX.equalTo(sloganView);
	}];
	
	NSDictionary *profile;
	CURRENPROFILE(profile);
	NSString *name = [profile objectForKey:kAYProfileArgsScreenName];
	
	NSDictionary *info_categ = [push_service_info objectForKey:kAYServiceArgsCategoryInfo];
	NSString *cat = [info_categ objectForKey:kAYServiceArgsCat];
	NSString *titleStr;
	if ([cat isEqualToString:kAYStringNursery]) {
		NSString *cat_secondary = [info_categ objectForKey:kAYServiceArgsCatSecondary];
		titleStr = [NSString stringWithFormat:@"%@的%@",name, cat_secondary];
	} else if([cat isEqualToString:kAYStringCourse]){
		NSString *cat_thirdly = [info_categ objectForKey:kAYServiceArgsCourseCoustom];
		if (cat_thirdly.length == 0) {
			cat_thirdly = [info_categ objectForKey:kAYServiceArgsCatThirdly];
		}
		titleStr = [NSString stringWithFormat:@"%@的%@%@",name, cat_thirdly, cat];
	}
	titleLabel.text = titleStr;
	NSString *sloganStr = [push_service_info objectForKey:kAYServiceArgsTitle];
	sloganLabel.text = sloganStr;
	
	/****************************************************************/
	CGFloat subOrigX = kTOPHEIGHT + kBETWEENMARGIN;
	CGFloat remainHeight = SCREEN_HEIGHT - kTOPHEIGHT - kBOTTOMHEIGHT;
	CGFloat leftHeight = (remainHeight - kBETWEENMARGIN * 3) *0.5;
	CGFloat rightHeight = (remainHeight - kBETWEENMARGIN * 4) / 3;
	CGFloat sameWidth = (SCREEN_WIDTH - margin*2 - kBETWEENMARGIN) * 0.5;
	CGFloat rightX = margin + sameWidth + kBETWEENMARGIN;
	
	basicSubView = [[AYMainServInfoView alloc] initWithFrame:CGRectMake(margin, subOrigX, sameWidth, leftHeight) andTitle:@"服务基本信息" andTapBlock:^{
		
		[self pushDestControllerWithName:@"SetBasicInfo"];
	}];
	[self.view addSubview:basicSubView];
	
	locationSubView = [[AYMainServInfoView alloc] initWithFrame:CGRectMake(margin, subOrigX+kBETWEENMARGIN+leftHeight, sameWidth, leftHeight) andTitle:@"场地" andTapBlock:^{
		[self pushDestControllerWithName:@"SetLocationInfo"];
	}];
	[self.view addSubview:locationSubView];
	
	capacitySubView = [[AYMainServInfoView alloc] initWithFrame:CGRectMake(rightX, subOrigX, sameWidth, rightHeight) andTitle:@"师生设定" andTapBlock:^{
		[self pushDestControllerWithName:@"SetServiceCapacity"];
	}];
	[self.view addSubview:capacitySubView];
	
	TMsSubView = [[AYMainServInfoView alloc] initWithFrame:CGRectMake(rightX, subOrigX+rightHeight+kBETWEENMARGIN, sameWidth, rightHeight) andTitle:@"服务时间" andTapBlock:^{
		
		[self pushDestControllerWithName:@"SetNapSchedule"];
//		pushBtn.enabled = NO;
//		pushBtnBG.layer.shadowColor = [Tools garyColor].CGColor;
//		[ableGradi removeFromSuperlayer];
//		[pushBtn.layer addSublayer:unAbleGradi];
//		pushBtnTitle.text = @"准备发布";
	}];
	[self.view addSubview:TMsSubView];
	
	noticeSubView = [[AYMainServInfoView alloc] initWithFrame:CGRectMake(rightX, subOrigX+(rightHeight+kBETWEENMARGIN)*2, sameWidth, rightHeight) andTitle:@"服务守则" andTapBlock:^{
		[self pushDestControllerWithName:@"SetServiceNotice"];
	}];
	[self.view addSubview:noticeSubView];
	
	
	/****************************************************************/
	
	
	UIView *partBtmView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kBOTTOMHEIGHT, SCREEN_WIDTH, kBOTTOMHEIGHT)];
	[self.view addSubview:partBtmView];
	[Tools creatCALayerWithFrame:CGRectMake(margin, 0, SCREEN_WIDTH - margin*2, 0.5) andColor:[Tools garyLineColor] inSuperView:partBtmView];
	
	CGFloat priceViewWidth = (SCREEN_WIDTH - 40 - kBETWEENMARGIN) * 0.5;
	priceSubView = [[AYMainServInfoView alloc] initWithFrame:CGRectMake(margin, kBETWEENMARGIN, priceViewWidth, 49) andTitle:@"价格" andTapBlock:^{
		
		[self pushDestControllerWithName:@"SetServicePrice"];
//		pushBtn.enabled = YES;
//		pushBtnBG.layer.shadowColor = [Tools themeColor].CGColor;
//		[unAbleGradi removeFromSuperlayer];
//		[pushBtn.layer addSublayer:ableGradi];
//		pushBtnTitle.text = @"发布服务";
	}];
	[partBtmView addSubview:priceSubView];
//	[priceSubView hideCheckSign];
	
	pushBtnBG = [[UIView alloc] initWithFrame:CGRectMake(margin+kBETWEENMARGIN+priceViewWidth, kBETWEENMARGIN, priceViewWidth, 49)];
	[partBtmView addSubview:pushBtnBG];
	pushBtnBG.layer.cornerRadius = 4.f;
	pushBtnBG.layer.shadowColor = [Tools garyColor].CGColor;
	pushBtnBG.layer.shadowRadius = 4.f;
	pushBtnBG.layer.shadowOpacity = 0.5f;
	pushBtnBG.layer.shadowOffset = CGSizeMake(0, 2);
	pushBtnBG.backgroundColor = [Tools whiteColor];
	
	pushBtn = [[UIButton alloc] init]; //362  142
//	UIButton *pushBtn = [Tools creatUIButtonWithTitle:@"PUSH" andTitleColor:[Tools whiteColor] andFontSize:617 andBackgroundColor:nil]; //362  142
//	[pushBtn setImage:IMGRESOURCE(@"icon_btn_pushservice") forState:UIControlStateNormal];
//	[pushBtn setImage:IMGRESOURCE(@"icon_btn_pushservice_disable") forState:UIControlStateDisabled];
	[Tools setViewBorder:pushBtn withRadius:4.f andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
	[pushBtn setTitle:@"发布服务" forState:UIControlStateNormal];
	[pushBtn setTitle:@"准备发布" forState:UIControlStateDisabled];
	pushBtn.titleLabel.font = kAYFontMedium(17);
	[pushBtn setTitleColor:[Tools whiteColor] forState:UIControlStateNormal];
	[pushBtn setTitleColor:[Tools whiteColor] forState:UIControlStateDisabled];
	[partBtmView addSubview:pushBtn];
	[pushBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(pushBtnBG);
	}];
	pushBtn.enabled = NO;
	[pushBtn addTarget:self action:@selector(didPushBtnClick) forControlEvents:UIControlEventTouchUpInside];
	
	pushBtnTitle = [Tools creatLabelWithText:@"准备发布" textColor:[Tools whiteColor] fontSize:617 backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[self.view addSubview:pushBtnTitle];
	[pushBtnTitle mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(pushBtn);
	}];
	[self.view bringSubviewToFront:pushBtnTitle];
	
	ableGradi = [CAGradientLayer layer];
	unAbleGradi = [CAGradientLayer layer];
	ableGradi.frame = unAbleGradi.frame = pushBtnBG.bounds;
	
	[pushBtn.layer addSublayer:unAbleGradi];
	
	ableGradi.startPoint = unAbleGradi.startPoint = CGPointMake(0, 0);
	ableGradi.endPoint = unAbleGradi.endPoint = CGPointMake(0, 1);
	
	ableGradi.colors = @[(__bridge id)[Tools colorWithRED:146 GREEN:236 BLUE:229 ALPHA:1].CGColor,
						(__bridge id)[Tools colorWithRED:89 GREEN:213 BLUE:199 ALPHA:1].CGColor];
	unAbleGradi.colors = @[(__bridge id)[Tools colorWithRED:223 GREEN:250 BLUE:248 ALPHA:1].CGColor,
						   (__bridge id)[Tools colorWithRED:205 GREEN:243 BLUE:239 ALPHA:1].CGColor];
	//设置颜色分割点（范围：0-1）
	ableGradi.locations = unAbleGradi.locations = @[@(0.1f), @(0.9f)];
	
	UIView *loadingView = [self.views objectForKey:kValidatingView];
	[self.view bringSubviewToFront:loadingView];
}

- (void)pushDestControllerWithName:(NSString*)dest {
	
	id<AYCommand> des = DEFAULTCONTROLLER(dest);
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc]initWithCapacity:4];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic_push setValue:push_service_info forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
	view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
	return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
	
	UIImage* left = IMGRESOURCE(@"bar_left_black");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"预览" titleColor:[Tools theme] fontSize:616.f backgroundColor:nil];
//	UIButton* bar_right_btn = [Tools creatUIButtonWithTitle:@"预览" andTitleColor:[Tools garyColor] andFontSize:616.f andBackgroundColor:nil];
//	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
//	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)ValidatingLayout:(UIView*)view {
	NSString *tip = @"服务发布中";
	kAYViewsSendMessage(kValidatingView, @"setTipContext:", &tip)
	return nil;
}

#pragma mark -- UITextDelegate


#pragma mark -- actions
- (id)startRemoteCall:(id)obj {
	return nil;
}
- (id)endRemoteCall:(id)ob {
	return nil;
}

- (void)didPushBtnClick {
	
	kAYViewsSendMessage(kValidatingView, @"showValidatingViewWithAnimate", nil);
//	[NSThread sleepForTimeInterval:1];
	
	NSDictionary *args = [push_service_info objectForKey:kAYServiceArgsTimes];
	id<AYFacadeBase> facade_tm = DEFAULTFACADE(@"Timemanagement");
	id<AYCommand> cmd_tm = [facade_tm.commands objectForKey:@"PushServiceTM"];
	[cmd_tm performWithResult:&args];
	[push_service_info setValue:(NSArray*)args forKey:kAYServiceArgsTimes];
	
	NSArray *napPhotos = [push_service_info objectForKey:kAYServiceArgsImages];
	NSMutableArray *loc_images = [[push_service_info objectForKey:kAYServiceArgsLocationInfo] objectForKey:kAYServiceArgsYardImages];
	NSMutableArray *images_arr = [NSMutableArray array];
	for (NSDictionary *info_img in loc_images) {
		[images_arr addObject:[info_img objectForKey:kAYServiceArgsPic]];
	}

	NSMutableDictionary *dic_upload = [[NSMutableDictionary alloc] init];
	[dic_upload setValue:napPhotos forKey:kAYServiceArgsImages];
	[dic_upload setValue:images_arr forKey:kAYServiceArgsYardImages];

	AYRemoteCallCommand* cmd_upload = MODULE(@"PostPhotos");
	[cmd_upload performWithResult:[dic_upload copy] andFinishBlack:^(BOOL success, NSDictionary *result) {

		if (success) {
			NSDictionary* user = nil;
			CURRENUSER(user)

			NSArray *img_name_arr = [result objectForKey:kAYServiceArgsYardImages];
			for (int i = 0; i < img_name_arr.count; ++i) {
				[[loc_images objectAtIndex:i] setValue:[img_name_arr objectAtIndex:i] forKey:kAYServiceArgsPic];
			}
//			[[push_service_info objectForKey:kAYServiceArgsLocationInfo] setValue: forKey:kAYServiceArgsYardImages];
			[push_service_info setValue:[result objectForKey:kAYServiceArgsImages] forKey:kAYServiceArgsImages];

			NSMutableDictionary *dic_push = [[NSMutableDictionary alloc] init];
			[dic_push setValue:[user objectForKey:kAYCommArgsToken] forKey:kAYCommArgsToken];

			NSDictionary *dic_condt = @{kAYCommArgsUserID:[user objectForKey:kAYCommArgsUserID]};
			[dic_push setValue:dic_condt forKey:kAYCommArgsCondition];

			[push_service_info setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsOwnerID];
			[dic_push setValue:push_service_info forKey:kAYServiceArgsSelf];
			NSLog(@"kidpan/push-%@", dic_push);

			id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
			AYRemoteCallCommand *cmd_push = [facade.commands objectForKey:@"PushServiceInfo"];
			[cmd_push performWithResult:[dic_push copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
				if (success) {
					
					NSString *tip = @"服务发布成功";
					kAYViewsSendMessage(kValidatingView, @"changeStatusWithSuccessTip:", &tip);
					dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
						
						DongDaAppMode mode = [[[NSUserDefaults standardUserDefaults] valueForKey:kAYDongDaAppMode] intValue];
						if (mode == DongDaAppModeServant) {
							[super tabBarVCSelectIndex:2];
						} else {
							id<AYCommand> des = DEFAULTCONTROLLER(@"TabBarService");
							[self exchangeWindowsWithDest:des];
						}
					});

				} else {

					kAYViewsSendMessage(kValidatingView, @"hideValidatingView", nil);
					NSString *title = @"服务上传失败,网络不通畅，换个地方试试";
					AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
				}
			}];
		} else {
			kAYViewsSendMessage(kValidatingView, @"hideValidatingView", nil);
			NSString *title = @"图片上传失败,网络不通畅，换个地方试试";
			AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
		}
	}];
	
}

- (void)exchangeWindowsWithDest:(id)dest {
	AYViewController *des = dest;
	NSMutableDictionary* dic_show_module = [[NSMutableDictionary alloc] init];
	[dic_show_module setValue:kAYControllerActionExchangeWindowsModuleValue forKey:kAYControllerActionKey];
	[dic_show_module setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_show_module setValue:self.tabBarController forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *dic_exchange = [[NSMutableDictionary alloc]init];
	[dic_exchange setValue:[NSNumber numberWithInteger:2] forKey:@"index"];
	[dic_exchange setValue:[NSNumber numberWithInteger:ModeExchangeTypeUnloginToAllModel] forKey:@"type"];
	[dic_show_module setValue:dic_exchange forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = EXCHANGEWINDOWS;
	[cmd_show_module performWithResult:&dic_show_module];
	
}

#pragma mark -- notification
- (id)leftBtnSelected {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"返回即退出本次发布，请确认放弃本次发布？" preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
	UIAlertAction *certain = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		
//		NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
//		[dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
//		[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
//
//		id<AYCommand> cmd = POPTOROOT;
//		[cmd performWithResult:&dic];
		[self.navigationController popToRootViewControllerAnimated:NO];
	}];
	[alert addAction:cancel];
	[alert addAction:certain];
	[self presentViewController:alert animated:YES completion:nil];
	return nil;
}

- (id)rightBtnSelected {
	
	id<AYCommand> des = DEFAULTCONTROLLER(@"ServicePage");
	NSMutableDictionary* dic_args = [[NSMutableDictionary alloc]init];
	[dic_args setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_args setValue:des forKey:kAYControllerActionDestinationControllerKey];
	[dic_args setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *tmp;
	if (push_service_info) {
		tmp = [[NSMutableDictionary alloc] initWithDictionary:push_service_info];
	}
	
	[tmp setValue:[NSNumber numberWithInt:1] forKey:@"perview_mode"];
	[dic_args setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic_args];
	
	return nil;
}

@end
