//
//  AYSNSWeiboFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 3/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYSNSWeiboFacade.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYNotifyDefines.h"
#import "AYRemoteCallCommand.h"
#import "Tools.h"
#import "WeiboSDK.h"
#import "AYModel.h"
#import "RemoteInstance.h"
#import "TmpFileStorageModel.h"
#import "AYModelFacade.h"
// weibo sdk
#import "WeiboUser.h"
#import "WBHttpRequest+WeiboUser.h"
#import "WBHttpRequest+WeiboShare.h"

static NSString* const kAYWeiboRegisterID = @"1584832986";

@interface AYSNSWeiboFacade () <WeiboSDKDelegate>

@end

@implementation AYSNSWeiboFacade {
    NSString* wbCurrentUserID;
    NSString* wbtoken;
}

- (void)postPerform {
    // Weibo sdk init
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAYWeiboRegisterID];
    
    NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
    [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
    [notify setValue:kAYNotifyWeiboAPIReady forKey:kAYNotifyFunctionKey];
    
    NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
    [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
    [self performWithResult:&notify];
}

#pragma mark -- weibo delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)loginSuccessWithWeiboAsUser:(NSString*)weibo_user_id withToken:(NSString*)weibo_token {
    NSLog(@"wei bo login success");
    NSLog(@"login as user: %@", weibo_user_id);
    NSLog(@"login with token: %@", weibo_token);
    /**
     *  1. get user email in weibo profle
     */
    [WBHttpRequest requestForUserProfile:weibo_user_id withAccessToken:weibo_token andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {

        NSLog(@"begin get user info from weibo");
        
//        NSString *title = nil;
//        UIAlertView *alert = nil;
//            title = NSLocalizedString(@"请求异常", nil);
//            alert = [[UIAlertView alloc] initWithTitle:title
//                                               message:[NSString stringWithFormat:@"%@",error]
//                                              delegate:nil
//                                     cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                     otherButtonTitles:nil];
//            [alert show];
        
        if (error) {
            NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
            [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
            [notify setValue:kAYNotifyEndLogin forKey:kAYNotifyFunctionKey];
            
            NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
            [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
            [self performWithResult:&notify];
            
        } else {
            /**
             *  2. sent user screen name to server and create auth_token
             */
            WeiboUser* user = (WeiboUser*)result;
            NSString* screen_name = user.screenName;
            NSLog(@"user name is %@", screen_name);
            
            /**
             *  3. save auth_toke and weibo user profile in local DB
             */
            id<AYFacadeBase> landing_facade = DEFAULTFACADE(@"LandingRemote");
            AYRemoteCallCommand* cmd_sns = [landing_facade.commands objectForKey:@"AuthWithSNS"];
           
            NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
            [dic setValue:@"" forKey:@"auth_token"];
            [dic setValue:@"" forKey:@"user_id"];
            [dic setValue:@"weibo" forKey:@"provide_name"];
            [dic setValue:screen_name forKey:@"provide_screen_name"];
            [dic setValue:@"" forKey:@"provide_screen_photo"];
            [dic setValue:weibo_user_id forKey:@"provide_uid"];
            [dic setValue:weibo_token forKey:@"provide_token"];
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
                [dic_result setValue:@"weibo" forKey:@"provide_name"];
                [dic_result setValue:weibo_user_id forKey:@"provide_user_id"];
                [dic_result setValue:weibo_token forKey:@"provide_token"];
                [dic_result setValue:screen_name forKey:@"provide_screen_name"];
                [dic_result setValue:[result objectForKey:@"user_id"] forKey:@"user_id"];
                
                id<AYCommand> cmd_provider = [f.commands objectForKey:@"ChangeSNSProviders"];//michauxs:增加多个第三方
                [cmd_provider performWithResult:&dic_result];
                
                NSString* screen_photo = [result objectForKey:@"screen_photo"];
                
                if (screen_photo == nil || [screen_photo isEqualToString:@""]) {
                    NSData* data = [RemoteInstance remoteDownDataFromUrl:[NSURL URLWithString:user.profileImageUrl]];
                    UIImage* img = [UIImage imageWithData:data];
                   
                    screen_photo = [TmpFileStorageModel generateFileName];
                    [TmpFileStorageModel saveToTmpDirWithImage:img withName:screen_photo];
                    
                    NSMutableDictionary* photo_dic = [[NSMutableDictionary alloc]initWithCapacity:2];
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
    }];
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *title = NSLocalizedString(@"发送结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        if (userID) {
            wbCurrentUserID = userID;
        }
        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        /**
         * auth response
         * if success throw the user id and the token to the login model
         * otherwise show error message
         */
        if (response.statusCode == 0) { // success
            [self loginSuccessWithWeiboAsUser:[(WBAuthorizeResponse *)response userID] withToken:[(WBAuthorizeResponse *)response accessToken]];
        } else {
            NSString *title = @"错误";
            
            NSString *message = [NSString stringWithFormat: @"微博验证失败，错误 %ld", (long)response.statusCode];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"cancel"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        NSString *title = NSLocalizedString(@"支付结果", nil);
        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.payStatusCode: %@\nresponse.payStatusMessage: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBPaymentResponse *)response payStatusCode], [(WBPaymentResponse *)response payStatusMessage], NSLocalizedString(@"响应UserInfo数据", nil),response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if ([response isKindOfClass:WBSDKAppRecommendResponse.class]) {
        
        NSString *title = @"推荐结果";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:[NSString stringWithFormat:@"response %@", ((WBSDKAppRecommendResponse*)response)]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}
@end
