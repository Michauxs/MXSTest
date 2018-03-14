//
//  AYWeekDayBtnView.m
//  BabySharing
//
//  Created by Alfred Yang on 22/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYWeekDayBtn.h"

@implementation AYWeekDayBtn

- (instancetype)initWithTitle:(NSString*)title {
    self = [super init];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[Tools black] forState:UIControlStateNormal];
        self.titleLabel.font = kAYFontMedium(15);
        
        self.layer.cornerRadius = 30 * 0.5;
        self.clipsToBounds = YES;
        self.layer.borderColor = [Tools whiteColor].CGColor;
        self.layer.borderWidth = 0.f;
        self.layer.backgroundColor = [Tools whiteColor].CGColor;
    }

    return self;
}

- (void)setStates:(WeekDayBtnState)states {
	_states = states;
    switch (states) {
		case WeekDayBtnStateNormal:
		{
			[self setTitleColor:[Tools black] forState:UIControlStateNormal];
			self.layer.borderWidth = 0.f;
			self.layer.backgroundColor = [UIColor clearColor].CGColor;
			self.titleLabel.font = kAYFontMedium(15);
		}
			break;
		case WeekDayBtnStateNormalAnimat:
		{
			[self setTitleColor:[Tools black] forState:UIControlStateNormal];
			self.layer.borderWidth = 0.f;
			self.layer.backgroundColor = [UIColor clearColor].CGColor;
			[UIView animateWithDuration:0.5 animations:^{
				self.titleLabel.font = kAYFontMedium(15);
			}];
		}
			break;
        case WeekDayBtnStateSelected:
        {
            [self setTitleColor:[Tools whiteColor] forState:UIControlStateNormal];
            self.layer.borderWidth = 0.f;
            self.layer.backgroundColor = [Tools theme].CGColor;
        }
            break;
		case WeekDayBtnStateSeted:
		{
			[self setTitleColor:[Tools theme] forState:UIControlStateNormal];
			self.layer.borderColor = [Tools theme].CGColor;
			self.layer.borderWidth = 1.f;
			self.layer.backgroundColor = [Tools whiteColor].CGColor;
		}
			break;case WeekDayBtnStateSmall:
		{
			[self setTitleColor:[Tools black] forState:UIControlStateNormal];
			self.layer.borderWidth = 0.f;
			self.layer.backgroundColor = [Tools whiteColor].CGColor;
//			[UIView animateWithDuration:0.5 animations:^{
//			}];
			self.titleLabel.font = [UIFont systemFontOfSize:11];
		}
			break;
        default:
            break;
    }
}

@end
