//
//  AYRemoteCallManager.h
//  BabySharing
//
//  Created by Alfred Yang on 8/3/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYRemoteCallCommand.h"

//@class AYRemoteCallCommand;
@interface AYRemoteCallManager : NSObject

@property (nonatomic, assign) int remoteCount;
@property (nonatomic, strong) NSMutableArray *remoteCmdArr;

+ (AYRemoteCallManager *)shared;
- (void)postPerform;
- (void)performWithRemoteCmd:(AYRemoteCallCommand*)cmd andArgs:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block;
@end
