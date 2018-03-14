//
//  AYUnCollectServiceCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 17/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYUnCollectServiceCommand.h"

@implementation AYUnCollectServiceCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
