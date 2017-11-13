//
//  MXSModelCmd.m
//  MXSTest
//
//  Created by Alfred Yang on 9/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSModelCmd.h"

@implementation MXSModelCmd

+ (instancetype)shared {
	static MXSModelCmd* instance = nil;
	if (instance == nil) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			instance = [[self alloc] init];
		});
	}
	return instance;
}

- (instancetype)init {
	if (self = [super init]) {
		
	}
	return self;
}

- (MXSHistoryModelFacade*)FacadeHistory {
	if (!_FacadeHistory) {
		_FacadeHistory = [[MXSHistoryModelFacade alloc] init];
	}
	return _FacadeHistory;
}

- (void)appendData:(NSString*)object withData:(NSDictionary*)args {
	[History appendDataInContext:[self FacadeHistory].doc.managedObjectContext withData:args];
}

- (NSArray*)enumAllData:(NSString*)object {
	return [History enumAllDataInContext:[self FacadeHistory].doc.managedObjectContext];
}

- (NSArray*)searchData:(NSString*)object withKV:(NSDictionary*)args {
	return [History searchDataInContext:[self FacadeHistory].doc.managedObjectContext withKV:args];
}

- (void)removeAllData:(NSString*)object {
	[History removeAllDataInContext:[self FacadeHistory].doc.managedObjectContext];
}

- (void)removeData:(NSString*)object withKV:(NSDictionary*)args {
	[History removeDataInContext:[self FacadeHistory].doc.managedObjectContext withKV:args];
}

@end
