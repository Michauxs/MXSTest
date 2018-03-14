//
//  AYNotiyCommand.h
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYCommand.h"

@protocol AYControllerBase;
@interface AYNotiyCommand : NSObject <AYCommand>

@property (nonatomic, weak) id<AYControllerBase> controller;
@property (nonatomic, strong) NSString* method_name;
@end
