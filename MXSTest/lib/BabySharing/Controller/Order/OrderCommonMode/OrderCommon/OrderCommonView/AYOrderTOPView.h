//
//  AYAppliFBTopView.h
//  BabySharing
//
//  Created by Alfred Yang on 4/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : int {
	OrderModeCommon = 0,
	OrderModeServant = 1,
} OrderMode;

@interface AYOrderTOPView : UIView
- (instancetype)initWithFrame:(CGRect)frame andMode:(OrderMode)mode;
- (void)setItemArgs:(id)args;
@end
