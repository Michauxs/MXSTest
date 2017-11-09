//
//  History+CoreDataProperties.m
//  MXSTest
//
//  Created by Alfred Yang on 9/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//
//

#import "History+CoreDataProperties.h"

@implementation History (CoreDataProperties)

+ (NSFetchRequest<History *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"History"];
}

@dynamic date_send;
@dynamic is_read;
@dynamic message_text;
@dynamic receiver;
@dynamic sender;

@end
