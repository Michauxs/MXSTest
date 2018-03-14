//
//  Providers.h
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LoginToken;

NS_ASSUME_NONNULL_BEGIN

@interface Providers : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
@property (nonatomic, retain) NSString * provider_name;
@property (nonatomic, retain) NSString * provider_screen_name;
@property (nonatomic, retain) NSString * provider_token;
@property (nonatomic, retain) NSString * provider_user_id;
@property (nonatomic, retain) NSString * provider_open_id;
@property (nonatomic, retain) LoginToken *user;
@end

NS_ASSUME_NONNULL_END

#import "Providers+CoreDataProperties.h"
