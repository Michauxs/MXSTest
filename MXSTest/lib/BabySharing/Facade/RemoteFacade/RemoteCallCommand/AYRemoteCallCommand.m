//
//  AYRemoteCallCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/27/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRemoteCallCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "RemoteInstance.h"
#import "AYViewBase.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "AYRemoteCallDefines.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"

#import "MBProgressHUD.h"

@implementation AYRemoteCallCommand {
//	int count_loading;
//	int time_count;
//	NSTimer *timer_loding;
}

@synthesize para = _para;
@synthesize route = _route;

- (void)postPerform {
//    count_loading = 0;
//	timer_loding = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
}

- (void)performWithResult:(NSObject**)obj {
    @throw [[NSException alloc]initWithName:@"error" reason:@"异步调用函数不能调用同步函数" userInfo:nil];
}

- (void)beforeAsyncCall {
    if ([self isDownloadUserFilesOrQueryUserProfile]) {
        return;
    }
    NSString* name = [NSString stringWithUTF8String:object_getClassName(self)];
    UIViewController* cur = [Tools activityViewController];
    SEL sel = NSSelectorFromString(kAYRemoteCallStartFuncName);
    Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
    if (m) {
        id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
        func(cur, sel, name);
    }
	
	/*直接盖到keywindow上*/
//	time_count = 30;            //star a new remote, so reset time count to 120
//	if (count_loading == 0) {
//		[timer_loding setFireDate:[NSDate distantPast]];
//		dispatch_async(dispatch_get_main_queue(), ^{
//			[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//		});
//	}
//	count_loading++;
	
}

- (void)endAsyncCall {
    if ([self isDownloadUserFilesOrQueryUserProfile]) {
        return;
    }
    NSString* name = [NSString stringWithUTF8String:object_getClassName(self)];
    UIViewController* cur = [Tools activityViewController];
    SEL sel = NSSelectorFromString(kAYRemoteCallEndFuncName);
    Method m = class_getInstanceMethod([((UIViewController*)cur) class], sel);
    if (m) {
        id (*func)(id, SEL, id) = (id (*)(id, SEL, id))method_getImplementation(m);
        func(cur, sel, name);
    }
	
//	count_loading --;
//	if (count_loading == 0) {
//		[timer_loding setFireDate:[NSDate distantFuture]];
//		dispatch_async(dispatch_get_main_queue(), ^{
//			[MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//		});
//	}
}

//- (void)timerRun {
//	time_count -- ;
//	if (time_count == 0) {
//		count_loading = 0;
//		[timer_loding setFireDate:[NSDate distantFuture]];
//		dispatch_async(dispatch_get_main_queue(), ^{
//			[MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
//		});
//	}
//}


- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    NSLog(@"request confirm code from sever: %@", args);
    
    [self beforeAsyncCall];
    
    dispatch_queue_t rq = dispatch_queue_create("remote call", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(rq, ^{
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:args options:NSJSONWritingPrettyPrinted error:&error];

        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:self.route]];
        NSLog(@"request result from sever: %@", result);

        dispatch_async(dispatch_get_main_queue(), ^{
           
            if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
                NSDictionary* reVal = [result objectForKey:@"result"];
                block(YES, reVal);
            } else {
                NSDictionary* reError = [result objectForKey:@"error"];
				NSNumber *code = [reError objectForKey:@"code"];
				if (code.intValue == -9004 || code.intValue == -9005) {
					
					AYFacade* f_login = LOGINMODEL;
					id<AYCommand> cmd_sign_out_local = [f_login.commands objectForKey:@"SignOutLocal"];
					[cmd_sign_out_local performWithResult:nil];
					
					NSString *tip = @"当前用户登录实效已过期，请重新登录";
					AYShowBtmAlertView(tip, BtmAlertViewTypeHideWithTimer)
				} else
					block(NO, reError);
            }
           
            [self endAsyncCall];
        });
    });
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeRemote;
}

- (BOOL)isDownloadUserFilesOrQueryUserProfile {
    
    //    profile/userProfile		QueryUserProfile			ProfileRemote
    //    query/downloadFile/		DownloadUserFiles			FileRemote
    
    NSString *tmpRoute = self.route;
    
    id<AYFacadeBase> f_load = DEFAULTFACADE(@"FileRemote");
    AYRemoteCallCommand* cmd_load = [f_load.commands objectForKey:@"DownloadUserFiles"];
    NSString *load_route = cmd_load.route;
    
    id<AYFacadeBase> f_profile = DEFAULTFACADE(@"ProfileRemote");
    AYRemoteCallCommand* cmd_profile = [f_profile.commands objectForKey:@"QueryUserProfile"];
    NSString *profile_route = cmd_profile.route;
    
    id<AYFacadeBase> f_comment = DEFAULTFACADE(@"OrderRemote");
    AYRemoteCallCommand* cmd_query = [f_comment.commands objectForKey:@"QueryComments"];
    NSString *query_comments = cmd_query.route;
	
	NSArray *RouteDiv = @[load_route, profile_route, query_comments];
    if ([RouteDiv containsObject:tmpRoute]) {
        return YES;
    } else return NO;
    
}
@end
