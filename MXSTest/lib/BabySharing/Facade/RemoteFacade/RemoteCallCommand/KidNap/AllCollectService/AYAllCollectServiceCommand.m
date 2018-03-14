//
//  AYAllCollectServiceCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 17/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYAllCollectServiceCommand.h"

@implementation AYAllCollectServiceCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
