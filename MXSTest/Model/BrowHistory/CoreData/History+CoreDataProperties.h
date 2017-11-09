//
//  History+CoreDataProperties.h
//  MXSTest
//
//  Created by Alfred Yang on 9/11/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//
//

#import "History+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface History (CoreDataProperties)

+ (NSFetchRequest<History *> *)fetchRequest;

@property (nonatomic) double date_send;
@property (nonatomic) BOOL is_read;
@property (nullable, nonatomic, copy) NSString *message_text;
@property (nullable, nonatomic, copy) NSString *receiver;
@property (nullable, nonatomic, copy) NSString *sender;

@end

NS_ASSUME_NONNULL_END
