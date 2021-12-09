//
//  MXSHero.m
//  MXSTest
//
//  Created by Sunfei on 2021/12/8.
//  Copyright © 2021 Alfred Yang. All rights reserved.
//

#import "MXSHero.h"

@implementation MXSHero
- (MXSHero *(^)(int))sleep {
    return ^(int minute) {
        NSLog(@"sleeped for %d minute", minute);
        return self;
    };
}
/**
 */
- (duration)drink {
    return ^(int minute) {
        NSLog(@"fighted for %d mimute", minute);
        return self;
    };
    
//    duration dua = ^MXSHero*(int minute) {
//        NSLog(@"fighted for %d mimute", minute);
//        return self;
//    };
//    return dua;
}

- (duration)fight {
    duration dua = ^MXSHero*(int minute) {
        NSLog(@"fighted for %d mimute", minute);
        return self;
    };
    
    return dua;
}



- (void (^)(int))throwone {
    return ^(int one) {
        NSLog(@"throw one %d", one);
    };
}

- (void)throwSign:(int)sign {
    void (^signBlock)(int numb) = ^(int numb) {
        NSLog(@"throw one %d", numb);
    };
    
    signBlock(sign);
    NSLog(@"throw one --- %d", sign);
}

@end
