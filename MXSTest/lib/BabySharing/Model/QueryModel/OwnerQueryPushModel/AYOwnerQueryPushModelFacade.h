//
//  OwnerQueryModel.h
//  BabySharing
//
//  Created by Alfred Yang on 3/08/2015.
//  Copyright (c) 2015 BM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYModelFacade.h"
#import <UIKit/UIKit.h>

@interface AYOwnerQueryPushModelFacade : AYModelFacade

@property (strong, nonatomic) UIManagedDocument* doc;
@property (strong, nonatomic) NSArray* querydata;
@end
