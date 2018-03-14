//
//  AYViewBase.h
//  BabySharing
//
//  Created by Alfred Yang on 3/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYViewBase_h
#define AYViewBase_h

#import "AYCommand.h"

@protocol AYControllerBase;

@protocol AYViewBase <NSObject, AYCommand>

@property (nonatomic, strong) NSDictionary* commands;
@property (nonatomic, strong) NSDictionary* notifies;
//@property (nonatomic, weak) id<AYControllerBase> controller;
@property (nonatomic, weak) id controller;

@property (nonatomic, readonly, getter=getViewType) NSString* view_type;
@property (nonatomic, readonly, getter=getViewName) NSString* view_name;

@optional
- (id)queryObjectWithIdentifier:(NSString*)identifier;
@end

#endif /* AYViewBase_h */

#define AYDelegateBase AYViewBase