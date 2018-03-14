//
//  AYAlertTipView.m
//  BabySharing
//
//  Created by Alfred Yang on 29/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYAlertTipView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYAlertView.h"

@implementation AYAlertTipView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

#pragma mark -- commands
- (void)touchUpInside {
    id<AYCommand> cmd = [self.notifies objectForKey:@"touchUpInside"];
    [cmd performWithResult:nil];
}

- (id)setAlertTipInfo:(NSDictionary*)args {
    
    UIView *superView = [args objectForKey:@"super_view"];
    NSString *title = [args objectForKey:@"title"];
    NSNumber *set_y = [args objectForKey:@"set_y"];
    
    UILabel *titleLabel = [Tools creatLabelWithText:title textColor:[Tools black] fontSize:12.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
    [titleLabel sizeToFit];
     CGSize titleSize = titleLabel.frame.size;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [superView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(set_y.floatValue);
        make.centerX.equalTo(superView);
        make.size.mas_equalTo(CGSizeMake(titleSize.width+60, 40));
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
    return nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 20.f;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.5];
    }
    return self;
}
@end
