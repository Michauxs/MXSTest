//
//  AYCommand.h
//  BabySharing
//
//  Created by Alfred Yang on 3/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYCommandDefines.h"
#import "AYNotifyDefines.h"

//typedef void(^performFinishBlock)(BOOL, NSDictionary*);

@protocol AYCommand <NSObject>

@property (nonatomic, readonly, getter=getCommandType) NSString* command_type;
@property (nonatomic, strong) NSDictionary* para;

- (void)postPerform;
- (void)performWithResult:(NSObject**)obj;
//- (void)performWithBlock:(performFinishBlock)block;

@optional
- (void)pushCommandPara:(id)p withName:(NSString*)pn;
@end
