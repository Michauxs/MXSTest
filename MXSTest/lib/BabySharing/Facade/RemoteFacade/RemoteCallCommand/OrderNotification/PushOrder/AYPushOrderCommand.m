//
//  AYPushOrderCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPushOrderCommand.h"

@implementation AYPushOrderCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
