//
//  AYServiceCategOptView.h
//  BabySharing
//
//  Created by Alfred Yang on 14/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYServiceCategOptView : UIView

@property (nonatomic, strong) NSString *optArgs;
@property (nonatomic, strong) NSString *subArgs;

- (instancetype)initWithTitle:(NSString*)titleStr;

@end
