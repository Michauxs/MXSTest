//
//  Message+CoreDataProperties.h
//  MXSTest
//
//  Created by Alfred Yang on 14/3/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Message+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Message (CoreDataProperties)

+ (NSFetchRequest<Message *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSString *to;
@property (nonatomic) double send_date;
@property (nonatomic) int32_t status;
@property (nullable, nonatomic, copy) NSString *content;
@property (nonatomic) int32_t type;

@end

NS_ASSUME_NONNULL_END
