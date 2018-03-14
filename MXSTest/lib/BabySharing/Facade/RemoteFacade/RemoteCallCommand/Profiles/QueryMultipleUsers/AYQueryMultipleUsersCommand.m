//
//  AYQueryMultipleUsersCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/14/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryMultipleUsersCommand.h"

@implementation AYQueryMultipleUsersCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
