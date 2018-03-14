//
//  AYCapacityUnitView.h
//  BabySharing
//
//  Created by Alfred Yang on 3/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYCapacityUnitView : UIView

- (instancetype)initWithIcon:(NSString*)name title:(NSString*)title info:(NSString*)info;

- (void)info:(NSDictionary*)info atIndex:(int)index;

@end
