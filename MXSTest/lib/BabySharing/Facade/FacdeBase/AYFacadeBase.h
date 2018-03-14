//
//  AYFacadeBase.h
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYFacadeBase_h
#define AYFacadeBase_h

#import "AYCommand.h"

@protocol AYFacadeBase <NSObject, AYCommand>

@property (nonatomic, strong) NSMutableArray* observer;
@property (nonatomic, strong) NSDictionary* commands;        

@property (nonatomic, readonly, getter=getFacadeType) NSString* facade_type;
@property (nonatomic, readonly, getter=getFacadeName) NSString* facade_name;
@end
#endif /* AYFacadeBase_h */
