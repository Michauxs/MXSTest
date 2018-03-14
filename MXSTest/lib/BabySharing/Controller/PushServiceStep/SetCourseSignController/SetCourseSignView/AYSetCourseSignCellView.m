//
//  AYSetCourseSignCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 10/12/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetCourseSignCellView.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYCourseSignView.h"

@implementation AYSetCourseSignCellView {
	
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"SetCourseSignCell", @"SetCourseSignCell");
    
    NSMutableDictionary* arr_commands = [[NSMutableDictionary alloc]initWithCapacity:cell.commands.count];
    for (NSString* name in cell.commands.allKeys) {
        AYViewCommand* cmd = [cell.commands objectForKey:name];
        AYViewCommand* c = [[AYViewCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_commands setValue:c forKey:name];
    }
    self.commands = [arr_commands copy];
    
    NSMutableDictionary* arr_notifies = [[NSMutableDictionary alloc]initWithCapacity:cell.notifies.count];
    for (NSString* name in cell.notifies.allKeys) {
        AYViewNotifyCommand* cmd = [cell.notifies objectForKey:name];
        AYViewNotifyCommand* c = [[AYViewNotifyCommand alloc]init];
        c.view = self;
        c.method_name = cmd.method_name;
        c.need_args = cmd.need_args;
        [arr_notifies setValue:c forKey:name];
    }
    self.notifies = [arr_notifies copy];
}

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

#pragma mark -- actions
- (void)didSignViewTap:(UITapGestureRecognizer*)tap {
	UIView *tapView = tap.view;
	NSString *sign = ((AYCourseSignView*)tapView).sign;
	kAYViewSendNotify(self, @"didCourseSignViewTap:", &sign)
}

- (id)setCellInfo:(id)args {
	
	NSArray *courseSignArr = [args objectForKey:@"model"];
	NSString *comphandle = [args objectForKey:@"handle"];
	
	int row = 0, col = 0;
	CGFloat itemWith = (SCREEN_WIDTH - 40 - 24)/4;
	CGFloat itemHeight = 33;
	for (int i = 0; i < courseSignArr.count; ++i) {
		row = i/4;
		col = i%4;
		AYCourseSignView *signView = [[AYCourseSignView alloc] initWithFrame:CGRectMake(20+col*(8+itemWith), 10+row*(8+itemHeight), itemWith, itemHeight) andTitle:[courseSignArr objectAtIndex:i]];
		[self addSubview:signView];
		
		signView.userInteractionEnabled = YES;
		[signView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSignViewTap:)]];
		
		if ([comphandle isEqualToString:[courseSignArr objectAtIndex:i]]) {
			[signView setSelectStatus];
		}
		
	}
    
    return nil;
}

@end
