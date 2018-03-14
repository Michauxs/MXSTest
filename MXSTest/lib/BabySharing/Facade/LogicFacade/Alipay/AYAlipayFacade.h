//
//  AYAlipayFacade.h
//  BabySharing
//
//  Created by BM on 21/02/2017.
//  Copyright © 2017 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYFacade.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AYAlipayFacade : AYFacade
@property (readonly, strong) CompletionBlock cltBlock;
@end
