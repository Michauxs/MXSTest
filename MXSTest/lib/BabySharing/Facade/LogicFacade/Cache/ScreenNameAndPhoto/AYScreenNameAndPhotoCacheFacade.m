//
//  AYScreeNameAndPhotoCacheFacade.m
//  BabySharing
//
//  Created by BM on 4/23/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYScreenNameAndPhotoCacheFacade.h"

@implementation AYScreenNameAndPhotoCacheFacade
@synthesize head_lst = _head_lst;

- (void)postPerform {
    self.head_lst = [[NSMutableArray alloc]init];
}
@end
