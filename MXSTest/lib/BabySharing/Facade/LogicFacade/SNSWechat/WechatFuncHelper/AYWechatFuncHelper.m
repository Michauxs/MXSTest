//
//  AYWechatFuncHelper.m
//  BabySharing
//
//  Created by BM on 8/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYWechatFuncHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import "AYSNSWechatDefines.h"

@implementation AYWechatFuncHelper

+ (NSString*)randomNonceStr {
    return @"b927722419c52622651a871d1d9ed8b2";
}

+ (NSString*)paySignatureWithArgs:(NSDictionary*)args {
    //sort by values
    NSString* str = @"";
    
    NSArray * keys = [[args allKeys] sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
                          //return [obj2 compare:obj1]; //descending
                          return [obj1 compare:obj2]; //ascending
                      }];
    
    for (NSString* iter in keys) {
        NSString* v = [args objectForKey:iter];
        if (str.length == 0)
            str = [self combineKey:iter andValue:v];
        else
            str = [[str stringByAppendingString:@"&"] stringByAppendingString:[self combineKey:iter andValue:v]];
    }
    
    str = [self md5:[[str stringByAppendingString:@"&"] stringByAppendingString:[@"key=" stringByAppendingString:AYDONGDAPARTNERKEY]]];
    
    return str;
}

+ (NSString*)combineKey:(NSString*)key andValue:(NSString*)value {
    return [[key stringByAppendingString:@"="] stringByAppendingString:value];
}

+ (NSString *) md5:(NSString*)seed {
    const char *cStr = [seed UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (unsigned)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] uppercaseString];
}
@end
