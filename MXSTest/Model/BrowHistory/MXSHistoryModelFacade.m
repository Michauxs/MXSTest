//
//  MXSHistoryModel.m
//  MXSTest
//
//  Created by Alfred Yang on 9/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSHistoryModelFacade.h"

static NSString *const LOCALDB_HISTORY_DATA = @"history_data.sqlite";

@implementation MXSHistoryModelFacade

- (instancetype)init {
	self = [super init];
	if (self) {
		NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
		NSURL *url = [NSURL fileURLWithPath:[docStr stringByAppendingPathComponent:LOCALDB_HISTORY_DATA]];
		_doc = [[UIManagedDocument alloc] initWithFileURL:url];
		
		NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES,
								  NSInferMappingModelAutomaticallyOption:@YES};
		_doc.persistentStoreOptions = options;
		
		BOOL isDir = NO;
		if (![[NSFileManager defaultManager] fileExistsAtPath:[url path] isDirectory:&isDir]) {
			[_doc saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
				[self enumDataFromLocalDB:_doc];
			}];
		} else if (_doc.documentState == UIDocumentStateClosed) {
			[_doc openWithCompletionHandler:^(BOOL success){
				[self enumDataFromLocalDB:_doc];
			}];
		} else if (_doc.documentState == UIDocumentStateInConflict) {
			[_doc saveToURL:url forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success){
				[self enumDataFromLocalDB:_doc];
			}];
		} else {
			
		}
	}
	return self;
}

- (void)enumDataFromLocalDB:(UIManagedDocument*)document {
	
	dispatch_async(dispatch_queue_create("load_data", NULL), ^(void){
		
		dispatch_async(dispatch_get_main_queue(), ^(void){
			[document.managedObjectContext performBlock: ^(void){
				NSLog(@"exception complete");
				
//				NSMutableDictionary* notify = [[NSMutableDictionary alloc] init];
//				[notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
//				[notify setValue:kAYNotifyLoginModelReady forKey:kAYNotifyFunctionKey];
//
//				NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
//				[notify setValue:[args copy] forKey:kAYNotifyArgsKey];
//				[self performWithResult:&notify];
			}];
		});
		
	});
}
@end
