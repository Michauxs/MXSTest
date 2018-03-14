//
//  OrderTimesOptionView.m
//  BabySharing
//
//  Created by Alfred Yang on 13/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "OrderTimesOptionView.h"

@implementation OrderTimesOptionView

- (instancetype)initWithTitle:(NSString*)title {
    self = [super init];
    if (self) {
		
        _titleLabel = [Tools creatLabelWithText:title textColor:[Tools theme] fontSize:14.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.centerX.equalTo(self);
        }];
		
        _timeLabel = [Tools creatLabelWithText:nil textColor:[Tools theme] fontSize:26.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
        [self addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
            make.centerX.equalTo(self);
        }];
        
    }
    return self;
}

- (void)setStates:(int)states {
    _states = states;
    
    switch (states) {
        case 0:
        {
            self.backgroundColor = [UIColor whiteColor];
            _titleLabel.textColor = _timeLabel.textColor = [Tools theme];
        }
            break;
        case 1:
        {
            self.backgroundColor = [Tools theme];
            _titleLabel.textColor = _timeLabel.textColor = [UIColor whiteColor];
        }
            break;
            
        default:
            break;
    }
}

@end
