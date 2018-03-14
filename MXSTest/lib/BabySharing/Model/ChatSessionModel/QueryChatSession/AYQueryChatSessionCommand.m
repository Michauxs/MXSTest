//
//  AYQueryChatSessionCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/15/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYQueryChatSessionCommand.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYModelFacade.h"

#import "NotificationOwner.h"
#import "NotificationOwner+ContextOpt.h"

#import "Targets.h"
//#import "GotyeOCAPI.h"

#import "EMSDK.h"
#import "EMError.h"
#import "EMMessage.h"
#import "EMConversation.h"

@implementation AYQueryChatSessionCommand
@synthesize para = _para;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    NSLog(@"query chat session in local db");
    
    AYModelFacade* f = CHATSESSIONMODEL;

    NSDictionary* dic = nil;
    CURRENUSER(dic)
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"in_the_group=1 AND target_type=1"];
    NSArray* result = [NotificationOwner enumTargetForOwner:[dic objectForKey:@"user_id"] andPred:pred inContext:f.doc.managedObjectContext];
    
    for (Targets* t in result) {
        
        EMConversation* c = [[EMClient sharedClient].chatManager getConversation:t.group_id type:EMConversationTypeChatRoom createIfNotExist:NO];

        NSTimeInterval d = [NSDate date].timeIntervalSince1970;
        NSArray* result = [c loadMoreMessagesWithType:EMMessageBodyTypeText before:d limit:1 from:nil direction:EMMessageSearchDirectionDownload];
        if (result.count > 0) {
            EMMessage* m = result.firstObject;
            t.last_time = [NSDate dateWithTimeIntervalSinceNow:m.timestamp];
        }
    }
    
    *obj = [result sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Targets* left = (Targets*)obj1;
        Targets* right = (Targets*)obj2;
        if (left.last_time.timeIntervalSince1970 < right.last_time.timeIntervalSince1970) return NSOrderedDescending;
        else if (left.last_time.timeIntervalSince1970 > right.last_time.timeIntervalSince1970) return NSOrderedAscending;
        else return NSOrderedSame;
    }];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}
@end
