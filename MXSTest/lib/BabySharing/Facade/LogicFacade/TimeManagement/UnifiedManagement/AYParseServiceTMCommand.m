//
//  AYParseServiceTMCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 19/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYParseServiceTMCommand.h"

@implementation AYParseServiceTMCommand

@synthesize para = _para;

- (void)postPerform {
	
}

- (void)performWithResult:(NSObject**)obj {
	// need to modify
//	NSArray* tms = (NSArray*)*obj;
	
	NSArray* result = [[NSArray alloc]init];
	
	
	*obj = result;
}

- (NSString*)getCommandType {
	return kAYFactoryManagerCommandTypeModule;
}

@end
