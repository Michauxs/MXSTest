//
//  UIButton+Factory.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "UIButton+Factory.h"

@implementation UIButton (Factory)

/**
 *  PS: fontSize.正常数值为细体/300+为正常/600+为粗体
 */
+ (UIButton*)creatButtonWithTitle:(NSString*)title andTitleColor:(UIColor*)TitleColor andFontSize:(CGFloat)font andBackgroundColor:(UIColor*)backgroundColor {
	
	UIButton *btn = [UIButton new];
	if (title) {
		[btn setTitle:title forState:UIControlStateNormal];
	}
	[btn setTitleColor:TitleColor forState:UIControlStateNormal];
	
	if (font > 600.f) {
		btn.titleLabel.font = kAYFontMedium((font - 600));
	} else if (font < 600.f && font > 300.f) {
		btn.titleLabel.font = [UIFont systemFontOfSize:(font - 300)];
	} else {
		btn.titleLabel.font = kAYFontLight(font);
	}
	
	if (backgroundColor) {
		btn.backgroundColor = backgroundColor;
	} else
		btn.backgroundColor = [UIColor clearColor];
	
	return btn;
}

@end
