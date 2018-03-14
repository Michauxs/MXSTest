//
//  AYFactoryParaNode.m
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFactoryParaNode.h"

@implementation AYFactoryParaNode
@synthesize type = _type;
@synthesize name = _name;

- (id)initWithType:(NSString*)type andName:(NSString*)name {
    self = [super init];
    if (self) {
        _type = type;
        _name = name;
    }
    return self;
}
@end
