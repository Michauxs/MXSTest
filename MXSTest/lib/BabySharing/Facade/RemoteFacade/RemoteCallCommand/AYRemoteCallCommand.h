//
//  AYRemoteCallCommand.h
//  BabySharing
//
//  Created by Alfred Yang on 3/27/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYFacade.h"
//#import "AYRemoteCallManager.h"

@interface AYRemoteCallCommand : NSObject <AYCommand>

@property (nonatomic, strong) NSString* route;

- (void)beforeAsyncCall;
- (void)performWithResult:(NSDictionary*)args andFinishBlack:(asynCommandFinishBlock)block;
- (void)endAsyncCall;
@end
