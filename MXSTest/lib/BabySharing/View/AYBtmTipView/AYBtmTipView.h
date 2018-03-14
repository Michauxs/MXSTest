//
//  AYBtmTipView.h
//  BabySharing
//
//  Created by Alfred Yang on 11/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AYBtmTipView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIButton *closeBtn;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)replaceInterfaceBtnWithString:(NSString*)title;
- (void)replaceCertainBtn;
@end
