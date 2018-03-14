//
//  AYExposeContentCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 7/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYExposeContentCommand.h"

@implementation AYExposeContentCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
