//
//  UILabel+Factory.m
//  BabySharing
//
//  Created by Alfred Yang on 8/12/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "UILabel+Factory.h"

@implementation UILabel (Factory)

#pragma mark -- UI
/**
 *  PS: fontSize.正常数值为细体/300+为正常/600+为粗体
 */
+ (UILabel*)creatLabelWithText:(NSString*)text textColor:(UIColor*)color fontSize:(CGFloat)font backgroundColor:(UIColor*)backgroundColor textAlignment:(NSTextAlignment)align {
	
	UILabel *label = [UILabel new];
	if (text){
		label.text = text;
	}
	label.textColor = color;
	label.textAlignment = align;
	label.numberOfLines = 0;
	
	if (font > 600.f) {
		label.font = kAYFontMedium(font - 600);
	} else if (font < 600.f && font > 300.f) {
		label.font = [UIFont systemFontOfSize:(font - 300)];
	} else {
		label.font = kAYFontLight(font);
	}
	
	if (backgroundColor) {
		label.backgroundColor = backgroundColor;
	}
	
//	label.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	
	return label;
}


@end
