//
//  AYQueryApplyOrdersCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 6/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYQueryApplyOrdersCommand.h"

@implementation AYQueryApplyOrdersCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
