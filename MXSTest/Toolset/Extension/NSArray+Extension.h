//
//  NSArray+Extension.h
//  MXSTest
//
//  Created by Sunfei on 2021/12/8.
//  Copyright © 2021 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef id(^MXSItemMotage)(id item);
typedef NSArray* (^MXSMotageArray)(MXSItemMotage itemMotage);

typedef BOOL(^MXSItemFilter)(id item);
typedef NSArray* (^MXSFilterArray)(MXSItemFilter itemFilter);


NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Extension)

@property (nonatomic, strong) MXSMotageArray motage;
@property (nonatomic, strong) MXSFilterArray filter;

@end

NS_ASSUME_NONNULL_END
