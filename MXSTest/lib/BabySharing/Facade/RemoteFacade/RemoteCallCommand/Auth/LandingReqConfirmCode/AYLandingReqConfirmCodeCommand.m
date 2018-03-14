//
//  AYLandingReqConfirmCode.m
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingReqConfirmCodeCommand.h"

@implementation AYLandingReqConfirmCodeCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
