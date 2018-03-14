//
//  AYAPNNotificationCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYAPNNotificationCommand.h"
#import "AYCommandDefines.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static AYAPNNotificationCommand* instance = nil;

@interface AYAPNNotificationCommand ()
@property (strong, nonatomic) NSString* apn_token;
@end

@implementation AYAPNNotificationCommand

@synthesize para = _para;

+ (AYAPNNotificationCommand*)sharedInstance {
    @synchronized (self) {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

+ (id) allocWithZone:(NSZone *)zone {
    @synchronized (self) {
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

- (id)init {
    @synchronized(self) {
        self = [super init];
        if (self) {
        
        }
        return self;
    }
}

- (id) copyWithZone:(NSZone *)zone {
    return self;
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeAPN;
}

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject *__autoreleasing *)obj {
    /**
     * Notification
     */
    //1.创建消息上面要添加的动作(按钮的形式显示出来)
    UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
    action.identifier = @"action";//按钮的标示
    action.title=@"Accept";//按钮的标题
    action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    //    action.authenticationRequired = YES;
    //    action.destructive = YES;
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.identifier = @"action2";
    action2.title=@"Reject";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
    action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action.destructive = YES;
    
    //2.创建动作(按钮)的类别集合
    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
    categorys.identifier = @"alert";//这组动作的唯一标示,推送通知的时候也是根据这个来区分
    [categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];
    
    //3.创建UIUserNotificationSettings，并设置消息的显示类类型
    UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil]];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notiSettings];
}

- (void)pushCommandPara:(id)p withName:(NSString*)pn {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([AYAPNNotificationCommand class], &count);
    for(int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
      
        NSLog(@"name:%s", property_getName(property));
        NSLog(@"attributes:%s",property_getAttributes(property));
        NSString* property_name = [NSString stringWithUTF8String:property_getName(property)];
        if ([property_name isEqualToString:pn]) {
            [self setValue:p forKey:property_name];
            break;
        }
    }
    free(properties);
}
@end
