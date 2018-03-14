//
//  AYExposeUserCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 7/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYExposeUserCommand.h"

@implementation AYExposeUserCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
