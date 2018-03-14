//
//  AYPersonalDescCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 27/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYPersonalDescCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYControllerActionDefines.h"
#import "AYRemoteCallCommand.h"

#define WIDTH               SCREEN_WIDTH - 15*2

@implementation AYPersonalDescCellView {
	
	UILabel *userNameLabel;
    UILabel *titleLabel;
    UILabel *descLabel;
}

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

#pragma mark -- life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		userNameLabel = [UILabel creatLabelWithText:@"User Name" textColor:[UIColor black] fontSize:626 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
		[self addSubview:userNameLabel];
		[userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self).offset(SCREEN_MARGIN_LR);
			make.top.equalTo(self).offset(50);
		}];
		
        titleLabel = [UILabel creatLabelWithText:@"关于我" textColor:[UIColor black] fontSize:615 backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userNameLabel);
			make.top.equalTo(userNameLabel.mas_bottom).offset(28);
        }];
        
        descLabel = [UILabel creatLabelWithText:@"Personal intruduction" textColor:[UIColor gary115] fontSize:314.f backgroundColor:nil textAlignment:NSTextAlignmentLeft];
        descLabel.numberOfLines = 0;
        [self addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(userNameLabel);
			make.top.equalTo(titleLabel.mas_bottom).offset(4);
			make.right.equalTo(self).offset(-SCREEN_MARGIN_LR);
			make.bottom.equalTo(self).offset(-30);
        }];
		
    }
    
    return self;
}



#pragma mark -- actions
- (void)didServiceDetailClick:(UIGestureRecognizer*)tap {
    id<AYCommand> cmd = [self.notifies objectForKey:@"didServiceDetailClick"];
    [cmd performWithResult:nil];
}

#pragma mark -- messages
- (id)setCellInfo:(id)args {
	
    NSString *user_name = [args objectForKey:kAYProfileArgsScreenName];
	if (user_name.length != 0) {
		userNameLabel.text = user_name;
	}
    
    NSString *descStr = [args objectForKey:kAYProfileArgsDescription];
    if (descStr.length != 0) {
        descLabel.text = descStr;
		descLabel.textColor = [UIColor gary115];
	} else {
		descLabel.text = @"一句话很短，高调的夸一夸自己";
		descLabel.textColor = [UIColor gary166];
	}
    
    return nil;
}

@end
