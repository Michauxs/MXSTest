//
//  AYPostLikeContentCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/15/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostLikeContentCommand.h"

@implementation AYPostLikeContentCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
