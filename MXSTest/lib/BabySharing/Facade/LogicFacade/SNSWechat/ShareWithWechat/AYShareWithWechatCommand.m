//
//  AYShareWithWechatCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYShareWithWechatCommand.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "Tools.h"
#import "AYQueryModelDefines.h"

@implementation AYShareWithWechatCommand

- (void)performWithResult:(NSDictionary *)args andFinishBlack:(asynCommandFinishBlock)block{
    
    //    NSDictionary* user = nil;
    //    CURRENUSER(user)
    //    NSMutableArray* dic = [user mutableCopy];
    PostPreViewType type =  ((NSNumber*)[args objectForKey:@"publishType"]).intValue;
    switch (type) {
        case PostPreViewPhote:{
            WXMediaMessage *message = [WXMediaMessage message];
            [message setThumbImage:[Tools OriginImage:[args objectForKey:@"image"] scaleToSize:CGSizeMake(100, 100)]];
            // 缩略图
        //    message.title = @"咚哒";
        //    message.description = [args objectForKey:@"decs"];
        //    message.description = @"一句话传递你的主张(18个字)";
            WXImageObject *imageObject = [WXImageObject object];
            imageObject.imageData = UIImagePNGRepresentation([args objectForKey:@"image"]);
            message.mediaObject = imageObject;
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene = WXSceneTimeline;
            if ([WXApi sendReq:req] == YES) {
                block(YES, nil);
            }else {
                block(NO, nil);
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
@end
