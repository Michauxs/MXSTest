//
//  AYControllerBase.h
//  BabySharing
//
//  Created by Alfred Yang on 3/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYControllerBase_h
#define AYControllerBase_h

#import "AYCommand.h"
#import <UIKit/UIKit.h>
#import "AYCommandDefines.h"

@protocol AYViewBase;
@protocol AYControllerBase <NSObject, AYCommand>

@property (nonatomic, strong) NSDictionary* commands;
@property (nonatomic, strong) NSDictionary* facades;
@property (nonatomic, strong) NSDictionary* delegates;
@property (nonatomic, strong) NSDictionary* views;

@property (nonatomic, readonly, getter=getControllerType) NSString* controller_type;
@property (nonatomic, readonly, getter=getControllerName) NSString* controller_name;

- (id)performForView:(id<AYViewBase>)from andFacade:(NSString*)facade_name andMessage:(NSString*)command_name andArgs:(NSDictionary*)args;

- (id)startRemoteCall:(id)obj;
- (id)endRemoteCall:(id)obj;
@end

#endif /* AYControllerBase_h */
