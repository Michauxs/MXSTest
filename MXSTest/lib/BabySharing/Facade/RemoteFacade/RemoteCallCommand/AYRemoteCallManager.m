//
//  AYRemoteCallManager.m
//  BabySharing
//
//  Created by Alfred Yang on 8/3/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import "AYRemoteCallManager.h"

@implementation AYRemoteCallManager 

+ (AYRemoteCallManager *)shared {
	static dispatch_once_t once;
	static AYRemoteCallManager *instance;
	dispatch_once(&once, ^{
		instance = [self new];
		[instance postPerform];
	});
	return instance;
}

- (void)postPerform {
	
	_remoteCount = 0;
	_remoteCmdArr = [NSMutableArray array];
}

- (void)performWithRemoteCmd:(AYRemoteCallCommand*)cmd andArgs:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block {

	_remoteCount++;
	if (_remoteCount < 6) {
		[cmd performWithResult:args andFinishBlack:^(BOOL success, NSDictionary *result) {
			
			dispatch_async(dispatch_get_main_queue(), ^{
				block(success, result);
				[self performNextCmd];
			});
		}];
	} else {
		NSDictionary *cmdArgs = @{@"cmd":cmd, @"args":args, @"block":block};
		[_remoteCmdArr addObject:cmdArgs];
	}
	
}

- (void)performNextCmd {
	_remoteCount--;
	if (_remoteCmdArr.count != 0) {
		
		NSDictionary *cmdArgs = _remoteCmdArr.firstObject;
		AYRemoteCallCommand *cmd = [cmdArgs objectForKey:@"cmd"];
		NSDictionary *args = [cmdArgs objectForKey:@"args"];
		asynCommandFinishBlock block = [cmdArgs objectForKey:@"block"];
		
		[_remoteCmdArr removeObject:cmdArgs];
		
		[cmd performWithResult:args andFinishBlack:^(BOOL success, NSDictionary *result) {
			dispatch_async(dispatch_get_main_queue(), ^{
				block(success, result);
			
				[self performNextCmd];
			});
		}];
	}
}

@end
