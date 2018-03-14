//
//  AYAlipayFacade.m
//  BabySharing
//
//  Created by BM on 21/02/2017.
//  Copyright © 2017 Alfred Yang. All rights reserved.
//

#import "AYAlipayFacade.h"

@implementation AYAlipayFacade

@synthesize cltBlock = _cltBlock;

- (instancetype)init {
    self = [super init];
    if (self) {
        id<AYFacadeBase> this = self;
        _cltBlock = ^(NSDictionary* resultDic) {
            NSInteger resultStatus = ((NSNumber*)[resultDic objectForKey:@"resultStatus"]).integerValue;
            
            switch (resultStatus) {
                case 9000: {     // 订单支付成功
                        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
                        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
                        [notify setValue:kAYAlipaySuccess forKey:kAYNotifyFunctionKey];
                        
                        id args = [resultDic objectForKey:@"result"];
                        [notify setValue:args forKey:kAYNotifyArgsKey];
                        [this performWithResult:&notify];
                    }
                    break;
                case 8000:      // 正在处理中
                case 4000:      // 订单支付失败
                case 6001:      // 用户中途取消
                case 6002:      // 网络连接出错
                    {
                        NSString* msg = (NSString*)[resultDic objectForKey:@"memo"];
                        
                        NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
                        [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
                        [notify setValue:kAYAlipayFailed forKey:kAYNotifyFunctionKey];
                        
                        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
                        [dic setValue:[NSNumber numberWithInteger:resultStatus] forKey:@"code"];
                        [dic setValue:msg forKey:@"message"];
                        
                        [notify setValue:[dic copy] forKey:kAYNotifyArgsKey];
                        [this performWithResult:&notify];
                    }
                default:
                    break;
            }
        };
    }
    
    return self;
}
@end
