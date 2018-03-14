//
//  AYAPNNotificationCommand.h
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYCommand.h"

@interface AYAPNNotificationCommand : NSObject <AYCommand>

+ (id)sharedInstance;
@end
