//
//  AYRejectOrderCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 18/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYRejectOrderCommand.h"

@implementation AYRejectOrderCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
