//
//  AYAddTimeSignView.h
//  BabySharing
//
//  Created by Alfred Yang on 12/10/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum:int {
	AYAddTMSignStateUnable = 0,
	AYAddTMSignStateEnable = 1,
	AYAddTMSignStateHead = 2,
}AYAddTMSignState;

@interface AYAddTimeSignView : UIView

@property (nonatomic, assign) AYAddTMSignState state;

- (instancetype)initWithTitle:(NSString*)title;


@end
