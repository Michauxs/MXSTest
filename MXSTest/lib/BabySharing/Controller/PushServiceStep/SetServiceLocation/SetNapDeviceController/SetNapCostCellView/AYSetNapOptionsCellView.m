//
//  AYSetNapOptionsCellView.m
//  BabySharing
//
//  Created by Alfred Yang on 23/8/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetNapOptionsCellView.h"
#import "AYCommandDefines.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYFactoryManager.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"
#import "AYRemoteCallCommand.h"
#import "AYModelFacade.h"

#import "AYCourseSignView.h"

@implementation AYSetNapOptionsCellView {
	
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
		
        if (reuseIdentifier != nil) {
            [self setUpReuseCell];
        }
    }
    return self;
}


#pragma mark -- life cycle
- (void)setUpReuseCell {
    id<AYViewBase> cell = VIEW(@"SetNapOptionsCell", @"SetNapOptionsCell");
    
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
	kAYViewSendNotify(self, @"didFacilityOptViewTap:", &tapView)
}

- (id)setCellInfo:(id)args {
	
	NSArray *courseSignArr = [args objectForKey:@"model"];
	NSArray *comphandle = [args objectForKey:@"handle"];
	
	int row = 0, col = 0, colNumbInRow = 3;
	
	CGFloat itemWith = 77;
	CGFloat itemHeight = 33;
	CGFloat marginX = 25;
	CGFloat marginY = 12;
	
	for (int i = 0; i < courseSignArr.count; ++i) {
		row = i / colNumbInRow;
		col = i % colNumbInRow;
		NSString *title = [courseSignArr objectAtIndex:i];
		AYCourseSignView *signView;
		if ([title isEqualToString:@"纯净水过滤系统"]) {
			itemWith = 125;
			signView = [[AYCourseSignView alloc] initWithFrame:CGRectMake(20+col*(marginX+77), 10+row*(marginY+itemHeight), itemWith, itemHeight) andTitle:title];
		} else {
			itemWith = 77;
			signView = [[AYCourseSignView alloc] initWithFrame:CGRectMake(20+col*(marginX+itemWith), 10+row*(marginY+itemHeight), itemWith, itemHeight) andTitle:title];
		}
		
		[self addSubview:signView];
		
		signView.userInteractionEnabled = YES;
		[signView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSignViewTap:)]];
		
		if ([comphandle containsObject:title]) {
			[signView setSelectStatus];
		}
		
	}
	
	return nil;
}

@end
