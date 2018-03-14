//
//  AYPushPersonalInfoCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 13/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPushServiceInfoCommand.h"

@implementation AYPushServiceInfoCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
