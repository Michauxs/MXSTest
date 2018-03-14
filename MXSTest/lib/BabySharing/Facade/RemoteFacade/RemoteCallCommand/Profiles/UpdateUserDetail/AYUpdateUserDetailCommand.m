//
//  AYUpdateUserDetailCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYUpdateUserDetailCommand.h"

@implementation AYUpdateUserDetailCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
