//
//  NSArray+Extension.m
//  MXSTest
//
//  Created by Sunfei on 2021/12/8.
//  Copyright © 2021 Alfred Yang. All rights reserved.
//

#import "NSArray+Extension.h"

@implementation NSArray (Extension)

- (MXSMotageArray)motage {
    MXSMotageArray motg = ^id(MXSItemMotage itemMotage) {
        NSMutableArray *tmp = [NSMutableArray new];
        for (id item in self) {
            [tmp addObject:itemMotage(item)];
            NSLog(@"motage -one");
        }
        return tmp;
    };
    NSLog(@"motage done");
    return motg;
}


- (MXSFilterArray)filter {
    MXSFilterArray array = ^NSArray*(MXSItemFilter itemFilter) {
        NSMutableArray *tmp = [NSMutableArray new];
        for (id item in self) {
            if (itemFilter(item)) [tmp addObject:item];
        }
        return tmp;
    };
    NSLog(@"filter done");
    return array;
}

@end
