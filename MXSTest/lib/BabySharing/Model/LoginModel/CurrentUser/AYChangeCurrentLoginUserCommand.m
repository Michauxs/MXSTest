//
//  AYChangeCurrentLoginUserCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYChangeCurrentLoginUserCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"
#import "AYNotifyDefines.h"

#import "AYModelFacade.h"
#import "AYModel.h"

@implementation AYChangeCurrentLoginUserCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"change tmp user in local db: %@", *obj);
    
    NSDictionary* dic = (NSDictionary*)*obj;
    
    AYModelFacade* f = LOGINMODEL;
#pragma mark -- 写操作必须在主线程，界面读取也在主线程，理论上不会出现race condition，如果有bug再行修改
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSString* newID = (NSString*)[dic objectForKey:kAYCommArgsUserID];
        NSString* phoneNo = [dic objectForKey:kAYProfileArgsPhone];
        
        if (phoneNo && ![phoneNo isEqualToString:@""]) {
            [LoginToken unbindTokenInContext:f.doc.managedObjectContext WithPhoneNum:phoneNo];
        }
		
        LoginToken* token = [LoginToken enumLoginUserInContext:f.doc.managedObjectContext withUserID:newID];
        
        if (token != nil) {
            [LoginToken updataLoginUserInContext:f.doc.managedObjectContext withUserID:newID andAttrs:dic];
        } else {
            token = [LoginToken createTokenInContext:f.doc.managedObjectContext withUserID:newID andAttrs:dic];
        }
        
        [CurrentToken changeCurrentLoginUser:token inContext:f.doc.managedObjectContext];
        [f.doc.managedObjectContext save:nil];
		
		// notify
        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
        [notify setValue:kAYCurrentLoginUserChanged forKey:kAYNotifyFunctionKey];
		
		NSMutableDictionary* cur = [[NSMutableDictionary alloc]initWithCapacity:2];
        CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:f.doc.managedObjectContext];
        [cur setValue:tmp.who.user_id forKey:kAYCommArgsUserID];
        [cur setValue:tmp.who.auth_token forKey:kAYCommArgsToken];
        
        [notify setValue:[cur copy] forKey:kAYNotifyArgsKey];
        AYModel* m = MODEL;
        [m performWithResult:&notify];
    });
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
