//
//  MXSStudent.h
//  MXSTest
//
//  Created by Sunfei on 2018/5/14.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXSStudent : NSObject <NSCoding>

//- (instancetype)initWithCoder:(NSCoder *)aDecoder infoData:(id)data;

@property(nonatomic,copy) NSArray *keys;

@property (nonatomic, copy) NSDictionary *infoData;
@end
