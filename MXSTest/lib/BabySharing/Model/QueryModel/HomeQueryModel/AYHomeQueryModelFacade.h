//
//  AYHomeQueryModelFacade.h
//  BabySharing
//
//  Created by Alfred Yang on 4/14/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYModelFacade.h"
#import <UIKit/UIKit.h>

@interface AYHomeQueryModelFacade : AYModelFacade
@property (strong, nonatomic) UIManagedDocument* doc;
@property (strong, nonatomic) NSArray* querydata;
@end
