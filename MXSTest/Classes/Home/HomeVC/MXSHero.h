//
//  MXSHero.h
//  MXSTest
//
//  Created by Sunfei on 2021/12/8.
//  Copyright © 2021 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MXSHero : NSObject

typedef MXSHero*(^duration)(int minute);

- (duration)fight;
- (duration)drink;

- (MXSHero *(^)(int))sleep;


- (void(^)(int))throwone;

- (void)throwSign:(int)sign;

@end

