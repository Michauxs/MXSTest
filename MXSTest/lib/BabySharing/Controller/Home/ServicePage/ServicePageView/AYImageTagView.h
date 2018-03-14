//
//  AYImageTagView.h
//  BabySharing
//
//  Created by Alfred Yang on 4/1/18.
//  Copyright © 2018年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYImageTagView : UIView

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) UILabel *label;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;


@end
