//
//  AppDelegate.m
//  MXSTest
//
//  Created by Alfred Yang on 17/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AppDelegate.h"
#import "MXSTabBarController.h"
#import "MXSHomeVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	NSLog(@"项目路径 ======= %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
//	[NSThread sleepForTimeInterval:2.0];
	
	self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
	[self.window makeKeyAndVisible];
	
	MXSTabBarController *tabVC = [[MXSTabBarController alloc]init];
	self.window.rootViewController = tabVC;
	
//	MXSHomeVC *home = [[MXSHomeVC alloc]init];
//	self.window.rootViewController = home;
	
	
	// 这里 types 可以自定义，如果 types 为 0，那么所有的用户通知均会静默的接收，系统不会给用户任何提示(当然，App 可以自己处理并给出提示)
	UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
	// 这里 categories 可暂不深入，本文后面会详细讲解。
	UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
	// 当应用安装后第一次调用该方法时，系统会弹窗提示用户是否允许接收通知
	[[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
	
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
//    [self saveContext];
}


- (void)application: (UIApplication*)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
	if (notificationSettings.types & UIUserNotificationTypeBadge) {
		NSLog(@"Badge Nofitication type is allowed");
	}
	if (notificationSettings.types & UIUserNotificationTypeAlert) {
		NSLog(@"Alert Notification type is allowed");
	}
	if (notificationSettings.types & UIUserNotificationTypeSound) {
		NSLog(@"Sound Notification type is allowed");
	}
}

//如果已经注册了本地通知，当客户端响应通知时：
//a、应用程序在后台的时候，本地通知会给设备送达一个和远程通知一样的提醒
//b、应用程序正在运行中，则设备不会收到提醒，但是会走应用程序delegate中的方法：
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//	如果你想实现程序在后台时候的那种提醒效果，可以添加代码👇
	if ([[notification.userInfo objectForKey:@"id"] isEqualToString:@""]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"test" message:notification.alertBody delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:notification.alertAction, nil, nil];
		[alert show];
	}
	
//	需要注意的是，在情况a中，如果用户点击提醒进入应用程序，也会执行收到本地通知的回调方法，这种情况下如果你添加了上面那段代码，则会出现连续出现两次提示，为了解决这个问题，修改代码如下：
	
//	if ([[notification.userInfo objectForKey:@"id"] isEqualToString:@""]) {
//		//判断应用程序当前的运行状态，如果是激活状态，则进行提醒，否则不提醒
//		if (application.applicationState == UIApplicationStateActive) {
//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:notification.alertBody delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
//			[alert show];
//		}
//	}
	
}


@end
