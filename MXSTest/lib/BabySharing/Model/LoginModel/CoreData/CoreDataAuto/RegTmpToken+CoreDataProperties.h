//
//  RegTmpToken+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "RegTmpToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface RegTmpToken (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *phoneNo;
@property (nullable, nonatomic, retain) NSString *reg_token;

@end

NS_ASSUME_NONNULL_END
