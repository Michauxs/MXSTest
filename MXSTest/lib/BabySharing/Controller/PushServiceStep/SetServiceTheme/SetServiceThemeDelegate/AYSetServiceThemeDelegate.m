//
//  AYSetServiceThemeDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 29/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceThemeDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"

@implementation AYSetServiceThemeDelegate {
	NSString *secondaryCat;
	
    NSArray *titleArr;
	NSString *setedCourseStr;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
}

- (void)performWithResult:(NSObject**)obj {
    
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCommandTypeModule;
}

- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryDelegate;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

#pragma marlk -- commands
- (id)changeQueryData:(id)args {
	
    NSString *CatStr = [args objectForKey:kAYServiceArgsCat];
	if ([CatStr isEqualToString:kAYStringNursery]) {
		titleArr = kAY_service_options_title_nursery;
	} else if ([CatStr isEqualToString:kAYStringCourse]) {
		titleArr = kAY_service_options_title_course;
		
		secondaryCat = [args objectForKey:kAYServiceArgsCatSecondary];
		if (secondaryCat) {
			setedCourseStr = [args objectForKey:kAYServiceArgsCatThirdly];
		}
		
	} else {
		titleArr = @[@"参数设置错误"];
	}
	
	NSNumber *backArgs= [NSNumber numberWithInteger:titleArr.count];
    return backArgs;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name = @"AYSetServiceThemeCellView";
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    NSString *title = titleArr[indexPath.row];
	NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
	[tmp setValue:title forKey:@"title"];
		
	if (secondaryCat && [titleArr indexOfObject:secondaryCat] == indexPath.row) {
		[tmp setValue:setedCourseStr forKey:@"sub_title"];
	}
	
    kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    
    cell.controller = self.controller;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *tmp = [titleArr objectAtIndex:indexPath.row];
    kAYDelegateSendNotify(self, @"serviceThemeSeted:", &tmp)
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *head = [[UIView alloc]init];
    head.backgroundColor = [Tools garyLineColor];
//    UILabel *titleLabel = [Tools creatUILabelWithText:@"您想要发布什么主题" andTextColor:[Tools blackColor] andFontSize:17.f andBackgroundColor:nil andTextAlignment:NSTextAlignmentCenter];
//    [head addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(head);
//        make.centerY.equalTo(head);
//    }];
	
    return head;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.5;
    } else {
        return 0.001;
    }
}

#pragma mark -- notifies set service info


@end
