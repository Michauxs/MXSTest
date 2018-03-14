//
//  AYShadowRadiusView.m
//  BabySharing
//
//  Created by Alfred Yang on 10/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYShadowRadiusView.h"

@implementation AYShadowRadiusView

- (instancetype)initWithRadius:(CGFloat)radius {
	
	self = [super init];
	if (self) {
		
		self.layer.cornerRadius = radius;
		self.layer.shadowColor = [Tools garyColor].CGColor;
		self.layer.shadowRadius = 3.f;
		self.layer.shadowOpacity = 0.5f;
		self.layer.shadowOffset = CGSizeMake(0, 0);
		self.backgroundColor = [Tools whiteColor];
		
		_radiusBGView = [[UIView alloc] init];
		[self addSubview:_radiusBGView];
		[_radiusBGView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.edges.equalTo(self);
		}];
		[Tools setViewBorder:_radiusBGView withRadius:radius andBorderWidth:0 andBorderColor:nil andBackground:[Tools whiteColor]];
		
	}
	return  self;
}

@end
