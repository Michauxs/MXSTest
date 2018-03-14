//
//  AYOrderInfoDelegate.m
//  BabySharing
//
//  Created by Alfred Yang on 12/9/16.
//  Copyright © 2016年 Alfred Yang. All rights reserved.
//

#import "AYBOrderMainDelegate.h"
#import "AYCommandDefines.h"
#import "AYFactoryManager.h"
#import "AYResourceManager.h"
#import "AYViewCommand.h"
#import "AYViewNotifyCommand.h"
#import "AYFacadeBase.h"

@implementation AYBOrderMainDelegate {
    NSDictionary *querydata;
	NSDictionary *service_info;
	NSMutableArray *order_times;
	
    BOOL isSetedDate;
    BOOL isExpend;
    
    NSNumber *setedDate;
    NSDictionary *setedTimes;
	
	NSArray *sectionTitles;
}

@synthesize para = _para;
@synthesize controller = _controller;
@synthesize commands = _commands;
@synthesize notifies = _notiyies;

#pragma mark -- life cycle
- (void)postPerform {
	sectionTitles = @[@"服务时间", @"价格", @"支付方式"];
}

- (void)performWithResult:(NSObject**)obj {
    
}

#pragma mark -- commands
- (NSString*)getViewType {
    return kAYFactoryManagerCatigoryView;
}

- (NSString*)getViewName {
    return [NSString stringWithUTF8String:object_getClassName([self class])];
}

- (NSString*)getCommandType {
    return kAYFactoryManagerCatigoryView;
}

- (id)changeQueryData:(NSDictionary*)info {
    querydata = info;
	service_info = [querydata objectForKey:kAYServiceArgsInfo];
	order_times = [querydata objectForKey:@"order_times"];
    return nil;
}

- (id)setOrderDate:(id)args {
    setedDate = (NSNumber*)args;
    if (!setedTimes) {
        NSMutableDictionary *tmp = [[NSMutableDictionary alloc]init];
        [tmp setValue:@"10:00" forKey:@"start"];
        [tmp setValue:@"12:00" forKey:@"end"];
        setedTimes = [tmp copy];
    }
    return nil;
}

- (id)TransfromExpend {
    isExpend = !isExpend;
    return nil;
}

#pragma mark -- table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	}
	else if (section == 1) {
		return order_times.count;
	}
	else if (section == 2) {
		return 1;
	} else {
		return 2;
	}
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<AYViewBase> cell;
    
    if (indexPath.section == 0) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderMainHeadCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSDictionary *tmp = [service_info copy];
		kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
        
    } else if (indexPath.section == 1) {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderMainDateCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
		
		NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
		[tmp setValue:[NSNumber numberWithBool:NO] forKey:@"is_last"];
		[tmp setValue:[order_times objectAtIndex:indexPath.row] forKey:@"order_time"];
		if (indexPath.row == order_times.count - 1) {
			[tmp setValue:[NSNumber numberWithBool:YES] forKey:@"is_last"];
		}
        kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
        
    } else {
        NSString* class_name = [[kAYFactoryManagerControllerPrefix stringByAppendingString:@"BOrderMainPriceCell"] stringByAppendingString:kAYFactoryManagerViewsuffix];
        cell = [tableView dequeueReusableCellWithIdentifier:class_name forIndexPath:indexPath];
        
        NSMutableDictionary *tmp = [querydata copy];
		kAYViewSendMessage(cell, @"setCellInfo:", &tmp)
        
    }
    
    cell.controller = self.controller;
    ((UITableViewCell*)cell).selectionStyle = UITableViewCellSelectionStyleNone;
    ((UITableViewCell*)cell).clipsToBounds = YES;
    return (UITableViewCell*)cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return 84.f;
	}
	else if (indexPath.section == 1) {
		return 85.f;
	}
	else if (indexPath.section == 2) {
		return 110.f;
	}
	else {
		return 50.f;
	}
//    if (indexPath.row == 0) {
//        return 110.f;
//    } else if (indexPath.row == 1) {
//        
//        return setedDate?95.f:85.f;
//        
//    } else if (indexPath.row == 2) {
//        
//        return isExpend?150.f:90.f;
//        
//    } else {
//        return 100.f;
//    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView *headView = [[UIView alloc]init];
	headView.backgroundColor = [Tools garyBackgroundColor];
	if (section > 0) {
		
		UILabel *titleLabel = [Tools creatLabelWithText:[sectionTitles objectAtIndex:section - 1] textColor:[Tools black] fontSize:315.f backgroundColor:nil textAlignment:NSTextAlignmentCenter];
		[headView addSubview:titleLabel];
		[titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(headView);
			make.centerX.equalTo(headView);
		}];
	}
	
	return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 0.001f;
	} else {
		return 64.f;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (indexPath.section == 1) {
//		
//		NSNumber *service_cat = [service_info objectForKey:kAYServiceArgsCat];
//		if (service_cat.intValue == ServiceTypeCourse) {
//			return;
//		}
//		else {
//			NSNumber *note = [NSNumber numberWithInteger:indexPath.row];
//			kAYDelegateSendNotify(self, @"setOrderTime:", &note)
//		}
//		
//	}
}

@end
