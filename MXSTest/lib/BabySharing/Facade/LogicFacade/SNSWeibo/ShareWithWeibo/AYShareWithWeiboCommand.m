//
//  AYShareWithWeiboCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYShareWithWeiboCommand.h"
#import "AYNotifyDefines.h"
#import "AYFacade.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

#import "WeiboSDK.h"
// weibo sdk
#import "WBHttpRequest+WeiboUser.h"
#import "WBHttpRequest+WeiboShare.h"

#import "Providers.h"
#import "Providers+ContextOpt.h"
#import "AYModelFacade.h"
#import "AYQueryModelDefines.h"

#import "LoginToken+CoreDataClass.h"
#import "LoginToken+ContextOpt.h"
#import "CurrentToken.h"
#import "CurrentToken+ContextOpt.h"

@implementation AYShareWithWeiboCommand
//@synthesize para = _para;

//- (void)postPerform {
//
//}

//- (void)performWithResult:(NSObject**)obj {
- (void)performWithResult:(NSDictionary *)args andFinishBlack:(asynCommandFinishBlock)block {
//    NSDictionary* args = (NSDictionary*)*obj;
    
//    NSDictionary* user = nil;
//    CURRENUSER(user)
//    NSMutableArray* dic = [user mutableCopy];
    
    AYModelFacade* fl = LOGINMODEL;
    CurrentToken* tmp = [CurrentToken enumCurrentLoginUserInContext:fl.doc.managedObjectContext];
    NSString* user_id = tmp.who.user_id;
    Providers* cur = [Providers enumProvideInContext:fl.doc.managedObjectContext ByName:@"weibo" andCurrentUserID:user_id];
    
    PostPreViewType type =  ((NSNumber*)[args objectForKey:@"publishType"]).intValue;
    switch (type) {
        case PostPreViewPhote:{
            if (cur == nil) {
                block(NO, (NSDictionary*)@"weiboNotAuth");
                return;
            } else {
                dispatch_queue_t wb_query_queue = dispatch_queue_create("wb share queus", nil);
                dispatch_async(wb_query_queue, ^{
                    WBImageObject* img_obj = [WBImageObject object];
                    img_obj.imageData = UIImagePNGRepresentation([args objectForKey:@"image"]);
                    [WBHttpRequest requestForShareAStatus:[args objectForKey:@"decs"] contatinsAPicture:img_obj orPictureUrl:nil withAccessToken:cur.provider_token andOtherProperties:nil queue:[NSOperationQueue currentQueue] withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                        NSLog(@"result is %@", result);
                        NSLog(@"error is %@", error.domain);
                        if (error.code == 0) {
                            block(YES, result);
                        } else block(NO, (NSDictionary*)error.domain);
                    }];
                });
            }
            
        }
            break;
        case PostPreViewMovie:{
            
        }
            break;
        case PostPreViewText:{
            
        }
            break;
        default:
            break;
    }
}

//- (NSString*)getCommandType {
//    return kAYFactoryManagerCommandTypeModule;
//}

@end
