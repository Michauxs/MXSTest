//
//  AYPickerView.h
//  BabySharing
//
//  Created by Alfred Yang on 13/7/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYViewBase.h"
#import <UIKit/UIKit.h>

@interface AYPickerView : UIView <AYViewBase>
@property(nonatomic, strong) UIPickerView *pickerView;
@end

@interface AYPicker2View : AYPickerView

@end
