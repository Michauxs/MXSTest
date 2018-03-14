//
//  AYCommentServiceCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 26/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYCommentServiceCommand.h"

@implementation AYCommentServiceCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}
@end
