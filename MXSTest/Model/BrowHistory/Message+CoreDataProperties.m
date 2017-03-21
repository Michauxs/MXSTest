//
//  Message+CoreDataProperties.m
//  MXSTest
//
//  Created by Alfred Yang on 14/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Message+CoreDataProperties.h"

@implementation Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Message"];
}

@dynamic from;
@dynamic to;
@dynamic send_date;
@dynamic status;
@dynamic content;
@dynamic type;

@end
