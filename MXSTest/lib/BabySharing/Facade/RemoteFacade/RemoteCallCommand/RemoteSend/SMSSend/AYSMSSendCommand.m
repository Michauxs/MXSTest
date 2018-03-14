//
//  AYSMSSendCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 27/5/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSMSSendCommand.h"

@implementation AYSMSSendCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
