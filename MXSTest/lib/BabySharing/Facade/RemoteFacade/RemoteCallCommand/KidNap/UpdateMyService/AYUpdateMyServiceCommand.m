//
//  AYUpdateMyServiceCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 5/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYUpdateMyServiceCommand.h"

@implementation AYUpdateMyServiceCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
