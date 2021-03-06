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
+ (NSArray*)searchDataInContext:(NSManagedObjectContext*)context withKV:(NSDictionary*)args;

+ (void)removeAllDataInContext:(NSManagedObjectContext*)context;
+ (void)removeDataInContext:(NSManagedObjectContext*)context withKV:(NSDictionary*)args;

@end
