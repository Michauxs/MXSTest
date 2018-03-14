//
//  AYServicePageBtmView.h
//  BabySharing
//
//  Created by Alfred Yang on 24/8/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYServicePageBtmView : UIView

@property (nonatomic, strong) UIButton *chatBtn;
@property (nonatomic, strong) UIButton *bookBtn;

- (void)setViewWithData:(NSDictionary*)service_info;

@end
