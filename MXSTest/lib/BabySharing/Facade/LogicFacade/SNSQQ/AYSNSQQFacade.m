//
//  AYSNSQQFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 3/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSNSQQFacade.h"
// qq sdk
#import "TencentOAuth.h"

#import "AYFactoryManager.h"
#import "AYNotifyDefines.h"
#import "AYRemoteCallCommand.h"
#import "Tools.h"
#import "WeiboSDK.h"
#import "AYModel.h"
#import "RemoteInstance.h"
#import "TmpFileStorageModel.h"

//SDWebImage
#import "UIImageView+WebCache.h"
#import "UIImage+MultiFormat.h"

static NSString* const kQQTencentID = @"1104831230";
static NSString* const kQQTencentPermissionUserInfo = @"get_user_info";
static NSString* const kQQTencentPermissionSimpleUserInfo = @"get_simple_userinfo";
static NSString* const kQQTencentPermissionAdd = @"add_t";

@interface AYSNSQQFacade () <TencentSessionDelegate>

@end

@implementation AYSNSQQFacade {
}

- (void)postPerform {
    _qq_oauth = [[TencentOAuth alloc] initWithAppId:kQQTencentID andDelegate:self];
    _qq_oauth.redirectURI = nil;
    _permissions =  @[kQQTencentPermissionUserInfo, kQQTencentPermissionSimpleUserInfo, kQQTencentPermissionUserInfo];
   
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyQQAPIReady forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [self performWithResult:&notify];
}

#pragma mark - qq login and call back
- (void)loginSuccessWithQQAsUser:(NSString *)qq_openID accessToken:(NSString*)accessToken infoDic:(NSDictionary *)infoDic {
    // 保存 accessToken 和 qq_openID 到本地 coreData 和服务器
    
    /**
     *  2. sent user screen name to server and create auth_token
     */
    NSString* screen_name = [infoDic valueForKey:@"nickname"];
    NSLog(@"user name is %@", screen_name);
    
    /**
     *  3. save auth_toke and weibo user profile in local DB
     */
    id<AYFacadeBase> landing_facade = DEFAULTFACADE(@"LandingRemote");
    AYRemoteCallCommand* cmd_sns = [landing_facade.commands objectForKey:@"AuthWithSNS"];
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"" forKey:@"auth_token"];
    [dic setValue:@"" forKey:@"user_id"];
    [dic setValue:@"qq" forKey:@"provide_name"];
    [dic setValue:screen_name forKey:@"provide_screen_name"];
    [dic setValue:@"" forKey:@"provide_screen_photo"];
    [dic setValue:qq_openID forKey:@"provide_uid"];
    [dic setValue:accessToken forKey:@"provide_token"];
    [dic setValue:[Tools getDeviceUUID] forKey:@"uuid"];
    
    [cmd_sns performWithResult:[dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
        NSLog(@"new user info %@", result);
        
        NSMutableDictionary* reVal = [result mutableCopy];
        
        AYModel* m = MODEL;
        id<AYFacadeBase> f = [m.facades objectForKey:@"LoginModel"];
        id<AYCommand> cmd = [f.commands objectForKey:@"ChangeRegUser"];
        
        id dic = [result copy];
        [cmd performWithResult:&dic];
        NSLog(@"change tmp reg user %@", dic);
       
        NSMutableDictionary* dic_result = [[NSMutableDictionary alloc]init];
        [dic_result setValue:@"qq" forKey:@"provide_name"];
        [dic_result setValue:qq_openID forKey:@"provide_user_id"];
        [dic_result setValue:accessToken forKey:@"provide_token"];
        [dic_result setValue:screen_name forKey:@"provide_screen_name"];
        [dic_result setValue:[result objectForKey:@"user_id"] forKey:@"user_id"];
         
        id<AYCommand> cmd_provider = [f.commands objectForKey:@"ChangeSNSProviders"];
        [cmd_provider performWithResult:&dic_result];
        
        NSString* screen_photo = [result objectForKey:@"screen_photo"];
        
        if (screen_photo == nil || [screen_photo isEqualToString:@""]) {
            NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:[infoDic valueForKey:@"figureurl_qq_2"]]];
            UIImage* img = [UIImage imageWithData:data];
            
            screen_photo = [TmpFileStorageModel generateFileName];
//           NSString* extent = [TmpFileStorageModel saveToTmpDirWithImage:img];
            [TmpFileStorageModel saveToTmpDirWithImage:img withName:screen_photo];
            
            NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:3];
            [photo_dic setValue:screen_photo forKey:@"image"];
            [photo_dic setValue:img forKey:@"upload_image"];
            
            id<AYFacadeBase> up_facade = DEFAULTFACADE(@"FileRemote");
            AYRemoteCallCommand* up_cmd = [up_facade.commands objectForKey:@"UploadUserImage"];
            [up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                NSLog(@"upload result are %d", success);
            }];
            
            NSMutableDictionary* dic_up = [[NSMutableDictionary alloc]init];
            [dic_up setValue:[result objectForKey:@"auth_token"] forKey:@"auth_token"];
            [dic_up setValue:[result objectForKey:@"user_id"] forKey:@"user_id"];
            [dic_up setValue:screen_photo forKey:@"screen_photo"];
            [reVal setValue:screen_photo forKey:@"screen_photo"];
            
            id<AYFacadeBase> profileRemote = DEFAULTFACADE(@"ProfileRemote");
            AYRemoteCallCommand* cmd_profile = [profileRemote.commands objectForKey:@"UpdateUserDetail"];
            [cmd_profile performWithResult:[dic_up copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
                NSLog(@"Update user detail remote result: %@", result);
                if (success) {
                    NSDictionary* args = [result copy];
                    [cmd performWithResult:&args];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"set nick name error" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
//        NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:[infoDic valueForKey:@"figureurl_qq_2"]]];
//        UIImage* img = [UIImage imageWithData:data];
////        NSString* extent = [TmpFileStorageModel saveToTmpDirWithImage:img];
//        
////        UIImage *imageSizeIcon = [self pressImageWith:img andExpectedWidth:120];
////        NSData *icon_data = UIImageJPEGRepresentation(imageSizeIcon, 1);
////        UIImage *imageIcon = [UIImage imageWithData:icon_data];
////        
////        UIImage *imageSizeThum = [self pressImageWith:img andExpectedWidth:240];
////        NSData *thum_data = UIImageJPEGRepresentation(imageSizeThum, 1);
////        UIImage *imageThum = [UIImage imageWithData:thum_data];
////        
////        [[SDImageCache sharedImageCache] storeImage:imageIcon forKey:[screen_photo stringByAppendingString:@"img_icon"] toDisk:NO];
////        [[SDImageCache sharedImageCache] storeImage:imageThum forKey:[screen_photo stringByAppendingString:@"img_thum"] toDisk:NO];
////        [TmpFileStorageModel saveToTmpDirWithImage:imageIcon withName:[screen_photo stringByAppendingString:@"img_icon"]];
////        [TmpFileStorageModel saveToTmpDirWithImage:imageThum withName:[screen_photo stringByAppendingString:@"img_thum"]];
//        [TmpFileStorageModel saveToTmpDirWithImage:img withName:screen_photo];
//        
//        NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
//        [photo_dic setValue:screen_photo forKey:@"image"];
//        [photo_dic setValue:img forKey:@"upload_image"];
//        
//        id<AYFacadeBase> up_facade = DEFAULTFACADE(@"FileRemote");
//        AYRemoteCallCommand* up_cmd = [up_facade.commands objectForKey:@"UploadUserImage"];
//        [up_cmd performWithResult:[photo_dic copy] andFinishBlack:^(BOOL success, NSDictionary * result) {
//            NSLog(@"upload result are %d", success);
//        }];
        /**
         *  4. push notification to the controller
         *      and controller to refresh the view
         */
        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
        [notify setValue:kAYNotifySNSLoginSuccess forKey:kAYNotifyFunctionKey];
        
        [notify setValue:[reVal copy] forKey:kAYNotifyArgsKey];
        [self performWithResult:&notify];
    }];
}

#pragma mark -- tencent delegate
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    NSLog(@"login succss with token : %@", _qq_oauth.accessToken);
    if (_qq_oauth.accessToken && 0 != [_qq_oauth.accessToken length]) {
        //  记录登录用户的OpenID、Token以及过期时间
        NSLog(@"openId === %@", [_qq_oauth getUserOpenID]);
        NSLog(@"login succss with token : %@", _qq_oauth.accessToken);
        NSLog(@"获取用户信息 === %c", [_qq_oauth getUserInfo]);
    } else {
        NSLog(@"login error");
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (cancelled) {
        NSLog(@"login user cancel");
    } else {
        NSLog(@"login failed");
    }
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyEndLogin forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [self performWithResult:&notify];
}

/**
 * 登录时网络有问题的回调
 */
-(void)tencentDidNotNetWork {
    NSLog(@"login with no network");
}

/**
 * 获取用户信息的回调
 */
- (void)getUserInfoResponse:(APIResponse *)response {
    if (response.retCode == URLREQUEST_SUCCEED) {
        [self loginSuccessWithQQAsUser:_qq_oauth.openId accessToken:_qq_oauth.accessToken infoDic:response.jsonResponse];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"通知" message:@"获取QQ详细信息失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark -- image size compress
-(UIImage *)pressImageWith:(UIImage *)image andExpectedWidth:(CGFloat)width
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


@end
