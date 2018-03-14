//
//  AYAppInitCommandFactory.m
//  BabySharing
//
//  Created by Alfred Yang on 3/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYAppInitCommandFactory.h"
#import "AYFactoryManager.h"
#import "AYAppInitCommand.h"

@implementation AYAppInitCommandFactory

@synthesize para = _para;

+ (id)factoryInstance {
    return [[self alloc]init];
}

- (id)createInstance {
    AYAppInitCommand* command = [[AYAppInitCommand alloc]init];
    command.para = self.para;
	[command postPerform];
    return command;
}
@end
