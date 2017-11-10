//
//  History+ContextOpt.h
//  MXSTest
//
//  Created by Alfred Yang on 9/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "History+CoreDataClass.h"

@interface History (ContextOpt)

+ (void)appendDataInContext:(NSManagedObjectContext*)context withData:(NSDictionary*)args;

+ (NSArray*)enumAllDataInContext:(NSManagedObjectContext*)context;
+ (NSArray*)searchDataInContext:(NSManagedObjectContext*)context withSender:(id)sender;

+ (void)removeAllDataInContext:(NSManagedObjectContext*)context;
+ (void)removeDataInContext:(NSManagedObjectContext*)context withMate:(id)mate;

@end
