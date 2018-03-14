//
//  AYLoadingView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/26/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYLoadingView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "UIGifView.h"

@implementation AYLoadingView {
    UIGifView* gif;
    
    CGFloat _timeCount;
    NSTimer *_timer;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, 0, width, height);
    
    NSURL* url = GIFRESOURCE(@"home_refresh");
    gif = [[UIGifView alloc]initWithCenter:CGPointMake(width / 2, height / 2) fileURL:url andSize:CGSizeMake(30, 30)];
    [self addSubview:gif];
    
    self.hidden = NO;
//    self.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.75];
    self.backgroundColor = [UIColor clearColor];
//    self.userInteractionEnabled = NO;
    
//    _timeCount = 0;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeGoes) userInfo:nil repeats:YES];
////    [_timer fire];
//    [_timer setFireDate:[NSDate distantFuture]];
    
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

- (id)startGif {
//    [_timer setFireDate:[NSDate distantPast]];
    [gif startGif];
    return nil;
}

- (id)stopGif {
//    [_timer setFireDate:[NSDate distantFuture]];
//    [_timer invalidate];
//    _timer = nil;
//    
//    _timeCount = 0;
    [gif stopGif];
    return nil;
}

//
- (void)timeGoes {
    _timeCount++ ;
    if (_timeCount >= 5) {
        [self stopGif];
        [[[UIAlertView alloc] initWithTitle:@"错误" message:@"请检查网络是否正常连接" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil] show];
    }
}
@end
