//
//  AYFactoryParaNode.h
//  BabySharing
//
//  Created by Alfred Yang on 4/10/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYFactoryParaNode : NSObject
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* name;

- (id)initWithType:(NSString*)type andName:(NSString*)name;
@end
