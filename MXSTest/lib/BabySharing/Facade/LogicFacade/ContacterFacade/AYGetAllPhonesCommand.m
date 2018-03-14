//
//  AYContacterFacade.m
//  BabySharing
//
//  Created by Alfred Yang on 18/4/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYGetAllPhonesCommand.h"

@implementation AYGetAllPhonesCommand

@synthesize command_type = _command_type;
@synthesize para = _para;

- (void)postPerform{
    tmpAddressBook = [[CNContactStore alloc]init];
    people = [[NSMutableArray alloc]init];

    if (tmpAddressBook) {
        CNContactFetchRequest* req = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]];
        req.predicate = nil;
        NSError* err = nil;
        if ([tmpAddressBook enumerateContactsWithFetchRequest:req error:&err usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            *stop = NO;
            [people addObject:contact];
        }]) {
            none_friend_lst = people;
            people_all = [people copy];
        } else {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:[err.userInfo objectForKey:NSLocalizedDescriptionKey] message:[err.userInfo objectForKey:NSLocalizedFailureReasonErrorKey] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}
- (void)performWithResult:(NSObject**)obj{
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (id)getAllPhones {
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    for (CNContact* tmpPerson in people) {
        
        NSArray<CNLabeledValue<CNPhoneNumber*>*>* phones = tmpPerson.phoneNumbers;
        
        for (int index = 0; index < phones.count; ++index) {
            NSString* phoneNo = [phones objectAtIndex:index].value.stringValue;
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@" " withString:@""];
            phoneNo = [phoneNo stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [arr addObject:phoneNo];
        }
    }
    return [arr copy];
}
@end
