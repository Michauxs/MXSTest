//
//  AYMainInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 19/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYMainInfoController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"
#import "TmpFileStorageModel.h"
#import <CoreLocation/CoreLocation.h>

#define STATUS_BAR_HEIGHT						20
#define FAKE_BAR_HEIGHT							44
#define requiredInfoNumb						5

#define becomeNapNormalModelFitHeight			(64 + 49)
#define becomeNapAllreadyModelFitHeight			(64 + 49 + 44)
#define servInfoNormalModelFitHeight			(64)
#define servInfoChangedModelFitHeight			(64 + 44)
#define napPushServNormalModelFitHeight			(64 + 44)
#define napPushServAllreadyModelFitHeight		(64 + 44)

typedef void(^asynUploadImages)(BOOL, NSDictionary*);

@implementation AYMainInfoController {
    
    NSArray *napPhotos;
	
    NSMutableDictionary *push_service_info;
    NSMutableDictionary *update_service_info;
	NSMutableDictionary *show_service_info;
	
    NSMutableDictionary* dic_push_photos;
	UIButton *confirmSerBtn;
	
    BOOL isChangeServiceInfo;
	
	//handle
	NSMutableArray *handleIsCompileArgs;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    
	NSDictionary* dic = (NSDictionary*)*obj;
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        id push_args = [dic objectForKey:kAYControllerChangeArgsKey];
        if ([push_args objectForKey:@"push"]) {
			push_service_info = [push_args mutableCopy];
        } else {
			show_service_info = [push_args mutableCopy];
        }
		
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
        
    } else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		id dic_info = [dic objectForKey:kAYControllerChangeArgsKey];
		if (![dic_info isKindOfClass:[NSDictionary class]]) {
			return;
		}
		id key = [dic_info objectForKey:@"key"];
		
        if (key && [key isKindOfClass:[NSString class]]) {
            if ([key isEqualToString:kAYServiceArgsInfo]) {			//-1
                show_service_info = [dic_info objectForKey:kAYServiceArgsInfo];
            }
            else if ([key isEqualToString:@"nap_cover"]) {			//0
				napPhotos = [dic_info objectForKey:@"content"];
				[push_service_info setValue:[napPhotos copy] forKey:kAYServiceArgsImages];
                [handleIsCompileArgs replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:YES]];
            }
            else if([key isEqualToString:kAYServiceArgsTitle]) {	//1
                
                NSString *title = [dic_info objectForKey:key];
                //title constain and course_sign or coustom constain and or service_cat == 0
				if(title && ![title isEqualToString:@""]) {
					[self aCoderWithData:title ForKey:kAYServiceArgsTitle andSubKey:nil];
                    [handleIsCompileArgs replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:YES]];
                }
                
            }
            else if([key isEqualToString:kAYServiceArgsDescription]) {			//2
                NSString *napDesc = [dic_info objectForKey:kAYServiceArgsDescription];
				if (napDesc && ![napDesc isEqualToString:@""]) {
					[self aCoderWithData:napDesc ForKey:kAYServiceArgsDescription andSubKey:nil];
					[handleIsCompileArgs replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
				}
            }
            else if([key isEqualToString:@"nap_cost"]) {			//3
                
                NSNumber *price = [dic_info objectForKey:kAYServiceArgsPrice];
                if (price && price.floatValue != 0) {
					[self aCoderWithData:[NSNumber numberWithFloat:(price.floatValue * 100)] ForKey:kAYServiceArgsPrice andSubKey:kAYServiceArgsDetailInfo];
                }
                NSNumber *leastHours = [dic_info objectForKey:kAYServiceArgsLeastHours];
                if (leastHours && leastHours.floatValue != 0) {
					[self aCoderWithData:leastHours ForKey:kAYServiceArgsLeastHours andSubKey:kAYServiceArgsDetailInfo];
                }
                
                NSNumber *duration = [dic_info objectForKey:kAYServiceArgsCourseduration];
                if (duration && duration.intValue != 0) {
					[self aCoderWithData:duration ForKey:kAYServiceArgsCourseduration andSubKey:kAYServiceArgsDetailInfo];
                }
                NSNumber *leastTimes = [dic_info objectForKey:kAYServiceArgsLeastTimes];
                if (leastTimes && leastTimes.intValue != 0) {
					[self aCoderWithData:leastTimes ForKey:kAYServiceArgsLeastTimes andSubKey:kAYServiceArgsDetailInfo];
                }
				
				NSString *serviceCat = [[push_service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
                if ([serviceCat isEqualToString:kAYStringNursery]) {
                    if (price && price.floatValue != 0 && leastHours && leastHours.floatValue != 0) {
                        [handleIsCompileArgs replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:YES]];
                    }
                } else {
                    if (price && price.floatValue != 0 && duration && duration.intValue != 0 && leastTimes && leastTimes.intValue != 0) {
                        [handleIsCompileArgs replaceObjectAtIndex:3 withObject:[NSNumber numberWithBool:YES]];
                    }
                }
            }
            else if([key isEqualToString:kAYServiceArgsNotice]) {   //4
				NSNumber *isAllowLeaves = [dic_info objectForKey:kAYServiceArgsAllowLeave];
				NSString *notice = [dic_info objectForKey:kAYServiceArgsNotice];
				
				[self aCoderWithData:isAllowLeaves ForKey:kAYServiceArgsAllowLeave andSubKey:kAYServiceArgsDetailInfo];
				
				[self aCoderWithData:notice ForKey:kAYServiceArgsNotice andSubKey:kAYServiceArgsDetailInfo];
				
                [handleIsCompileArgs replaceObjectAtIndex:4 withObject:[NSNumber numberWithBool:YES]];
			}
			else if([key isEqualToString:kAYServiceArgsFacility]) {     //5 opt
				NSArray *facilities = [dic_info objectForKey:kAYServiceArgsFacility];
				[self aCoderWithData:facilities ForKey:kAYServiceArgsFacility andSubKey:kAYServiceArgsDetailInfo];
			}
			else if([key isEqualToString:kAYServiceArgsSelf]) {     //update advance
				
				show_service_info = [[dic_info objectForKey:kAYServiceArgsSelf] mutableCopy];
				NSDictionary *note_update_info = [dic_info objectForKey:@"handle"];
				for (NSString *key in note_update_info.allKeys) {
					if ([key isEqualToString:kAYServiceArgsAddress] || [key isEqualToString:kAYServiceArgsAdjustAddress] || [key isEqualToString:kAYServiceArgsPin] || [key isEqualToString:kAYServiceArgsDistrict]) {
						[[update_service_info objectForKey:kAYServiceArgsLocationInfo] setValue:[note_update_info objectForKey:key] forKey:key];
					}
					else if ([key isEqualToString:kAYServiceArgsAgeBoundary] || [key isEqualToString:kAYServiceArgsCapacity] || [key isEqualToString:kAYServiceArgsServantNumb] || [key isEqualToString:kAYServiceArgsFacility]) {
						[[update_service_info objectForKey:kAYServiceArgsDetailInfo] setValue:[note_update_info objectForKey:key] forKey:key];
					}
					else {
						
					}
				}
			}
			
			NSDictionary *tmp;
            if (show_service_info) {
				tmp = [show_service_info mutableCopy];
                [self ServiceInfoChanged];
			} else {
				tmp = [push_service_info mutableCopy];
			}
			
            kAYDelegatesSendMessage(@"MainInfo", @"changeQueryData:", &tmp)
            kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
        }
		else {
			//isnot back service data
		}
    }
}

- (void)aCoderWithData:(id)data ForKey:(NSString*)key andSubKey:(NSString*)subKey {
	if (subKey) {
		[[update_service_info objectForKey:subKey] setValue:data forKey:key];
		[[show_service_info objectForKey:subKey] setValue:data forKey:key];
		[[push_service_info objectForKey:subKey] setValue:data forKey:key];
	} else {
		[update_service_info setValue:data forKey:key];
		[show_service_info setValue:data forKey:key];
		[push_service_info setValue:data forKey:key];
	}
}

- (void)ServiceInfoChanged {
    confirmSerBtn.hidden = NO;
    UIView *view = [self.views objectForKey:kAYTableView];
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - servInfoChangedModelFitHeight);
}

- (BOOL)isAllArgsReady {
    NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.boolValue=NO"];
    NSArray* isAllResady = [handleIsCompileArgs filteredArrayUsingPredicate:p];
    return isAllResady.count == 0 ? YES : NO;
}

- (NSMutableDictionary*)expectNodeWithKey:(NSString*)key {
	id dic_expect = [update_service_info objectForKey:key];
	if (dic_expect) {
		return dic_expect;
	} else {
		NSMutableDictionary *dic_div = [[NSMutableDictionary alloc] init];
		[update_service_info setValue:dic_div forKey:key];
		return  dic_div;
	}
}

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
	
    id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:@"MainInfo"];
    id obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
    obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	
    NSString* cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NapPhotosCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
    
	cell_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"OptionalInfoCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
	kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &cell_name)
    
    confirmSerBtn = [Tools creatBtnWithTitle:nil titleColor:[Tools whiteColor] fontSize:16.f backgroundColor:[Tools theme]];
    [self.view addSubview:confirmSerBtn];
    confirmSerBtn.hidden = YES;
    [confirmSerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 44));
    }];
	
	if (push_service_info) {
		
		NSDictionary *tmp = [push_service_info mutableCopy];
		kAYDelegatesSendMessage(@"MainInfo", @"changeQueryData:", &tmp)
		kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		
		handleIsCompileArgs = [[NSMutableArray alloc] init];
		for (int i = 0; i < requiredInfoNumb; ++i) {
			[handleIsCompileArgs addObject:[NSNumber numberWithBool:NO]];
		}
		
		NSDictionary *info_categ = [push_service_info objectForKey:kAYServiceArgsCategoryInfo];
		NSString *serviceCat = [info_categ objectForKey:kAYServiceArgsCat];
		if ([serviceCat isEqualToString:kAYStringNursery]) {
			NSString *title = @"我的看顾服务";
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
		} else if ([serviceCat isEqualToString:kAYStringCourse]) {
			NSString *title = @"我的课程";
			kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetTitleMessage, &title)
		}
		
		NSString* napPushInfo = @"AYNapBabyAgeCellView";
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &napPushInfo)
		
		confirmSerBtn.hidden = NO;
		[confirmSerBtn setTitle:@"下一步" forState:UIControlStateNormal];
		[confirmSerBtn addTarget:self action:@selector(pushServiceTodoNext) forControlEvents:UIControlEventTouchUpInside];
		
	} else {
		update_service_info = [[NSMutableDictionary alloc] init];
		[update_service_info setValue:[[NSMutableDictionary alloc] init] forKey:kAYServiceArgsDetailInfo];
		[update_service_info setValue:[[NSMutableDictionary alloc] init] forKey:kAYServiceArgsLocationInfo];
		[update_service_info setValue:[[NSMutableDictionary alloc] init] forKey:kAYServiceArgsCategoryInfo];
		
		NSString* editCell = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"NapEditInfoCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &editCell)
		
		NSDictionary *dic_info;		/*没有数据 只确认修改模式*/
		kAYDelegatesSendMessage(@"MainInfo", @"changeQueryInfo:", &dic_info)
		
		[confirmSerBtn setTitle:@"修改服务信息" forState:UIControlStateNormal];
		[confirmSerBtn addTarget:self action:@selector(updateMyService) forControlEvents:UIControlEventTouchUpInside];
		
		NSDictionary *user;
		CURRENUSER(user);
		NSMutableDictionary *dic_detail = [user mutableCopy];
		NSMutableDictionary *dic_condt = [[NSMutableDictionary alloc] init];
		[dic_condt setValue:[show_service_info objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
		[dic_condt setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
		[dic_detail setValue:dic_condt forKey:kAYCommArgsCondition];
		
		id<AYFacadeBase> f_search = [self.facades objectForKey:@"KidNapRemote"];
		AYRemoteCallCommand* cmd_search = [f_search.commands objectForKey:@"QueryServiceDetail"];
		[cmd_search performWithResult:[dic_detail copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
			if(success) {
				show_service_info = [[result objectForKey:kAYServiceArgsSelf] mutableCopy];
				NSDictionary *dic_info = [show_service_info copy];
				kAYDelegatesSendMessage(@"MainInfo", @"changeQueryInfo:", &dic_info)
				kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
			} else {
				AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
			}
		}];
		
	}
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -- layout
- (id)FakeStatusBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusBarH);
    return nil;
}

- (id)FakeNavBarLayout:(UIView*)view{
    view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, FAKE_BAR_HEIGHT);
    
    NSString *title = @"修改服务";
    kAYViewsSendMessage(@"FakeNavBar", @"setTitleText:", &title)
    
    UIImage* left = IMGRESOURCE(@"bar_left_theme");
    kAYViewsSendMessage(@"FakeNavBar", @"setLeftBtnImg:", &left)
    
    UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"预览" titleColor:[Tools theme] fontSize:16.f backgroundColor:nil];
    kAYViewsSendMessage(@"FakeNavBar", @"setRightBtnWithBtn:", &bar_right_btn);
    
    kAYViewsSendMessage(@"FakeNavBar", @"setBarBotLine", nil);
    return nil;
}

- (id)TableLayout:(UIView*)view {
	
    CGFloat fit_height = 0;
    if (show_service_info) {
        fit_height = servInfoNormalModelFitHeight;
    } else {
        fit_height = napPushServNormalModelFitHeight;
    }
    
    view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - fit_height);
    return nil;
}

#pragma mark -- actions
- (void)uploadImages:(NSArray*)images andResult:(asynUploadImages)block {
    
}

- (void)popToRootVCWithTip:(NSString*)tip {
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    [dic setValue:tip forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic];
}

#pragma mark -- alert actions
- (void)BtmAlertOtherBtnClick {
    NSLog(@"didOtherBtnClick");
    
    [super BtmAlertOtherBtnClick];
    [self popToRootVCWithTip:nil];
}

#pragma mark -- 提交服务
- (void)pushServiceTodoNext {
    
    if (![self isAllArgsReady]) {
        NSString *title = @"请完成所有必选项设置";
        AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        return;
    }
	
    id<AYCommand> dest ;
	NSString *serviceCat = [[push_service_info objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
	if ([serviceCat isEqualToString:kAYStringCourse]) {
		dest = DEFAULTCONTROLLER(@"NapScheduleMain");
	} else if ([serviceCat isEqualToString:kAYStringNursery]) {
		dest = DEFAULTCONTROLLER(@"NurseScheduleMain");
	}
	
	[push_service_info setValue:napPhotos forKey:kAYServiceArgsImages];
	
	NSMutableDictionary *dic_push = [[NSMutableDictionary alloc]init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	[dic_push setValue:push_service_info forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = PUSH;
    [cmd performWithResult:&dic_push];
    return;
}

- (void)updateMyService {
    
	if (napPhotos.count != 0) {
		NSMutableArray* semaphores_upload_photos = [[NSMutableArray alloc]init];   // 一个图片是一个上传线程，需要一个semaphores等待上传完成
		for (int index = 0; index < napPhotos.count; ++index) {
			dispatch_semaphore_t tmp = dispatch_semaphore_create(0);
			[semaphores_upload_photos addObject:tmp];
		}
		
		NSMutableArray* post_image_result = [[NSMutableArray alloc]init];           // 记录每一个图片在线中上传的结果
		for (int index = 0; index < napPhotos.count; ++index) {
			[post_image_result addObject:[NSNumber numberWithBool:NO]];
		}
		
		dispatch_queue_t qp = dispatch_queue_create("post thread", nil);
		dispatch_async(qp, ^{
			
			NSMutableArray* arr_items = [[NSMutableArray alloc]init];
			for (int index = 0; index < napPhotos.count; ++index) {
				UIImage* iter = [napPhotos objectAtIndex:index];
				NSString* extent = [Tools getUUIDString];
				
				NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:1];
				[photo_dic setValue:extent forKey:@"image"];
				[photo_dic setValue:iter forKey:@"upload_image"];
				AYRemoteCallCommand* up_cmd = COMMAND(@"Remote", @"UploadUserImage");
				[up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
					NSLog(@"upload result are %d", success);
					[post_image_result replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:success]];
					dispatch_semaphore_signal([semaphores_upload_photos objectAtIndex:index]);
				}];
				[arr_items addObject:extent];
			}
			
			// 4. 等待图片进程全部处理完成
			for (dispatch_semaphore_t iter in semaphores_upload_photos) {
				dispatch_semaphore_wait(iter, dispatch_time(DISPATCH_TIME_NOW, 30.f * NSEC_PER_SEC));
			}
			
			NSPredicate* p = [NSPredicate predicateWithFormat:@"SELF.boolValue=NO"];
			NSArray* image_result = [post_image_result filteredArrayUsingPredicate:p];
			if (image_result.count == 0) {
				[update_service_info setValue:arr_items forKey:kAYServiceArgsImages];
				[self updateServiceInfo];
			}
		});
	} else {
		[self updateServiceInfo];
	}
}

- (void)updateServiceInfo {
    NSDictionary* user = nil;
    CURRENUSER(user)
	
	NSMutableDictionary *dic_update = [Tools getBaseRemoteData];
//	[[dic_update objectForKey:kAYCommArgsCondition] setValue:[user objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[[dic_update objectForKey:kAYCommArgsCondition] setValue:[show_service_info objectForKey:kAYServiceArgsID] forKey:kAYServiceArgsID];
	[dic_update setValue:[update_service_info copy] forKey:kAYServiceArgsSelf];
	
	id<AYFacadeBase> facade = [self.facades objectForKey:@"KidNapRemote"];
	AYRemoteCallCommand *cmd_publish = [facade.commands objectForKey:@"UpdateMyService"];
    [cmd_publish performWithResult:[dic_update copy] andFinishBlack:^(BOOL success, NSDictionary *result) {
        if (success) {
			
            isChangeServiceInfo = YES;		//pop VC 是否刷新
			
            confirmSerBtn.hidden = YES;
            UIView *view = [self.views objectForKey:kAYTableView];
            view.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - servInfoNormalModelFitHeight);
			
			/*重置update参数，二次更新准备*/
			update_service_info = [[NSMutableDictionary alloc] init];
			[update_service_info setValue:[[NSMutableDictionary alloc] init] forKey:kAYServiceArgsDetailInfo];
			[update_service_info setValue:[[NSMutableDictionary alloc] init] forKey:kAYServiceArgsLocationInfo];
			[update_service_info setValue:[[NSMutableDictionary alloc] init] forKey:kAYServiceArgsCategoryInfo];
			
            NSString *title = @"服务信息已更新";
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            
        } else {
            
            NSString *title = [@"服务信息更新失败," stringByAppendingString:kAYNetworkSlowTip];
//			[title stringByAppendingString:kAYNetworkSlowTip];
            AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
        }
    }];
}

#pragma mark -- notification
- (id)leftBtnSelected {
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    if (isChangeServiceInfo) {
        [dic_pop setValue:[NSNumber numberWithBool:YES] forKey:kAYControllerChangeArgsKey];
    }
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
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
    } else {
		tmp = [[NSMutableDictionary alloc] initWithDictionary:show_service_info];
		if (napPhotos.count != 0) {
			[tmp setValue:napPhotos forKey:kAYServiceArgsImages];
		}
    }
	
	[tmp setValue:[NSNumber numberWithInt:1] forKey:@"perview_mode"];
	[dic_args setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
    
	id<AYCommand> cmd_show_module = PUSH;
	[cmd_show_module performWithResult:&dic_args];
    return nil;
}

/*************************/
- (id)addPhotosAction {
    id<AYCommand> dest = DEFAULTCONTROLLER(@"EditPhotos");
    
    dic_push_photos = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic_push_photos setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic_push_photos setValue:dest forKey:kAYControllerActionDestinationControllerKey];
    [dic_push_photos setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    if (napPhotos.count != 0) {
        [dic_push_photos setValue:[napPhotos copy] forKey:kAYControllerChangeArgsKey];
        
        id<AYCommand> cmd = PUSH;
        NSDictionary *tmp = [dic_push_photos copy];
        [cmd performWithResult:&tmp];
        
    } else if(show_service_info) {
        
        UIView *HUBView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        HUBView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.25f];
        [self.view addSubview:HUBView];
        CALayer *hubLayer = [[CALayer alloc]init];
        hubLayer.frame = CGRectMake(0, 0, 200, 80);
        hubLayer.position = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT * 0.5);
        hubLayer.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5f].CGColor;
        hubLayer.cornerRadius = 10.f;
        [HUBView.layer addSublayer:hubLayer];
        
        UILabel *tips = [Tools creatLabelWithText:@"正在准备图片..." textColor:[Tools whiteColor] fontSize:14.f backgroundColor:nil textAlignment:1];
        [HUBView addSubview:tips];
        [tips mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(HUBView);
            make.centerY.equalTo(HUBView);
        }];
        
        NSMutableArray *tmp = [[NSMutableArray alloc]init];
        NSArray *namesArr = [show_service_info objectForKey:kAYServiceArgsImages];
		id<AYFacadeBase> f = DEFAULTFACADE(@"FileRemote");
		AYRemoteCallCommand* cmd = [f.commands objectForKey:@"DownloadUserFiles"];
		NSString *prefix = cmd.route;
        for (int i = 0; i < namesArr.count; ++i) {
			
			NSString* photo_name = namesArr[i];
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:[prefix stringByAppendingString:photo_name]] options:SDWebImageDownloaderHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                if (finished) {
                    [tmp addObject:image];
                    if (tmp.count == namesArr.count) {  //所有图片准备完毕
						[NSThread sleepForTimeInterval:1.5f];
                        [HUBView removeFromSuperview];
                        
                        [dic_push_photos setValue:[tmp copy] forKey:kAYControllerChangeArgsKey];
                        id<AYCommand> cmd = PUSH;
                        NSDictionary *tmp = [dic_push_photos copy];
                        [cmd performWithResult:&tmp];
                    }
                }
            }];
            
        }
        
    } else {
        
        id<AYCommand> cmd = PUSH;
        NSDictionary *tmp = [dic_push_photos copy];
        [cmd performWithResult:&tmp];
    }
    
    return nil;
}

- (id)editPhotosAction {
    
    return nil;
}
/**********************/

@end
