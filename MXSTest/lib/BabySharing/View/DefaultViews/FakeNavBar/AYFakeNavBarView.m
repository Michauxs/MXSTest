//
//  AYFakeNavBarView.m
//  BabySharing
//
//  Created by Alfred Yang on 4/11/16.
//  Copyright © 2016 Alfred Yang. All rights reserved.
//

#import "AYFakeNavBarView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"

@implementation AYFakeNavBarView {
    UIButton* leftBtn;
    UIButton* rightBtn;
	UILabel *titleView;
	UIView *BotLine;
}
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- commands
- (void)postPerform {
    {
        leftBtn = [[UIButton alloc]init];
		[leftBtn setImage:IMGRESOURCE(@"bar_left_black") forState:UIControlStateNormal];
        [self addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(-4);
            make.width.equalTo(@36);
            make.height.equalTo(@36);
        }];
		
		[leftBtn addTarget:self action:@selector(didSelectLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    }
	
    {
        rightBtn = [[UIButton alloc]init];
		[rightBtn setImage:IMGRESOURCE(@"profile_setting_dark") forState:UIControlStateNormal];
        [self addSubview:rightBtn];
		
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-10.5f);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
		[rightBtn addTarget:self action:@selector(didSelectRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
	
	titleView = [Tools creatLabelWithText:@"" textColor:[Tools black] fontSize:618.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[self addSubview:titleView];
	[titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.centerY.equalTo(self);
		make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH - 160);
	}];
	titleView.hidden  = YES;
	
	BotLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5)];
	[self addSubview:BotLine];
	BotLine.backgroundColor = [Tools garyLineColor];
	[BotLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self);
		make.centerX.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 0.5));
	}];
	BotLine.hidden = YES;
	
    self.backgroundColor = [UIColor colorWithRED:250 GREEN:250 BLUE:250 ALPHA:1];
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

- (void)layoutSubviews {
	[super layoutSubviews];
	
}

#pragma mark -- 
- (id)setTitleText:(id)args {
    
    NSString *title = (NSString*)args;
	titleView.hidden = NO;
    titleView.text = title;
    return nil;
}

- (id)setTitleTextColor:(id)args {
	
	titleView.textColor = args;
	return nil;
}

- (id)setBackGroundColor:(id)args {
	
    UIColor* c = (UIColor*)args;
    self.backgroundColor = c;
    return nil;
}

- (id)setLeftBtnImg:(id)args {
    
    UIImage* img = (UIImage*)args;
    [leftBtn setImage:img forState:UIControlStateNormal];
	
    return nil;
}

- (id)setRightBtnImg:(id)args {

    UIImage* img = (UIImage*)args;
    [rightBtn setImage:img forState:UIControlStateNormal];
	
    return nil;
}

- (id)setLeftBtnWithBtn:(id)args {
	
    UIButton* btn = (UIButton*)args;
    [leftBtn removeFromSuperview];
	
    [btn addTarget:self action:@selector(didSelectLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    leftBtn = btn;
    [self addSubview:btn];
    
    return nil;
}

- (id)setRightBtnWithBtn:(id)args {
	
    UIButton* btn = (UIButton*)args;
    [rightBtn removeFromSuperview];
    
    [btn addTarget:self action:@selector(didSelectRightBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-18.f);
        make.size.mas_equalTo(CGSizeMake(btn.bounds.size.width, btn.bounds.size.height));
    }];
	rightBtn = btn;
	
    return nil;
}

- (id)setLeftBtnVisibility:(id)args {
    BOOL bHidden = ((NSNumber*)args).boolValue;
    leftBtn.hidden = bHidden;
    return nil;
}

- (id)setRightBtnVisibility:(id)args {
    BOOL bHidden = ((NSNumber*)args).boolValue;
    rightBtn.hidden = bHidden;
    return nil;
}

- (id)setBarBotLine {
	BotLine.hidden = NO;
    return nil;
}

- (id)hideBarBotLine {
	BotLine.hidden = YES;
	return nil;
}

#pragma mark -- notify
- (void)didSelectLeftBtn {
    id<AYCommand> n = [self.notifies objectForKey:@"leftBtnSelected"];
    [n performWithResult:nil];
}

- (void)didSelectRightBtn {
    id<AYCommand> n = [self.notifies objectForKey:@"rightBtnSelected"];
    [n performWithResult:nil];
}
@end
