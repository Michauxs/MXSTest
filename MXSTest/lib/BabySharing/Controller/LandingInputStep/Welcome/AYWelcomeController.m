//
//  AYUserInfoInput.m
//  BabySharing
//
//  Created by Alfred Yang on 3/28/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYWelcomeController.h"
#import "AYViewBase.h"
#import "AYFacade.h"
#import "AYRemoteCallCommand.h"
#import "AYCommandDefines.h"
#import "AYModel.h"
#import "AYFactoryManager.h"

#define SCREEN_PHOTO_WIDTH						100
#define WELCOMEY								83
#define PHOTOY									145
#define ENTERBTNY								PHOTOY + 151

@implementation AYWelcomeController {
	NSMutableDictionary* login_attr;
	UIImage *changedImage;

    BOOL isChangeImg;
    UIButton *enterBtn;
}

#pragma mark -- commands
- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    NSDictionary* dic = (NSDictionary*)*obj;
   
    if ([[dic objectForKey:kAYControllerActionKey] isEqualToString:kAYControllerActionInitValue]) {
        login_attr = [[dic objectForKey:kAYControllerChangeArgsKey] mutableCopy];
    }
}

#pragma mark -- life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSString* screen_photo = [login_attr objectForKey:@"screen_photo"];
    if (screen_photo && ![screen_photo isEqualToString:@""]) {
        
        id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhote"];
        id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenPhoto:"];
        [cmd performWithResult:&screen_photo];
        
    }
    
    UILabel *welcome = [Tools creatLabelWithText:@"最后一步，您的照片" textColor:[Tools theme] fontSize:22.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:welcome];
    [welcome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(WELCOMEY);
        make.centerX.equalTo(self.view);
    }];
    
    id<AYViewBase> photo_view = [self.views objectForKey:@"UserScreenPhote"];
    UIView *photoView = (UIView*)photo_view;
    
    NSString *user_name = [login_attr objectForKey:@"screen_name"];
    UILabel *nameLabel = [Tools creatLabelWithText:user_name textColor:[Tools theme] fontSize:620.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoView.mas_bottom).offset(16);
        make.centerX.equalTo(self.view);
    }];
	
	enterBtn = [Tools creatBtnWithTitle:@"进入咚哒" titleColor:[Tools whiteColor] fontSize:318.f backgroundColor:[Tools theme]];
	[Tools setViewBorder:enterBtn withRadius:22.5f andBorderWidth:0 andBorderColor:nil andBackground:[Tools theme]];
    [enterBtn addTarget:self action:@selector(updateUserProfile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:enterBtn];
    [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(55);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(130, 45));
    }];
	
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tap];
    
//    [self screenPhotoViewLayout];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark -- views layouts
- (id)FakeNavBarLayout:(UIView*)view {
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, kStatusAndNavBarH);
	view.backgroundColor = [UIColor clearColor];
	
	UIImage* left = IMGRESOURCE(@"bar_left_theme");
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetLeftBtnImgMessage, &left)
	
	NSNumber* right_hidden = [NSNumber numberWithBool:YES];
	kAYViewsSendMessage(kAYFakeNavBarView, kAYNavBarSetRightBtnVisibilityMessage, &right_hidden)
    return nil;
}

- (id)UserScreenPhoteLayout:(UIView*)view {
    view.frame = CGRectMake((SCREEN_WIDTH - SCREEN_PHOTO_WIDTH) * 0.5, PHOTOY, SCREEN_PHOTO_WIDTH, SCREEN_PHOTO_WIDTH);
    return nil;
}

#pragma mark -- actions
- (void)tapGesture:(UITapGestureRecognizer*)gesture {
    NSLog(@"tap esle where");
}

-(void)getInvateBtnClick{
    id<AYCommand> setting = DEFAULTCONTROLLER(@"GetInvateCode");
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dic setValue:kAYControllerActionPushValue forKey:kAYControllerActionKey];
    [dic setValue:setting forKey:kAYControllerActionDestinationControllerKey];
    [dic setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    id<AYCommand> cmd_push = PUSH;
    [cmd_push performWithResult:&dic];
}

#pragma mark -- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    isChangeImg = YES;
    changedImage = image;
    
    // get image name
    NSString* img_name = [Tools getUUIDString];
    [login_attr setValue:img_name forKey:kAYProfileArgsScreenPhoto];
    
    id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhote"];
    id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenPhoto:"];
    [cmd performWithResult:&image];
}

#pragma mark -- view notification
- (void)updateProfileImpl:(NSDictionary*)dic {
	
    id<AYFacadeBase> profileRemote = DEFAULTFACADE(@"ProfileRemote");
    AYRemoteCallCommand* cmd_profile = [profileRemote.commands objectForKey:@"UpdateUserDetail"];
	[[AYRemoteCallManager shared] performWithRemoteCmd:cmd_profile andArgs:dic andFinishBlack:^(BOOL success, NSDictionary *result) {
//    [cmd_profile performWithResult:dic andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSLog(@"Update user detail remote result: %@", result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
				id args = [result objectForKey:@"profile"];
                AYModel* m = MODEL;
                AYFacade* f = [m.facades objectForKey:@"LoginModel"];
//                id<AYCommand> cmd = [f.commands objectForKey:@"UpdateLocalCurrentUserProfile"];
//                [cmd performWithResult:&args];
                
                {
                    id<AYCommand> cmd = [f.commands objectForKey:@"ChangeCurrentLoginUser"];
                    [cmd performWithResult:&args];
                }
                
            } else {
				
				AYShowBtmAlertView(kAYNetworkSlowTip, BtmAlertViewTypeHideWithTimer)
            }
        });
    }];
}

- (void)updateUserProfile {
	
    NSMutableDictionary* dic_update = [[NSMutableDictionary alloc] init];
	[dic_update setValue:[login_attr objectForKey:kAYCommArgsToken] forKey:@"token"];
	
	NSMutableDictionary *condition = [[NSMutableDictionary alloc] init];
	[condition setValue:[login_attr objectForKey:kAYCommArgsUserID] forKey:kAYCommArgsUserID];
	[dic_update setValue:condition forKey:kAYCommArgsCondition];
	
	NSMutableDictionary *profile = [[NSMutableDictionary alloc] init];
	[profile setValue:[login_attr objectForKey:kAYProfileArgsScreenName] forKey:kAYProfileArgsScreenName];
	[profile setValue:[login_attr objectForKey:kAYProfileArgsScreenPhoto] forKey:kAYProfileArgsScreenPhoto];
	[dic_update setValue:profile forKey:@"profile"];
	
    if (isChangeImg) {
        NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
		
		NSString* screen_photo = [login_attr objectForKey:kAYProfileArgsScreenPhoto];
        [photo_dic setValue:screen_photo forKey:@"image"];
        [photo_dic setValue:changedImage forKey:@"upload_image"];
        
        id<AYFacadeBase> up_facade = [self.facades objectForKey:@"FileRemote"];
        AYRemoteCallCommand* up_cmd = [up_facade.commands objectForKey:@"UploadUserImage"];
        [up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
            NSLog(@"upload result are %d", success);
            if (success) {
				
				//已成功上传头像，如果更新用户信息出错，跳过头像上传，直接重试更新用户信息
                [login_attr setValue:screen_photo forKey:kAYProfileArgsScreenPhoto];
				isChangeImg = NO;
				
                [self updateProfileImpl:[dic_update copy]];
				
            } else {
                NSString *title = @"头像上传失败!网络不通畅，换个地方试试";
                AYShowBtmAlertView(title, BtmAlertViewTypeHideWithTimer)
            }
        }];
    } else {
        [self updateProfileImpl:[dic_update copy]];
    }
}

- (id)CurrentLoginUserChanged:(id)args {
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopToRootValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    
    NSString* message_name = @"LoginSuccess";
    [dic_pop setValue:message_name forKey:kAYControllerChangeArgsKey];
    
    id<AYCommand> cmd = POPTOROOT;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)CurrentRegUserProfileChanged:(id)args {
	
    NSString* screen_photo = [args objectForKey:@"screen_photo"];
    [login_attr setValue:screen_photo forKey:@"screen_photo"];
    id<AYViewBase> view = [self.views objectForKey:@"UserScreenPhote"];
    id<AYCommand> cmd = [view.commands objectForKey:@"changeScreenPhoto:"];
    [cmd performWithResult:&screen_photo];
    return nil;
}

- (id)leftBtnSelected {
    
    NSMutableDictionary* dic_pop = [[NSMutableDictionary alloc]init];
    [dic_pop setValue:kAYControllerActionPopValue forKey:kAYControllerActionKey];
    [dic_pop setValue:self forKey:kAYControllerActionSourceControllerKey];
    NSString* message_name = @"ResetStatusReady";
    [dic_pop setValue:message_name forKey:kAYControllerChangeArgsKey];
    id<AYCommand> cmd = POP;
    [cmd performWithResult:&dic_pop];
    return nil;
}

- (id)tapGestureScreenPhoto {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    [sheet showInView:self.view];
    return nil;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
    id<AYCommand> cmd;
    if (buttonIndex == 0) { // take photo / 去拍照
        cmd = OpenCamera;
    } else if (buttonIndex == 1) {
        cmd = OpenImagePickerVC;
    } else {
        
    }
    
    [cmd performWithResult:nil];
}

- (void)invateCoderTextFieldChanged:(NSNotification*)tf {
//    if (tf.object == _invateCode && _invateCode.text.length >= 4) {
//        enterBtn.enabled = YES;
//        _invateCode.text = [_invateCode.text substringToIndex:4];
//    }
//    if (tf.object == _invateCode && _invateCode.text.length < 4) {
//        enterBtn.enabled = NO;
//    }
}

- (id)rightBtnSelected {
    return nil;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
