//
//  AYPlayItemsView.h
//  BabySharing
//
//  Created by Alfred Yang on 22/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYPlayItemsView : UIView
- (instancetype)initWithTitle:(NSString*)title andIconName:(NSString*)iconName;

- (void)setEnableStatusWith:(BOOL)isEnable;

@end
