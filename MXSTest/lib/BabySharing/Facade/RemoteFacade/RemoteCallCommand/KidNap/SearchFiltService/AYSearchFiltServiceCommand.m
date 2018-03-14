//
//  AYQueryMMWithLocationCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 3/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSearchFiltServiceCommand.h"

@implementation AYSearchFiltServiceCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
