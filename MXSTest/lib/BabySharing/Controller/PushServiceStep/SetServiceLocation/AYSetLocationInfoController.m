//
//  AYSetServiceLocationController.m
//  BabySharing
//
//  Created by Alfred Yang on 20/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetLocationInfoController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"

#define kMaxImagesCount             8
static NSString* const kTableDelegate =					@"SetLocationInfo";

@implementation AYSetLocationInfoController {
	
	NSMutableDictionary *push_service_info;
	NSMutableDictionary *tmp_service_info;
	
	NSMutableArray *selectImageArr;
	
	BOOL isAlreadyEnable;
	int tagState;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		push_service_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSDictionary *back_args = [dic objectForKey:kAYControllerChangeArgsKey];
		for (NSString *key in [back_args allKeys]) {
//			if ([key isEqualToString:kAYServiceArgsAddress]) {
//			}
			[tmp_service_info setValue:[back_args objectForKey:key] forKey:key];
		}
		
		[self refreshMainDelegate];
	}
}

#pragma mark -- life cycle
- (void)viewDidLoad {
	[super viewDidLoad];
	tagState = 0;
	
	UILabel *titleLabel = [Tools creatLabelWithText:@"场地信息" textColor:[Tools black] fontSize:630 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(kStatusAndNavBarH+20);
		make.left.equalTo(self.view).offset(20);
	}];
	
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:kTableDelegate];
	id obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	
	NSArray *class_name_arr = @[@"AYSetServiceYardTypeCellView", @"AYSetServiceAddressCellView", @"AYSetServiceFacilityCellView", @"AYSetServiceYardImagesCellView"];
	for (NSString *class_name in class_name_arr) {
		id t = [class_name copy];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &t)
	}
	
	tmp_service_info = [[NSMutableDictionary alloc] init];
	NSDictionary *info_location = [push_service_info objectForKey:kAYServiceArgsLocationInfo];
	NSDictionary *info_detail = [push_service_info objectForKey:kAYServiceArgsDetailInfo];
	[tmp_service_info setValue:[info_location objectForKey:kAYServiceArgsYardType] forKey:kAYServiceArgsYardType];
	[tmp_service_info setValue:[info_location objectForKey:kAYServiceArgsAddress] forKey:kAYServiceArgsAddress];
	[tmp_service_info setValue:[info_location objectForKey:kAYServiceArgsDistrict] forKey:kAYServiceArgsDistrict];
	[tmp_service_info setValue:[info_location objectForKey:kAYServiceArgsCity] forKey:kAYServiceArgsCity];
	[tmp_service_info setValue:[info_location objectForKey:kAYServiceArgsPin] forKey:kAYServiceArgsPin];
	[tmp_service_info setValue:[info_location objectForKey:kAYServiceArgsAdjustAddress] forKey:kAYServiceArgsAdjustAddress];
	[tmp_service_info setValue:[info_detail objectForKey:kAYServiceArgsFacility] forKey:kAYServiceArgsFacility];
	[tmp_service_info setValue:[info_location objectForKey:kAYServiceArgsYardImages] forKey:kAYServiceArgsYardImages];
	
	[tmp_service_info setValue:class_name_arr forKey:kAYDefineArgsCellNames];
	
	id tmp = [tmp_service_info copy];
	kAYDelegatesSendMessage(kTableDelegate, kAYDelegateChangeDataMessage, &tmp);
	{
		id<AYViewBase> view_picker = [self.views objectForKey:@"Picker"];
		id<AYCommand> cmd_datasource = [view_picker.commands objectForKey:@"registerDatasource:"];
		id<AYCommand> cmd_delegate = [view_picker.commands objectForKey:@"registerDelegate:"];
		
		id<AYDelegateBase> cmd_recommend = [self.delegates objectForKey:@"YardTypePick"];
		
		id obj = (id)cmd_recommend;
		[cmd_datasource performWithResult:&obj];
		obj = (id)cmd_recommend;
		[cmd_delegate performWithResult:&obj];
		
		[self.view bringSubviewToFront:(UIView*)view_picker];
//		NSNumber *index = [NSNumber numberWithInteger:0];
//		kAYDelegatesSendMessage(@"SetAgeBoundary", kAYDelegateChangeDataMessage, &index)
	}
//	self.view.userInteractionEnabled = YES;
//	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didScrollHideKeyBroad)]];
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
	view.frame = CGRectMake(0, kStatusBarH, SCREEN_WIDTH, kNavBarH);
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools garyColor] fontSize:616.f backgroundColor:nil];
	bar_right_btn.userInteractionEnabled = NO;
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
	//    kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetBarBotLineMessage, nil)
	return nil;
}

- (id)TableLayout:(UIView*)view {
//	((UITableView*)view).estimatedRowHeight = 100;
//	((UITableView*)view).rowHeight = UITableViewAutomaticDimension;
	view.frame = CGRectMake(0, kStatusAndNavBarH+66, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH-66);
	return nil;
}
	
- (id)PickerLayout:(UIView*)view {
	view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, view.bounds.size.height);
	return nil;
}

#pragma mark - TZImagePickerController
- (void)pushImagePickerController {
	TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:kMaxImagesCount - selectImageArr.count delegate:self];
	
	imagePickerVc.isSelectOriginalPhoto = NO/*_isSelectOriginalPhoto*/;
	imagePickerVc.allowTakePicture = YES; // 是否显示拍照按钮
	
	// 2. 在这里设置imagePickerVc的外观
	imagePickerVc.navigationBar.barTintColor = [UIColor whiteColor];
	imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
	imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
	
	// 3.你可以通过block或者代理，来得到用户选择的照片.
	[imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
		
	}];
	
	[self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark TZImagePickerControllerDelegate
// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
	NSLog(@"cancel");
	[picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	
	NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
	if ([type isEqualToString:@"public.image"]) {
		
		TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:kMaxImagesCount - selectImageArr.count delegate:self];
		[tzImagePickerVc showProgressHUD];
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		
		[self setNavRightBtnEnableStatus];
		
		// 保存图片，获取到asset
		[[TZImageManager manager] savePhotoWithImage:image completion:^{
			
			[tzImagePickerVc hideProgressHUD];
		}];
	}
}

/// 用户选择好了图片，如果assets非空，则用户选择了原图。
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
	
	selectImageArr = [tmp_service_info objectForKey:kAYServiceArgsYardImages];
	if (!selectImageArr) {
		selectImageArr = [NSMutableArray array];
		[tmp_service_info setValue:selectImageArr forKey:kAYServiceArgsYardImages];
	}
	
	for (UIImage *img in photos) {
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
		[dic setValue:img forKey:@"pic"];
		[selectImageArr addObject:dic];
	}
	
	[self refreshMainDelegate];
	
}

#pragma mark -- actions
- (void)setNavRightBtnEnableStatus {
	
	if (tagState == 1) {
		if (!isAlreadyEnable) {
			UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:616.f backgroundColor:nil];
			kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
			isAlreadyEnable = YES;
		}
	} else if(tagState == 2) {
		if (isAlreadyEnable) {
			UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools garyColor] fontSize:616.f backgroundColor:nil];
			bar_right_btn.userInteractionEnabled = NO;
			kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
			isAlreadyEnable = NO;
		}
	} else if(tagState == 0) {
		if (!isAlreadyEnable) {
			UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:616.f backgroundColor:nil];
			kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
			isAlreadyEnable = YES;
		}
	}
}

- (void)refreshMainDelegate {
	
	id tmp = [tmp_service_info copy];
	kAYDelegatesSendMessage(kTableDelegate, kAYDelegateChangeDataMessage, &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	
	[self setNavRightBtnEnableStatus];
}

#pragma mark -- notification
- (id)checkYardImageTag:(id)args {
	tagState = [args intValue];
	if (tagState != 0) {
		[self setNavRightBtnEnableStatus];
	}
	return nil;
}

- (id)leftBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)rightBtnSelected {
	NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
	[dic setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
	[dic setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[tmp_service_info setValue:@"part_location" forKey:@"key"];
	[dic setValue:[tmp_service_info copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)sendTransHeight:(id)args {
	UITableView *view_table = [self.views objectForKey:kAYTableView];
	
	[view_table beginUpdates];
	kAYDelegatesSendMessage(kTableDelegate, @"resetCellHeight:", &args)
	[view_table endUpdates];
	
	return nil;
}

- (id)pickYardType {
	kAYViewsSendMessage(kAYPickerView, kAYPickerShowViewMessage, nil)
	return nil;
}

- (id)didAddressLabelTap {
	id<AYCommand> dest = DEFAULTCONTROLLER(@"NapLocation");
	
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc] init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
//	[dic_push setValue:[tmp_service_info objectForKey:kAYServiceArgsFacility] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	return nil;
}

- (id)adjustTextDidChange:(id)args {
		
	if ([(NSString*)args length] != 0) {
		[tmp_service_info setValue:args forKey:kAYServiceArgsAdjustAddress];
	} else {
		[tmp_service_info removeObjectForKey:kAYServiceArgsAdjustAddress];
	}
	
	[self setNavRightBtnEnableStatus];
	return nil;
}

- (id)didScrollHideKeyBroad {
	[self.view endEditing:YES];
//	[self refreshMainDelegate];
	return nil;
}

- (id)setServiceFacility {
	
	id<AYCommand> dest = DEFAULTCONTROLLER(@"SetNapDevice");
	
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc] init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	[dic_push setValue:[tmp_service_info objectForKey:kAYServiceArgsFacility] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	return nil;
}

- (id)deletedImageWithIndex:(id)args {
	[selectImageArr removeObjectAtIndex:[args integerValue]];
	[self refreshMainDelegate];
	return nil;
}
- (id)beginImagePicker {
	
	if (selectImageArr.count >= kMaxImagesCount) {
		NSString *tip = [NSString stringWithFormat:@"最多只能选择%d张图片", kMaxImagesCount];
		AYShowBtmAlertView(tip, BtmAlertViewTypeHideWithTimer);
	} else {
		[self pushImagePickerController];
	}
	return nil;
}
- (id)editYardImagesTag:(id)args {
	id<AYCommand> dest = DEFAULTCONTROLLER(@"SetYardImagesTag");
	
	NSMutableDictionary* dic_push = [[NSMutableDictionary alloc] init];
	[dic_push setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
	[dic_push setValue:dest forKey:kAYControllerActionDestinationControllerKey];
	[dic_push setValue:self forKey:kAYControllerActionSourceControllerKey];
	
	NSMutableDictionary *dic_imgs = [[NSMutableDictionary alloc] init];
	[dic_imgs setValue:[tmp_service_info objectForKey:kAYServiceArgsYardImages] forKey:kAYServiceArgsYardImages];
	[dic_imgs setValue:args forKey:@"index"];
	[dic_push setValue:[dic_imgs copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = PUSH;
	[cmd performWithResult:&dic_push];
	return nil;
}



- (id)didSaveClick {
	
	id<AYDelegateBase> cmd_commend = [self.delegates objectForKey:@"YardTypePick"];
	id<AYCommand> cmd_index = [cmd_commend.commands objectForKey:@"queryCurrentSelected:"];
	id brige = [self.views objectForKey:kAYPickerView];
	[cmd_index performWithResult:&brige];
	
	NSString *args = (NSString*)brige;
	if (args.length != 0) {
		[tmp_service_info setValue:args forKey:kAYServiceArgsYardType];
		[self refreshMainDelegate];
	}
	return nil;
}

- (id)didCancelClick {
	//do nothing else ,but be have to invoke this methed
	return nil;
}
@end
