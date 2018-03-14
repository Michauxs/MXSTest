//
//  AYViewNotifyCommand.h
//  BabySharing
//
//  Created by Alfred Yang on 3/29/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYCommand.h"

@protocol AYViewBase;
@interface AYViewNotifyCommand : NSObject <AYCommand>

@property (nonatomic, weak) id<AYViewBase> view;
@property (nonatomic, strong) NSString* method_name;
@property (nonatomic) BOOL need_args;
@end

#define  AYDelegateNotifyCommand AYViewNotifyCommand
