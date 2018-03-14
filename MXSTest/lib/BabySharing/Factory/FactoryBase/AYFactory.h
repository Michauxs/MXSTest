//
//  AYFactory.h
//  BabySharing
//
//  Created by Alfred Yang on 3/22/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#ifndef AYFactory_h
#define AYFactory_h

#import <Foundation/Foundation.h>

typedef void(^performFinishBlock)(NSDictionary*);

@protocol AYFactory <NSObject>

@property (nonatomic, strong) NSDictionary* para;

+ (id)factoryInstance;
- (id)createInstance;
//- (id)createInstanceWithProperty:(NSDictionary*)para;
@end
#endif /* AYFactory_h */
