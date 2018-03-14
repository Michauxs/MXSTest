//
//  LoginToken+CoreDataClass.h
//  BabySharing
//
//  Created by BM on 29/09/2016.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CurrentToken, DetailInfo, Providers, RegCurrentToken;

NS_ASSUME_NONNULL_BEGIN

@interface LoginToken : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "LoginToken+CoreDataProperties.h"
