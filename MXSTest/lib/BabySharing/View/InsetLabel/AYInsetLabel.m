//
//  AYInsetLabel.m
//  BabySharing
//
//  Created by Alfred Yang on 31/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYInsetLabel.h"

@implementation AYInsetLabel

- (instancetype)initWithTitle:(NSString*)title andTextColor:(UIColor*)textColor andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor {
    if (self = [super init]) {
        
        self.text  = title;
        self.textColor = textColor;
        self.font = kAYFontLight(font);
        self.backgroundColor = backgroundColor;
        
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
