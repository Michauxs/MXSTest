//
//  AYChatSessionModelFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 4/15/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYChatSessionModelFacade.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AYNotifyDefines.h"

static NSString* const LOCALDB_LOGIN = @"notifyData.sqlite";

@implementation AYChatSessionModelFacade

@synthesize doc = _doc;

- (void)postPerform {
    [super postPerform];
    
    /**
     * get authorised user array in the local database
     */
    if (_doc == nil) {
        NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSURL* url =[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:LOCALDB_LOGIN]];
        _doc = (UIManagedDocument*)[[UIManagedDocument alloc] initWithFileURL:url];
        
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
        _doc.persistentStoreOptions = options;
        
        BOOL isDir = NO;
        if (![[NSFileManager defaultManager]fileExistsAtPath:[url path] isDirectory:&isDir]) {
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
}

- (void)enumDataFromLocalDB:(UIManagedDocument*)document {
//    dispatch_queue_t aq = dispatch_queue_create("load_data", NULL);
//    dispatch_async(aq, ^(void){
//        dispatch_async(dispatch_get_main_queue(), ^(void){
//            [document.managedObjectContext performBlock: ^(void){
//                NSMutableDictionary* notify = [[NSMutableDictionary alloc]init];
//                [notify setValue:kAYNotifyActionKeyNotify forKey:kAYNotifyActionKey];
//                [notify setValue:kAYNotifyLoginModelReady forKey:kAYNotifyFunctionKey];
//                
//                NSMutableDictionary* args = [[NSMutableDictionary alloc]init];
//                [notify setValue:[args copy] forKey:kAYNotifyArgsKey];
//                [self performWithResult:&notify];
//            }];
//        });
//    });
}
@end
