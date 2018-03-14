//
//  AYCreateTmpUserWithPhoneCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYCreateTmpUserWithPhoneCommand.h"

@implementation AYCreateTmpUserWithPhoneCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
