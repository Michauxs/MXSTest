//
//  Providers+CoreDataProperties.h
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Providers.h"

NS_ASSUME_NONNULL_BEGIN

@interface Providers (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *provider_name;
@property (nullable, nonatomic, retain) NSString *provider_open_id;
@property (nullable, nonatomic, retain) NSString *provider_screen_name;
@property (nullable, nonatomic, retain) NSString *provider_token;
@property (nullable, nonatomic, retain) NSString *provider_user_id;
@property (nullable, nonatomic, retain) LoginToken *user;

@end

NS_ASSUME_NONNULL_END
