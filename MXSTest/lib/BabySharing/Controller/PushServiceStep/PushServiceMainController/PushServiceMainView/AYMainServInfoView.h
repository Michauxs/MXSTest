//
//  AYMainServInfoView.h
//  BabySharing
//
//  Created by Alfred Yang on 15/9/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didViewTap)(void);

@interface AYMainServInfoView : UIView

@property (nonatomic, copy) didViewTap tapBlocak;

@property (nonatomic, assign) BOOL isReady;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTapBlock:(didViewTap)block;

- (void)hideCheckSign;
- (void)setTitleWithString:(NSString*)title;

@end
