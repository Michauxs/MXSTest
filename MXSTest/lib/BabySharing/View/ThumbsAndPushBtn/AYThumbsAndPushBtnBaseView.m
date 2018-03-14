//
//  AYThumbsAndPushBtnBaseView.m
//  BabySharing
//
//  Created by BM on 5/7/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYThumbsAndPushBtnBaseView.h"
#import "AYCommand.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYThumbsAndPushDefines.h"

@implementation AYThumbsAndPushBtnBaseView
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

@synthesize btn = _btn;
@synthesize label = _label;

@synthesize cell_index = _cell_index;
@synthesize post_id = _post_id;

#pragma mark -- commands
- (void)postPerform {
    [self addTarget:self action:@selector(selfClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn = [[UIImageView alloc]init];
    [self addSubview:self.btn];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
    
   
    self.label = [[UILabel alloc]init];
    self.label.font = [UIFont systemFontOfSize:12];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(30);
    }];
    
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

#pragma mark -- messages
- (void)selfClicked {
    @throw [[NSException alloc]initWithName:@"error" reason:@"cannot call base view" userInfo:nil];
}

- (id)changeCount:(id)obj {
    return nil;
}

- (id)changeBtnConnectInfo:(id)obj {
    NSDictionary* dic = (NSDictionary*)obj;
    self.post_id = [dic objectForKey:kAYThumbsPushBtnContentIDKey];
    self.cell_index = ((NSNumber*)[dic objectForKey:kAYThumbsPushBtnContentIndexKey]).integerValue;
    return nil;
}
@end
