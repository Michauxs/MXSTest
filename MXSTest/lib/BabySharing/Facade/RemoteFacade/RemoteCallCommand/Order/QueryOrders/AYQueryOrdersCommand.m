//
//  AYQueryOrdersCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYQueryOrdersCommand.h"

@implementation AYQueryOrdersCommand
- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
