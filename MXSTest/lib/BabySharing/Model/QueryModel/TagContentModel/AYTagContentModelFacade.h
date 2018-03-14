//
//  AYTagContentMoodelFacade.h
//  BabySharing
//
//  Created by BM on 4/25/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYModelFacade.h"

@interface AYTagContentModelFacade : AYModelFacade
@property (strong, nonatomic) UIManagedDocument* doc;
@property (strong, nonatomic) NSArray* querydata;
@end
