//
//  AYPostContentCommand.m
//  BabySharing
//
//  Created by Alfred Yang on 4/21/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYPostContentCommand.h"

@implementation AYPostContentCommand

- (void)postPerform {
    NSLog(@"host path is : %@", self.route);
}

- (void)beforeAsyncCall {

}

- (void)endAsyncCall {
    
}
@end
