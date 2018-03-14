//
//  AYServTimesBtn.h
//  BabySharing
//
//  Created by Alfred Yang on 27/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AYServTimesBtn : UIButton

- (instancetype)initWithOffsetX:(CGFloat)offsetX andTimesDic:(NSDictionary*)args;

@property (nonatomic, strong) NSDictionary *dic_times;

@end
