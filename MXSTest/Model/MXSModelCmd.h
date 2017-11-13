//
//  MXSModelCmd.h
//  MXSTest
//
//  Created by Alfred Yang on 9/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXSHistoryModelFacade.h"
#import "History+ContextOpt.h"

@interface MXSModelCmd : NSObject

@property (nonatomic, strong) MXSHistoryModelFacade *FacadeHistory;
@property (nonatomic, strong) History *history;


+ (instancetype)shared;

- (void)appendData:(NSString*)object withData:(NSDictionary*)args;

- (NSArray*)enumAllData:(NSString*)object;
- (NSArray*)searchData:(NSString*)object withKV:(NSDictionary*)args;

- (void)removeAllData:(NSString*)object;
- (void)removeData:(NSString*)object withKV:(NSDictionary*)args;


@end
