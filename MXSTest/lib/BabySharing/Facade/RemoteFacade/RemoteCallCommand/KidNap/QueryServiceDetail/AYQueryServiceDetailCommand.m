//
//  AYQueryServiceDetailCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 12/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYQueryServiceDetailCommand.h"

@implementation AYQueryServiceDetailCommand

- (void)postPerform {
	NSLog(@"host path is : %@", self.route);
}
@end
