//
//  MXSHistoryModel.m
//  MXSTest
//
//  Created by Alfred Yang on 9/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "MXSHistoryModel.h"

static NSString *const LOCALDB_HISTORY_DATA = @"history_data.sqlite";

@implementation MXSHistoryModel

@synthesize doc = _doc;

+ (instancetype)shared {
	static MXSHistoryModel* instance = nil;
	if (instance == nil) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			instance = [[self alloc] init];
		});
	}
	return instance;
}

- (UIManagedDocument*)doc {
	
	if (!_doc) {
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
	return _doc;
}



- (void)enumDataFromLocalDB:(UIManagedDocument*)document {
	
	dispatch_async(dispatch_queue_create("load_data", NULL), ^(void){
		
		dispatch_async(dispatch_get_main_queue(), ^(void){
			[document.managedObjectContext performBlock: ^(void){
				NSLog(@"iCloud save complete");
				
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
