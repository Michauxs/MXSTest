//
//  AYLandingAuthConfirm.m
//  BabySharing
//
//  Created by Alfred Yang on 3/27/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLandingAuthConfirmCommand.h"

@implementation AYLandingAuthConfirmCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
