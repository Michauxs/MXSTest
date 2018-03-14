//
//  AYAlipayPayCommand.m
//  BabySharing
//
//  Created by BM on 21/02/2017.
//  Copyright © 2017 Alfred Yang. All rights reserved.
//

#import "AYAlipayPayCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYNotifyDefines.h"
#import "AYAlipayDefines.h"

#import "Order.h"
#import "APAuthV2Info.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>



@implementation AYAlipayPayCommand

@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
    NSString *appID = AYDONGDAALIPAYID;
    NSString *rsaPrivateKey = AYDONGDARSAPRIVATEKEY;
    NSString *rsa2PrivateKey = AYDONGDARSA2PRIVATEKEY;
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
	NSDictionary* args = (NSDictionary*)*obj;
    // TODO: 从传进来的地方获取 @孙飞
    order.biz_content = [BizContent new];
	order.biz_content.body = @"咚哒服务费";
	order.biz_content.subject = @"咚哒服务费";
    order.biz_content.out_trade_no = [args objectForKey:kAYOrderArgsID]; //订单ID（由商家自行制定，同微信，从服务端获取, @孙飞）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
	NSString *total_amount = [NSString stringWithFormat:@"%.2f", ((NSNumber*)[args objectForKey:kAYOrderArgsTotalFee]).floatValue * 0.01]; //商品价格
#ifdef SANDBOX
	total_amount = @"0.01";
#endif
    order.biz_content.total_amount = total_amount; //商品价格
    // TODO: 商品价格需要特别注意，因为和微信的处理当位是不一样的 @孙飞
	
//	// NOTE: 销售产品码，商家和支付宝签约的产品码 (如 QUICK_MSECURITY_PAY)
//	order.biz_content.product_code = @"QUICK_MSECURITY_PAY";
	
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:AYDONGDAALIPAYSCHEME callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }

}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
@end
