//
//  MXSEMCmd.m
//  MXSTest
//
//  Created by Sunfei on 2018/4/13.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "MXSEMCmd.h"

static MXSEMCmd *_instance;

static NSString* const kMXSEMPassword = @"pasSw0rD";

@implementation MXSEMCmd

+ (MXSEMCmd *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [[EMClient sharedClient] addDelegate:(id)_instance delegateQueue:nil];
        
        //移除消息回调
//        [[EMClient sharedClient].chatManager removeDelegate:self];
        
        //注册消息回调
        [[EMClient sharedClient].chatManager addDelegate:(id)_instance delegateQueue:nil];
    });
    return _instance;
}

- (void)registerUserWithName:(NSString*)name {
    EMError *error = [[EMClient sharedClient] registerWithUsername:name password:kMXSEMPassword];
    if (error==nil) {
        NSLog(@"注册成功");
        [self loginEMWithName:name];
    }
}

- (void)loginEMWithName:(NSString*)name {
    EMError *error = [[EMClient sharedClient] loginWithUsername:name password:kMXSEMPassword];
    if (!error) {
        NSLog(@"登录成功");
        [[EMClient sharedClient].options setIsAutoLogin:YES];
    }
}

- (void)logoutEMClient {
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        NSLog(@"退出成功");
    }
}

/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)userAccountDidLoginFromOtherDevice {
    
}

/*!
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)userAccountDidRemoveFromServer {
    
}

/*!
 *  自动登录返回结果
 *
 *  @param error 错误信息
 */
- (void)autoLoginDidCompleteWithError:(EMError *)error {
    
}

/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    
}


/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)messagesDidReceive:(NSArray *)aMessages {
    for (EMMessage *message in aMessages) {
        EMMessageBody *msgBody = message.body;
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                NSLog(@"收到的文字是 txt -- %@",txt);
            }
                break;
            case EMMessageBodyTypeImage:
            {
                
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
                NSLog(@"纬度-- %f",body.latitude);
                NSLog(@"经度-- %f",body.longitude);
                NSLog(@"地址-- %@",body.address);
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                // 音频sdk会自动下载
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                
            }
                break;
            case EMMessageBodyTypeFile:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
}

/*!
 @method
 @brief 接收到一条及以上cmd消息
 */
- (void)cmdMessagesDidReceive:(NSArray *)aCmdMessages {
    
    NSLog(@"cmd消息:%@", aCmdMessages.firstObject);
}

@end
