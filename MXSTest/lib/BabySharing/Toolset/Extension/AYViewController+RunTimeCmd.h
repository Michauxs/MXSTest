//
//  AYViewController+RunTimeCmd.h
//  BabySharing
//
//  Created by Alfred Yang on 13/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYViewController.h"

@interface AYViewController (RunTimeCmd)

- (void)performAYSel:(NSString*)selector withResult:(NSObject**)obj;

@end
