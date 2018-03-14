//
//  AYShareWithQQCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYShareWithQQCommand.h"
#import "TencentOAuth.h"
#import "QQApiInterfaceObject.h"
#import "QQApiInterface.h"
#import "AYNotifyDefines.h"
#import "AYQueryModelDefines.h"
#import "AYFacade.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "Tools.h"

@implementation AYShareWithQQCommand

- (void)performWithResult:(NSDictionary *)args andFinishBlack:(asynCommandFinishBlock)block{
    
    PostPreViewType type =  ((NSNumber*)[args objectForKey:@"publishType"]).intValue;
    switch (type) {
        case PostPreViewPhote:{
            NSData *thumbnailImg = UIImagePNGRepresentation([Tools OriginImage:[args objectForKey:@"image"] scaleToSize:CGSizeMake(100, 100)]);
            NSData *previewImg = UIImagePNGRepresentation([args objectForKey:@"image"]);
            QQApiObject *qqObj = [QQApiImageObject objectWithData:previewImg previewImageData:thumbnailImg title:@"咚哒" description:[args objectForKey:@"decs"]];
            
            SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:qqObj];
            
            if ([QQApiInterface sendReq:req] != EQQAPISENDSUCESS) {//EQQAPISENDSUCESS
                block( NO, nil);
            }else {
                block( YES, nil);
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
