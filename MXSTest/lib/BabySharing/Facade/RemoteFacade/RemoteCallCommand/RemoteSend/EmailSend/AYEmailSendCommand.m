//
//  AYEmailSendCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 13/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYEmailSendCommand.h"

@implementation AYEmailSendCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
