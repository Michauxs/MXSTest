//
//  AYSetServiceCapacityDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 29/11/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYSetServiceCapacityDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYSelfSettingCellDefines.h"
#import <CoreLocation/CoreLocation.h>

@implementation AYSetServiceCapacityDelegate {
    NSMutableArray *titleArr;
}

#pragma mark -- command
@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

- (void)postPerform {
    
    titleArr = [NSMutableArray arrayWithObjects:@"可以接纳最小孩子年龄", @"可以接纳最大孩子年龄", @"最多接纳孩子数量", @"服务者数量", nil];
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
	NSString *serviceCat = [[args objectForKey:kAYServiceArgsCategoryInfo] objectForKey:kAYServiceArgsCat];
    if ([serviceCat isEqualToString:kAYStringCourse]) {
        [titleArr replaceObjectAtIndex:3 withObject:@"老师数量"];
    }
    return nil;
}

#pragma mark -- table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* class_name = @"AYSetServiceCapacityCellView";
    id<AYViewBase> cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
    
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
    [tmp setValue:titleArr[indexPath.row] forKey:@"title"];
    [tmp setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"index"];
    
    kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSNumber *tmp = [NSNumber numberWithInteger:indexPath.row];
//    kAYDelegateSendNotify(self, @"serviceThemeSeted:", &tmp)
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *head = [[UIView alloc]init];
	head.backgroundColor = [Tools whiteColor];
	UILabel *titleLabel = [Tools creatLabelWithText:@"更多信息" textColor:[Tools theme] fontSize:624.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
	[head addSubview:titleLabel];
	[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(head);
		make.centerY.equalTo(head);
	}];
	
	return head;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 80.f;
}

#pragma mark -- notifies set service info


@end
