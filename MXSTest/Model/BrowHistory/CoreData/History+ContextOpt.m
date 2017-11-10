//
//  History+ContextOpt.m
//  MXSTest
//
//  Created by Alfred Yang on 9/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "History+ContextOpt.h"

static NSString *const ENTITY_NAME = @"History";

@implementation History (ContextOpt)

+ (void)appendDataInContext:(NSManagedObjectContext*)context withData:(NSDictionary*)args {
	
	History *new = [NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:context];
	new.sender = [args objectForKey:kMXSHistoryModelArgsSender];
	new.receiver = [args objectForKey:kMXSHistoryModelArgsReceiver];
	new.message_text = [args objectForKey:kMXSHistoryModelArgsMessageText];
	new.date_send = [[args objectForKey:kMXSHistoryModelArgsDateSend] doubleValue];
	new.is_read = [[args objectForKey:kMXSHistoryModelArgsIsRead] boolValue];
	
	[context save:nil];
	
	NSLog(@"save complete");
}

+ (NSArray*)enumAllDataInContext:(NSManagedObjectContext*)context {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
	
	NSError *err = nil;
	NSArray *matches = [context executeFetchRequest:request error:&err];
	
	if (!err) {
		return [self parseModeWithMatches:matches];
	} else
		return nil;
}

+ (NSArray*)searchDataInContext:(NSManagedObjectContext*)context withSender:(id)sender {
	NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
	request.predicate = [NSPredicate predicateWithFormat:@"sender = %@", sender];
	
	NSError* err = nil;
	NSArray* matches = [context executeFetchRequest:request error:&err];
	if (!err) {
		return [self parseModeWithMatches:matches];
	} else
		return nil;
}

+ (void)removeDataInContext:(NSManagedObjectContext*)context withMate:(id)mate {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
	request.predicate = [NSPredicate predicateWithFormat:@"sender = %@", mate];
	
	NSError *err = nil;
	NSArray *matches = [context executeFetchRequest:request error:&err];
	for (History *his in matches) {
		[context deleteObject:his];
	}
	
	NSLog(@"remove complete");
}

+ (void)removeAllDataInContext:(NSManagedObjectContext*)context {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:ENTITY_NAME];
	
	NSError *err = nil;
	NSArray *matches = [context executeFetchRequest:request error:&err];
	for (History *his in matches) {
		[context deleteObject:his];
	}
	
	NSLog(@"remove complete");
}

#pragma mark - common actions
+ (NSArray*)parseModeWithMatches:(NSArray*)matches {
	
	NSMutableArray *back = [NSMutableArray array];
	for (History *his in matches) {
		NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
		[tmp setValue:his.sender forKey:kMXSHistoryModelArgsSender];
		[tmp setValue:his.receiver forKey:kMXSHistoryModelArgsReceiver];
		[tmp setValue:his.message_text forKey:kMXSHistoryModelArgsMessageText];
		[tmp setValue:[NSNumber numberWithBool:his.is_read] forKey:kMXSHistoryModelArgsIsRead];
		[tmp setValue:[NSNumber numberWithDouble:his.date_send] forKey:kMXSHistoryModelArgsDateSend];
		[back addObject:tmp];
	}
	return [back copy];
}

@end
