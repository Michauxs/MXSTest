//
//  AYServicePriceCatBtn.m
//  BabySharing
//
//  Created by Alfred Yang on 10/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYServicePriceCatBtn.h"

@implementation AYServicePriceCatBtn {
	CALayer *btmLayer;
}

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title {
	
	if (self = [super initWithFrame:frame]) {
		[self setTitle:title forState:UIControlStateNormal];
		[self setTitleColor:[Tools black] forState:UIControlStateNormal];
		[self setTitleColor:[Tools theme] forState:UIControlStateSelected];
		
		btmLayer = [[CALayer alloc] init];
		btmLayer.frame = CGRectMake((frame.size.width-16)*0.5, frame.size.height-3, 16, 3);
		btmLayer.backgroundColor = [Tools theme].CGColor;
		
	}
	return  self;
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (self.selected) {
		[self.layer addSublayer:btmLayer];
	} else {
		[btmLayer removeFromSuperlayer];
	}
	
}

@end
