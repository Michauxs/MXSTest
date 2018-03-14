//
//  AYQueryUserDetailCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryUserProfileCommand.h"

@implementation AYQueryUserProfileCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
