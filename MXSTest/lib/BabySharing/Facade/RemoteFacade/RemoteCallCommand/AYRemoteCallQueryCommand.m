//
//  AYRemoteCallQueryCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRemoteCallQueryCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "RemoteInstance.h"
#import "AYViewBase.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "AYRemoteCallDefines.h"

@implementation AYRemoteCallQueryCommand
- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {
    NSLog(@"request confirm code from sever: %@", args);
    
    [self beforeAsyncCall];
    
    /**
     * 2. call remote
     */
    dispatch_queue_t rq = dispatch_queue_create("remote call", nil);
    dispatch_async(rq, ^{
        NSError * error = nil;
        NSData* jsonData =[NSJSONSerialization dataWithJSONObject:args options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary* result = [RemoteInstance remoteSeverRequestData:jsonData toUrl:[NSURL URLWithString:self.route]];
        NSLog(@"request result from sever: %@", result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([[result objectForKey:@"status"] isEqualToString:@"ok"]) {
                block(YES, result);
            }
			else {
				NSDictionary* reError = [result objectForKey:@"error"];
//				if ([[reError objectForKey:@"message"] isEqualToString:@"token过期"]) {
//				}
				
				NSNumber *code = [reError objectForKey:@"code"];
				if (code.intValue == -9004 || code.intValue == -9005) {
					
					AYFacade* f_login = LOGINMODEL;
					id<AYCommand> cmd_sign_out_local = [f_login.commands objectForKey:@"SignOutLocal"];
					[cmd_sign_out_local performWithResult:nil];
					
					NSString *tip = @"当前用户登录实效已过期，请重新登录";
					AYShowBtmAlertView(tip, BtmAlertViewTypeHideWithTimer)
				}
				
                block(NO, reError);
            }
    
            [self endAsyncCall];
        });
    });
}
@end
