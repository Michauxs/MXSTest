//
//  UserKids+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "UserKids.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserKids (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSDate *dob;
@property (nullable, nonatomic, retain) NSNumber *gender;
@property (nullable, nonatomic, retain) NSNumber *horoscope;
@property (nullable, nonatomic, retain) NSString *school;
@property (nullable, nonatomic, retain) DetailInfo *parent;

@end

NS_ASSUME_NONNULL_END
