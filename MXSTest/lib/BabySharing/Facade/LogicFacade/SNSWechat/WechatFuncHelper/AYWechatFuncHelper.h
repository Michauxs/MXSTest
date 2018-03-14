//
//  AYWechatFuncHelper.h
//  BabySharing
//
//  Created by BM on 8/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYRemoteCallCommand.h"

@interface AYWechatFuncHelper : AYRemoteCallCommand

+ (NSString*)randomNonceStr;
+ (NSString*)paySignatureWithArgs:(NSDictionary*)args;
+ (NSString*)md5:(NSString*)seed;
@end
