//
//  MXSVCBase.h
//  MXSTest
//
//  Created by Alfred Yang on 7/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MXSVCBase <NSObject>

@optional
- (void)ReceiveCmdArgsActionPost:(id)args;
- (void)ReceiveCmdArgsActionBack:(id)args;

@end
