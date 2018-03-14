//
//  AYAPNNotificationCommandFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYAPNNotificationCommandFactory.h"
#import "AYAPNNotificationCommand.h"

@implementation AYAPNNotificationCommandFactory

@synthesize para = _para;

+ (id)factoryInstance {
    return [[self alloc]init];
}

- (id)createInstance {
    AYAPNNotificationCommand* cmd = [AYAPNNotificationCommand sharedInstance];
    return cmd;
}
@end
