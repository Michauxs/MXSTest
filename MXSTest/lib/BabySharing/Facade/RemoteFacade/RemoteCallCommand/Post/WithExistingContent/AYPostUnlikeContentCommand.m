//
//  AYPostUnlikeContentCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/15/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostUnlikeContentCommand.h"

@implementation AYPostUnlikeContentCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
