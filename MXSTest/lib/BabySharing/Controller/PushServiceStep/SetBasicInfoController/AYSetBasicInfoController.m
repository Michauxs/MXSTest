//
//  AYSetBasicInfoController.m
//  BabySharing
//
//  Created by Alfred Yang on 18/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYSetBasicInfoController.h"
#import "AYViewBase.h"
#import "AYCommandDefines.h"
#import "AYFacadeBase.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYFacadeBase.h"


#define kMaxImagesCount             8
static NSString* const kSetBasicInfoDelegate =					@"SetBasicInfo";

@implementation AYSetBasicInfoController {
	
	NSMutableDictionary *push_service_info;
	
	NSMutableArray *selectImageArr;
	NSMutableDictionary *tmp_service_info;
	
	BOOL isAlreadyEnable;
}

#pragma mark --  commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
	
	NSDictionary* dic = (NSDictionary*)*obj;
	if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
		push_service_info = [dic objectForKey:kAYControllerChangeArgsKey];
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPushValue]) {
		
	} else if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionPopBackValue]) {
		NSString *desc = [dic objectForKey:kAYControllerChangeArgsKey];
		[tmp_service_info setValue:desc forKey:kAYServiceArgsDescription];
		
		id tmp = [tmp_service_info copy];
		kAYDelegatesSendMessage(kSetBasicInfoDelegate, kAYDelegateChangeDataMessage, &tmp)
		kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
		
		[self setNavRightBtnEnableStatus];
	}
}

#pragma mark -- life cycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	UILabel *titleLabel = [Tools creatLabelWithText:@"基本信息" textColor:[Tools black] fontSize:630 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
	[self.view addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.view).offset(kStatusAndNavBarH+20);
		make.left.equalTo(self.view).offset(20);
	}];
	
	id<AYDelegateBase> cmd_notify = [self.delegates objectForKey:kSetBasicInfoDelegate];
	id obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDelegateMessage, &obj)
	obj = (id)cmd_notify;
	kAYViewsSendMessage(kAYTableView, kAYTCViewRegisterDatasourceMessage, &obj)
	
	NSArray *class_name_arr = @[@"AYSetServiceImagesCellView", @"AYSetServiceDescCellView", @"AYSetServiceCharactCellView"];
	for (NSString *class_name in class_name_arr) {
		id t = [class_name copy];
		kAYViewsSendMessage(kAYTableView, kAYTableRegisterCellWithClassMessage, &t)
	}
	
	tmp_service_info = [[NSMutableDictionary alloc] init];
	[tmp_service_info setValue:[push_service_info objectForKey:kAYServiceArgsImages] forKey:kAYServiceArgsImages];
	[tmp_service_info setValue:[push_service_info objectForKey:kAYServiceArgsDescription] forKey:kAYServiceArgsDescription];
	[tmp_service_info setValue:[[push_service_info objectForKey:kAYServiceArgsDetailInfo] objectForKey:kAYServiceArgsCharact] forKey:kAYServiceArgsCharact];
	[tmp_service_info setValue:class_name_arr forKey:kAYDefineArgsCellNames];
	
	id tmp = [tmp_service_info copy];
	kAYDelegatesSendMessage(@"SetBasicInfo", kAYDelegateChangeDataMessage, &tmp);
	
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
	view.frame = CGRectMake(0, kStatusAndNavBarH+66, SCREEN_WIDTH, SCREEN_HEIGHT - kStatusAndNavBarH-66);
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
	
	selectImageArr = [tmp_service_info objectForKey:kAYServiceArgsImages];
	if (!selectImageArr) {
		selectImageArr = [NSMutableArray array];
		[tmp_service_info setValue:selectImageArr forKey:kAYServiceArgsImages];
	}
	[selectImageArr addObjectsFromArray:photos];
	[self refreshMainDelegate];
	
}

#pragma mark -- actions
- (void)setNavRightBtnEnableStatus {
	if (!isAlreadyEnable) {
		UIButton* bar_right_btn = [Tools creatBtnWithTitle:@"保存" titleColor:[Tools theme] fontSize:616.f backgroundColor:nil];
		kAYViewsSendMessage(@"FakeNavBar", kAYNavBarSetRightBtnWithBtnMessage, &bar_right_btn)
		isAlreadyEnable = YES;
	}
}

- (void)refreshMainDelegate {
	
	id tmp = [tmp_service_info copy];
	kAYDelegatesSendMessage(kSetBasicInfoDelegate, kAYDelegateChangeDataMessage, &tmp)
	kAYViewsSendMessage(kAYTableView, kAYTableRefreshMessage, nil)
	
	[self setNavRightBtnEnableStatus];
}

#pragma mark -- notification
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
	
	[tmp_service_info setValue:@"part_basic" forKey:@"key"];
	[dic setValue:[tmp_service_info copy] forKey:kAYControllerChangeArgsKey];
	
	id<AYCommand> cmd = POP;
	[cmd performWithResult:&dic];
	return nil;
}

- (id)didCharactViewTap:(id)args {
	NSMutableArray *charArr = [tmp_service_info objectForKey:kAYServiceArgsCharact];
	if (!charArr) {
		charArr = [NSMutableArray array];
		[tmp_service_info setValue:charArr forKey:kAYServiceArgsCharact];
	}
	
	NSString *charStr = args;
	if ([charArr containsObject:charStr]) {
		[charArr removeObject:charStr];
	} else if(charArr.count < 3){
		[charArr addObject:charStr];
	} else {
		NSLog(@"Limited off 3");
	}
	
	[self refreshMainDelegate];
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
@end
