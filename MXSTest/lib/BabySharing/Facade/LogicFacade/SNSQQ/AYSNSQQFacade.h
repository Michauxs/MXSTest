//
//  AYSNSQQFacade.h
//  BabySharing
//
//  Created by Alfred Yang on 3/24/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFacade.h"

@class TencentOAuth;

@interface AYSNSQQFacade : AYFacade

@property (nonatomic, strong) TencentOAuth* qq_oauth;
@property (nonatomic, strong) NSArray* permissions;
@end
