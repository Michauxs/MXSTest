//
//  DetailInfo+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DetailInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSDate *dob;
@property (nullable, nonatomic, retain) NSString *home;
@property (nullable, nonatomic, retain) NSNumber *horoscope;
@property (nullable, nonatomic, retain) NSString *school;
@property (nullable, nonatomic, retain) NSSet<UserKids *> *kids;
@property (nullable, nonatomic, retain) LoginToken *who;

@end

@interface DetailInfo (CoreDataGeneratedAccessors)

- (void)addKidsObject:(UserKids *)value;
- (void)removeKidsObject:(UserKids *)value;
- (void)addKids:(NSSet<UserKids *> *)values;
- (void)removeKids:(NSSet<UserKids *> *)values;

@end

NS_ASSUME_NONNULL_END
