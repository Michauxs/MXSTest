//
//  AYAuthSignOutCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/12/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYAuthSignOutCommand.h"

@implementation AYAuthSignOutCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
