//
//  AYContacterFacade.h
//  BabySharing
//
//  Created by Alfred Yang on 18/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AYFacade.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"

#import <Contacts/CNContact.h>
#import <Contacts/CNContactStore.h>
#import <Contacts/CNContactFetchRequest.h>

@interface AYGetAllPhonesCommand : NSObject <AYCommand>{
    
    CNContactStore* tmpAddressBook;
    
    NSArray* people_all;
    NSMutableArray* people;
    
    NSArray* friend_profile_lst;
    NSArray* friend_lst;
    NSArray* none_friend_lst;
}

@end
