//
//  AYPlayItemsView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/6/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPlayItemsView.h"

@implementation AYPlayItemsView {
	UIButton *iconBtn;
}

- (instancetype)initWithTitle:(NSString*)title andIconName:(NSString*)iconName {
    self = [super init];
    if (self) {
		
		iconBtn = [[UIButton alloc] init];
		[iconBtn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
		[iconBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_enable", iconName]] forState:UIControlStateSelected];
		iconBtn.userInteractionEnabled = NO;
		[self addSubview:iconBtn];
        [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(4);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(25, 25));
        }];
        
        UILabel *titleLabel = [UILabel creatLabelWithText:title textColor:[UIColor gary115] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-4);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

- (void)setEnableStatusWith:(BOOL)isEnable {
	
	iconBtn.selected = isEnable;
	
}

@end
