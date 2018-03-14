//
//  AYBOApplyBackView.m
//  BabySharing
//
//  Created by Alfred Yang on 3/5/17.
//  Copyright © 2017年 Alfred Yang. All rights reserved.
//

#import "AYRemoteBackView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYFacadeBase.h"

@implementation AYRemoteBackView {
	UILabel *tipsLabel;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle


#pragma mark -- commands
- (void)postPerform {
	
	UIImageView *iconView = [[UIImageView alloc] initWithImage:IMGRESOURCE(@"checked_icon")];
	[self addSubview:iconView];
	[iconView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self);
		make.centerX.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(30, 30));
	}];
	
	tipsLabel = [Tools creatLabelWithText:@"This is Tips Context" textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[self addSubview:tipsLabel];
	[tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self);
		make.top.equalTo(iconView.mas_bottom).offset(25);
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

#pragma mark -- actions


#pragma mark -- messages
- (id)setCellInfo:(id)args {
		
	NSString *tipsStr = [args objectForKey:kAYCommArgsTips];
	if (tipsStr && ![tipsStr isEqualToString:@""]) {
		tipsLabel.text = tipsStr;
	}
	
	return nil;
}

@end
